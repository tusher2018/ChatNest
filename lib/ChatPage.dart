import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frist_project/ChatRoomModel.dart';
import 'package:frist_project/MassageModel.dart';
import 'package:frist_project/homepage.dart';
import 'package:frist_project/usermodel.dart';


class chatPage extends StatefulWidget {

  final UserModel targetUser;
  final ChatRoomModel chatroomModel;
  final UserModel userModel;
  final User firebaseUser;


  chatPage({required this.userModel,required this.chatroomModel,
    required this.firebaseUser,required this.targetUser});

  @override
  State<chatPage> createState() => _chatPageState();
}

class _chatPageState extends State<chatPage> {

  TextEditingController massageController=TextEditingController();


  void sendMassage(){
    String massage=massageController.text.trim();

    if(massage.isNotEmpty){

      String? newMassageId="${widget.chatroomModel.roomId}_${widget.userModel.uid}_${DateTime.now().toString()}";

      MassageModel massagemodel=MassageModel(
        massage: massage,
        seen: false,
        time: DateTime.now(),
        sender: widget.userModel.uid.toString(),
        massageId: newMassageId
      );

      FirebaseFirestore.instance.collection("ChatRooms").doc(widget.chatroomModel.roomId).
      collection("Massages").doc(newMassageId).set(massagemodel.toMap());
      widget.chatroomModel.lastMassage=massage;
      FirebaseFirestore.instance.collection("ChatRooms").doc(widget.chatroomModel.roomId).
      set(widget.chatroomModel.toMap());


      massageController.text="";

    }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text("${widget.targetUser.name}",style: TextStyle(fontStyle: FontStyle.italic),),
        automaticallyImplyLeading: false,
        titleTextStyle: const TextStyle(fontStyle: FontStyle.italic),
        actions: [
          CupertinoButton(child: Icon(Icons.close), onPressed: (){
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
              return homepage(usermodel: widget.userModel, firebaseuser: widget.firebaseUser);
            }));
          })
        ],

      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
                child: Container(
                  child: StreamBuilder(
                    stream:
                    FirebaseFirestore.instance.collection("ChatRooms").
                    doc(widget.chatroomModel.roomId).collection("Massages").
                    orderBy("time",descending: true).snapshots(),

                    builder: ((context, snapshot) {
                      if(snapshot.connectionState==ConnectionState.active){

                        if(snapshot.hasData){
                          QuerySnapshot qs=snapshot.data
                          as QuerySnapshot;
                          return ListView.builder(
                            reverse: true,
                            itemCount: qs.docs.length,
                            itemBuilder: (context,index){
                              MassageModel mm=MassageModel.
                              fromMap(qs.docs[index].data() as Map<String,dynamic>);


                              return
                                Row(
                                  mainAxisAlignment:(mm.sender==widget.userModel.uid)?
                                  MainAxisAlignment.end : MainAxisAlignment.start,
                                  children: [
                                    Flexible(

                                      child: Container(
                                          decoration: BoxDecoration(
                                          borderRadius:BorderRadius.circular(5),
                                          color:(mm.sender==widget.userModel.uid)?
                                          Colors.grey : Colors.blue,
                                                                      ),
                                          padding:const EdgeInsets.symmetric(vertical: 10
                                          ,horizontal: 10
                                          ),
                                          margin:const EdgeInsets.symmetric(vertical: 3),
                                          child: Text(mm.massage.toString()),

                                      ),
                                    ),
                                  ],
                                );



                            },
                          );
                        }else if(snapshot.hasError){
                          return const Center(
                          child:  Text("Say hi to your Friend"),
                          );
                        }else{
                          return const Center(
                            child:  Text("Say hi to your Friend"),
                          );
                        }
                      }else{
                      return const Center(
                      child: CircularProgressIndicator(),
                      );
                      }


                      }
                      ),
                  ),

                )
            ),
            Container(
              padding:const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: massageController,
                      maxLines: null,
                      decoration:const InputDecoration(
                        hintText: "Enter massage",
                      ),
                    ),
                  ),


                  IconButton(
                    onPressed: (){
                      sendMassage();
                    },
                    icon: Icon(Icons.send,color:Theme.of(context).colorScheme.secondary,)
                    ,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

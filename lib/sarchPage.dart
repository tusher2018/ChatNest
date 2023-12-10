import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frist_project/ChatPage.dart';
import 'package:frist_project/ChatRoomModel.dart';

class SearchPage extends StatefulWidget {

  final UserModel usermodel;
  final User firebaseuser;

  SearchPage({required this.usermodel,required this.firebaseuser});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController searchController=TextEditingController();

  Future<ChatRoomModel?> getChatRoomModel(UserModel target) async {
    ChatRoomModel? chat_room;
    QuerySnapshot qs=await FirebaseFirestore.instance.collection("ChatRooms").
    where("participants.${widget.usermodel.uid}",isEqualTo: true).
    where("participants.${target.uid}",isEqualTo: true).get();
    if(qs.docs.length > 0){
      var data=qs.docs[0].data();
      ChatRoomModel crm=ChatRoomModel.fromMap(data as Map<String,dynamic>);
      chat_room = crm;
    }else{
      ChatRoomModel crm=ChatRoomModel(
          roomId: "${widget.usermodel.uid.toString()} ${target.uid.toString()}",
          participants: {
            widget.usermodel.uid.toString() : true ,
            target.uid.toString():true
          },
          lastMassage: ""
      );
      await FirebaseFirestore.instance.collection("ChatRooms").doc(crm.roomId).
      set(crm.toMap());
      chat_room= crm;
    }
    return chat_room;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

            CupertinoButton(
                onPressed: (){
                  setState(() {
                    
                  });
                },
              color: Colors.lightBlueAccent,
              child: Text("Search",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection("user").
                where("email",isEqualTo: searchController.text).snapshots(),

                builder:(context, snapshot) {
                  if(snapshot.connectionState==ConnectionState.active){
                    if(snapshot.hasData){

                      QuerySnapshot qs=snapshot.data as QuerySnapshot;

                      if(qs.docs.length>0){
                        Map<String,dynamic> map=qs.docs[0].data()
                        as Map<String,dynamic>;
                        UserModel us=UserModel.fromMap(map);

                        return ListTile(
                          onTap: () async{
                            ChatRoomModel? room = await getChatRoomModel(us);

                            if(room!=null){
                              Navigator.popUntil(context, (route) => route.isFirst);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                return chatPage(userModel: widget.usermodel,
                                  firebaseUser: widget.firebaseuser,targetUser: us,
                                  chatroomModel: room,
                                );
                              }),
                              );

                            }
                          },
                          title: Text(us.name.toString()),
                          subtitle: Text(us.email.toString()),
                          trailing: Icon(Icons.keyboard_arrow_right),

                        );
                      }else{
                        return Text("No data found");
                      }




                    }else if(snapshot.hasError){
                      return Text("An error occourd");
                    }else{
                      return Text("No data found");
                    }
                  }else{
                    return CircularProgressIndicator();
                  }
                },
            ),

          ],
        ),

      ),
    );
  }
}

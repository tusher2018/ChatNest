import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frist_project/ChatRoomModel.dart';
import 'package:frist_project/login.dart';
import 'package:frist_project/sarchPage.dart';
import 'usermodel.dart';
import 'package:flutter/cupertino.dart';
import 'ChatPage.dart';



class homepage extends StatefulWidget {

  final UserModel usermodel;
  final User firebaseuser;

  homepage({Key? key,required this.usermodel,required this.firebaseuser});

  @override
    State<homepage> createState() {
      return  _HomePageState();
    }

  }
  class _HomePageState extends State<homepage> {

    @override
    void initState() {
      super.initState();
      setState(() {

      });
    }


    Future<UserModel?> getUserModelById(String uid) async {
      UserModel? userModel;
      if (uid.isEmpty) {
        return null;
      }
      DocumentSnapshot ds =
      await FirebaseFirestore.instance.collection("user").doc(uid).get();
      userModel = UserModel.fromMap(ds.data() as Map<String, dynamic>);
      return userModel;
    }

    Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Chat App"),
            backgroundColor: Colors.lightBlue,
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(onPressed: () async{
                await FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context){
                      return LoginPage();
                    })
                );
              }, icon: Icon(Icons.exit_to_app))
            ],

          ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("ChatRooms").
              where("participants.${widget.usermodel.uid}",isEqualTo: true).snapshots(),
              builder: (context, snapshot) {
                if(snapshot.connectionState==ConnectionState.active){

                  if(snapshot.hasData){
                    QuerySnapshot chatRoomSnapshot=snapshot.data as QuerySnapshot;

                    return ListView.builder(
                      itemCount: chatRoomSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        ChatRoomModel roommodel=ChatRoomModel.
                        fromMap(chatRoomSnapshot.docs[index].data() as Map<String,dynamic>);

                        Map<String,dynamic> participants=roommodel.participants!;
                        // List<String> allkey= participants.keys.toList();
                        // allkey.remove(widget.usermodel.uid);
                        participants.remove(widget.usermodel.uid);

                        List<String> allKeys = participants.keys.toList();
                        String firstKey = allKeys.isNotEmpty ? allKeys.first :
                        widget.usermodel.uid.toString();

                        return FutureBuilder(

                          future: getUserModelById(firstKey),

                          builder: (context, userdata) {
                            if(userdata.connectionState==ConnectionState.done){
                              if(userdata.data!=null){
                                UserModel targetuser=userdata.data as UserModel;
                                return ListTile(
                                  onTap: (){
                                    Navigator.popUntil(context, (route) => route.isFirst);
                                    Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context){
                                      return chatPage(userModel: widget.usermodel,
                                        firebaseUser: widget.firebaseuser,
                                        targetUser: targetuser,
                                        chatroomModel: roommodel,
                                      );
                                    }),
                                    );

                                    },
                                  title: Text(targetuser.name.toString()),
                                  subtitle: Text(
                                      (roommodel.lastMassage.toString().
                                      isNotEmpty) ? roommodel.lastMassage.
                                      toString() :"Say hi to your friend"
                                  ),
                                );

                              }else{
                                return Container();
                              }

                            }else{
                              return CircularProgressIndicator();
                            }
                          },
                        );

                      },
                    );

                  }else if(snapshot.hasError){
                    return Center(
                      child:  Text(snapshot.error.toString()),
                    );
                  }else{
                    return const Center(
                      child:  Text("No Chat"),
                    );
                  }
                }else{
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }


              },

            ),

          ),
        ),



         floatingActionButton:FloatingActionButton(
           onPressed: (){
             Navigator.popUntil(context, (route) => route.isFirst);
             Navigator.pushReplacement(context,
                 MaterialPageRoute(builder: (context){
                return SearchPage(usermodel: widget.usermodel,
                    firebaseuser: widget.firebaseuser);
             }),);
           },
           child: Icon(Icons.search),
         ),
      );

    }
}


/*

 body: SafeArea(
          child: Container(
            color: Colors.red,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("ChatRooms").
              where("participants.${widget.usermodel.uid}",isEqualTo: true).snapshots(),
              builder: (context, snapshot) {
                if(snapshot.connectionState==ConnectionState.active){

                  if(snapshot.hasData){
                    QuerySnapshot chatRoomSnapshot=snapshot.data as QuerySnapshot;

                    return ListView.builder(
                      itemCount: chatRoomSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        ChatRoomModel roommodel=ChatRoomModel.
                        fromMap(chatRoomSnapshot.docs[index].data() as Map<String,dynamic>);

                        Map<String,dynamic> participants=roommodel.participants!;
                        // List<String> allkey= participants.keys.toList();
                        // allkey.remove(widget.usermodel.uid);
                        participants.remove(widget.usermodel.uid);

                        List<String> allKeys = participants.keys.toList();
                        String firstKey = allKeys.isNotEmpty ? allKeys.first :
                        widget.usermodel.uid.toString();

                        return FutureBuilder(

                          future: getUserModelById(firstKey),

                          builder: (context, userdata) {
                            if(userdata.connectionState==ConnectionState.done){
                              if(userdata.data!=null){
                                UserModel targetuser=userdata.data as UserModel;
                                return ListTile(
                                  onTap: (){

                                  },
                                  title: Text(targetuser.name.toString()),
                                  subtitle: Text(
                                      (roommodel.lastMassage.toString().
                                      isNotEmpty) ? roommodel.lastMassage.
                                      toString() :"Say hi to your friend"
                                  ),
                                );

                            }else{
                                return Container();
                              }

                            }else{
                              return Container();
                            }
                          },
                        );

                      },
                    );

                  }else if(snapshot.hasError){
                    return Center(
                      child:  Text(snapshot.error.toString()),
                    );
                  }else{
                    return const Center(
                      child:  Text("No Chat"),
                    );
                  }
                }else{
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }


              },

            ),

          ),
        ),

 */
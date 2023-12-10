import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frist_project/usermodel.dart';
import 'compleatprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';





class signup extends StatefulWidget {





  @override
  State<signup> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<signup> {

  TextEditingController emailcontroller=TextEditingController();
  TextEditingController passwordcontroller=TextEditingController();
  TextEditingController cpasswordcontroller=TextEditingController();

  void checkValue(){
    String email=emailcontroller.text.trim();
    String password=passwordcontroller.text.trim();
    String cpassword=cpasswordcontroller.text.trim();

    if(email.isNotEmpty && password.isNotEmpty &&
        cpassword.isNotEmpty && cpassword==password){
      signup(email,password);
    }else{

    }
  }
  void signup(String email,String password) async{
    UserCredential? usercredential;

    try {
      usercredential=await FirebaseAuth.instance.
      createUserWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch(ex){

    }
    if(usercredential!=null){

      String userid=usercredential.user!.uid;
      UserModel data=UserModel(
        uid: userid,
        name: "",
        email: email,
        profilLink: ""
      );
      await FirebaseFirestore.instance.collection("user").doc(userid).set(data.toMap())
          .then((value){
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return profile(usermodel: data,firebaseuser: usercredential!.user!);
          }),
        );
      });
    }


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:
      SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: 30
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text("ChatNest",style: TextStyle(fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,fontSize: 50),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    TextField(
                      controller: emailcontroller,
                      decoration: InputDecoration(
                        labelText: "Emai",
                        labelStyle: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    TextField(
                      controller: passwordcontroller,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "password",
                        labelStyle: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    TextField(
                      controller: cpasswordcontroller,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "confirm password",
                        labelStyle: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    CupertinoButton(
                      child: Text("Sign Up",style: TextStyle(fontWeight:
                      FontWeight.bold),
                      ),
                      color: Colors.blue,
                      onPressed: (){
                        checkValue();
                      },
                    )
                  ],
                ),
              ),
            ),
          )
      ),
      bottomNavigationBar:
      Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account"),
              CupertinoButton(
                child: Text("Login"),
                onPressed: (){
                  Navigator.pop(context);
              },
              )
            ],
          )

      ),





    );
  }
}



import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frist_project/homepage.dart';
import 'package:frist_project/usermodel.dart';
import 'signup.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {



  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailcontroller=TextEditingController();
  TextEditingController passwordcontroller=TextEditingController();

  void checkValue(){
    String email=emailcontroller.text.trim();
    String password=passwordcontroller.text.trim();


    if(email.isNotEmpty && password.isNotEmpty ){
      login(email,password);
    }else{

    }
  }
  void login(String email,String password) async{
    UserCredential? credential;
    try{
      credential=await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email, password: password);
    }on FirebaseAuthException catch(ex){
    }

    if(credential!=null){
      String userid=credential.user!.uid;
      DocumentSnapshot data=await FirebaseFirestore.instance.collection("user").
      doc(userid).get();
      UserModel usermodel=UserModel.fromMap(data.data() as Map<String , dynamic>);

      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return homepage(usermodel: usermodel, firebaseuser: credential!.user!);
      }));

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
                        labelText: "Email",
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
                    CupertinoButton(
                      child: Text("Login",style: TextStyle(fontWeight:
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
              Text("Have no account"),
              CupertinoButton(
                child: Text("Sign up"),
                onPressed: (){
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return signup();
                    }),
                  );
              },
              )
            ],
          )

      ),





    );
  }
}


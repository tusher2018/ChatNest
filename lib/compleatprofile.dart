import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frist_project/homepage.dart';
import 'package:frist_project/usermodel.dart';
import 'package:image_picker/image_picker.dart';

class profile extends StatefulWidget {

  final UserModel usermodel;
  final User firebaseuser;
  profile({Key? key,required this.usermodel,required this.firebaseuser});

  @override
  State<profile> createState(){
    return _CompleatProfilePageState();
  }
}

class _CompleatProfilePageState extends State<profile> {

  File? pickedimage;
  TextEditingController nameController=TextEditingController();

  void pickImage(ImageSource source)  async{
    XFile? pickedImage= await ImagePicker().pickImage(source: source);
    if(pickedImage!=null){
      ImageFileConvert(pickedImage);
    }
  }
  void ImageFileConvert(XFile oldFile) async{
    File file = File(oldFile.path);
    setState(() {
      pickedimage = file;
    });
  }

  void showOption(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text("Upload Profile Picture"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: (){
                Navigator.pop(context);
                pickImage(ImageSource.gallery);
              },
              leading:const Icon(Icons.photo_album),
              title: const Text("Choose from Gallery"),
            ),
            ListTile(
              onTap: (){
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
              leading:const Icon(Icons.camera),
              title: const Text("Take a image"),
            )
          ],
        ),
      );
    });

  }


  void checkValue(){
    String name=nameController.text;
    if(name.isNotEmpty && pickedimage!=null) {
      updateValue();
    }
  }

  void updateValue() async{

    // UploadTask upload=FirebaseStorage.instance.ref("profileImage").
    // child(widget.usermodel!.uid.toString()).putFile(pickedimage!);
    // TaskSnapshot snapshot = await upload;
    // String url = await snapshot.ref.getDownloadURL();

    String fullname = nameController.text;
    widget.usermodel.name =fullname;
    widget.usermodel.profilLink = "url";


    FirebaseFirestore.instance.collection("user").doc(widget.usermodel!.uid).
    set(widget.usermodel.toMap()).then((value){
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return homepage(usermodel: widget.usermodel, firebaseuser: widget.firebaseuser);
        }),
      );
    });


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Complete profile')),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlueAccent,
      ),

      body:
        Container(
          padding:const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: ListView(
            children: [
              CupertinoButton(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:( pickedimage != null ) ? FileImage(pickedimage!) :null,
                  child: (pickedimage==null) ?const Icon(Icons.person,size: 60,):null,

                ),
                onPressed: (){
                  showOption();
                },
              ),
              const SizedBox(height: 30,),
               TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Full name",
                  labelStyle: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(height: 30,),
              CupertinoButton(
                color: Colors.blue,
                onPressed: (){
                  checkValue();
                },
                child:const Text("Submit",style: TextStyle(fontWeight:
                FontWeight.bold),
                ),
              )
            ],
          ),
        ),
    );
  }
}


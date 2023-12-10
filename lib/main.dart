import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frist_project/homepage.dart';
import 'login.dart';
import 'package:flutter/material.dart';
import 'usermodel.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'firebasehelper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:const FirebaseOptions(
      apiKey: "AIzaSyCkdOZb4VojUBCoF9HB0omZJkImIyUx-X0",
      appId: "1:886948523348:android:b11bb82248697c89f0acc1",
      messagingSenderId: "886948523348",
      projectId:"flutter-chat-app-e167e"
  ),);

  User? currentUser = FirebaseAuth.instance.currentUser;
  if(currentUser != null) {
    // Logged In
    UserModel? thisUserModel = await FirebaseHelper.getUserModelById(currentUser.uid);
    if(thisUserModel != null) {
      runApp(MyAppLogged(usermodel: thisUserModel, firebaseuser: currentUser));
    }
    else {
      runApp(MyApp());
    }
  }
  else {
    // Not logged in
    runApp(MyApp());
  }

}




class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  AnimatedSplashScreen(
          duration: 3000,
          splash: Icons.chat,
          nextScreen: LoginPage(),
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.fade,
          backgroundColor: Colors.blue)
    );
  }
}

class MyAppLogged extends StatelessWidget {
  final UserModel usermodel;
  final User firebaseuser;
  MyAppLogged({required this.usermodel,required this.firebaseuser});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AnimatedSplashScreen(
          duration: 3000,
          splash: Icons.chat,
          nextScreen: homepage(usermodel: usermodel, firebaseuser: firebaseuser),
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.fade,
          backgroundColor: Colors.blue)
    );
  }
}



//Image.asset("assets/image/bg.jpg",fit: BoxFit.cover,alignment: Alignment.center,)

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/HomePage.dart';

import 'addnotes.dart';
import 'autho/login.dart';
import 'autho/signup.dart';

bool ?islogin;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    islogin = false;
  } else {
    islogin = true;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: islogin == false ? Login() : HomePage(),

      // home: Test(),
      theme: ThemeData(
        // fontFamily: "NotoSerif",
          primaryColor: Colors.blue,
          buttonColor: Colors.blue,
          textTheme: TextTheme(
            headline6: TextStyle(fontSize: 20, color: Colors.white),
            headline5: TextStyle(fontSize: 30, color: Colors.blue),
            bodyText2: TextStyle(fontSize: 20, color: Colors.black),
          )),
      routes: {
        "login": (context) => Login(),
        "signup": (context) => SignUp(),
        "homepage": (context) => HomePage(),
       "addnotes": (context) => AddNotes(),
      //  "testtwo": (context) => TestTwo()
      },
    );
  }


}

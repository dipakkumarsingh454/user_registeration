
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_registration/home.dart';
import 'package:user_registration/screens/login.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:user_registration/screens/signup.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //uid = FirebaseAuth.instance.currentUser!.uid;
    //mobile = FirebaseAuth.instance.currentUser!.phoneNumber!;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Real Time',
      debugShowCheckedModeBanner: false,
      /*theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'NotoSans',
        ),*/
      theme: ThemeData.light(),
      home: const Signup(),
    );

  }
}

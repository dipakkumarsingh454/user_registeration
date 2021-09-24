import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_registration/screens/login.dart';


class AuthController extends GetxController with SingleGetTickerProviderMixin {

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() async{
    super.dispose();

  }

  @override
  void onClose() {
    super.onClose();

  }



  void logout() async{
    await FirebaseAuth.instance.signOut();
    Get.offAll(()=> const Login());
  }

}
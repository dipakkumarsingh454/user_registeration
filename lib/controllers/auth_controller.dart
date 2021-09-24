import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
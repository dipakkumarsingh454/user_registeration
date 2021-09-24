import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:get/get.dart';
import 'package:user_registration/screens/signup.dart';
import 'package:user_registration/home.dart';

import 'login.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  FormGroup buildForm() => fb.group(<String, Object>{
    'email': FormControl<String>(
      validators: [Validators.required, Validators.email],
    ),

  });

  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Password Rest"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ReactiveFormBuilder(
          form: buildForm,
          builder: (context, form, child) {
            return Column(
              children: [
                const Text("Enter your Registered Email Below",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0,),
                const Text("We will send a password reset link to your registered email id",
                  style: TextStyle(color: Colors.black, fontSize: 10),
                ),
                const SizedBox(height: 16.0,),
                ReactiveTextField<String>(
                  formControlName: 'email',
                  validationMessages: (control) => {
                    ValidationMessage.required: 'The email must not be empty',
                    ValidationMessage.email:
                    'The email value must be a valid email',
                    'unique': 'This email is already in use',
                  },
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    helperText: '',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.blueGrey,
                    ),
                    helperStyle: TextStyle(height: 0.7),
                    errorStyle: TextStyle(height: 0.7),
                  ),
                ),
                const SizedBox(height: 16.0),

                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async{
                        if (form.valid) {
                          showLoaderDialog(context);
                          await _auth.sendPasswordResetEmail(email: form.value.values.first.toString().trim())
                              .then((uid) => {
                                Navigator.pop(context),
                            Get.offAll(()=>const Login())
                          }).catchError((e){
                            print(e!.message);
                          });
                        } else {
                          form.markAllAsTouched();
                        }
                      },
                      child: const Text('Send Password Reset Link'),
                    ),
                  ],
                ),

              ],
            );
          },
        ),
      ),
    );
  }

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(margin: const EdgeInsets.only(left: 27),child:const Text("Sending Link ..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
}

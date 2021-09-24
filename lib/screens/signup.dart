import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:user_registration/models/users.dart';
import 'package:user_registration/home.dart';
import 'package:user_registration/screens/login.dart';


class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  static const namePattern = r'[a-zA-Z]';
  late String username;
  final _auth = FirebaseAuth.instance;

  FormGroup buildForm() => fb.group(<String, Object>{
    'name': FormControl<String>(
        validators: [Validators.required, Validators.minLength(3), Validators.maxLength(25)]
    ),
    'email': FormControl<String>(
      validators: [Validators.required, Validators.email],
    ),
    'password': FormControl<String>(validators: [Validators.required, Validators.minLength(8), Validators.maxLength(16)]),
    'passwordConfirmation': FormControl<String>(),
    //'rememberMe': false,
  },
      [
        Validators.mustMatch('password', 'passwordConfirmation'),
      ]
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ReactiveFormBuilder(
          form: buildForm,
          builder: (context, form, child) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Get.offAll(()=>const Login());
                      },
                      child: const Text("Log In", style: TextStyle(
                          color: Colors.blue
                      ),),
                    ),
                  ],
                ),
                const Text(
                  "OR",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Create a new Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10),
                ReactiveTextField<String>(
                  formControlName: 'name',
                  validationMessages: (control) => {
                    ValidationMessage.required: 'The name must not be empty',
                    ValidationMessage.minLength: 'The name should not be less than 3 alphabets',
                    ValidationMessage.maxLength: 'The name should not be more than 25 alphabets',
                    //ValidationMessage.pattern: 'Numbers and Special Characters not allowed',
                  },
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    helperText: '',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.blueGrey,
                    ),
                    helperStyle: TextStyle(height: 0.7),
                    errorStyle: TextStyle(height: 0.7),
                  ),
                ),
                const SizedBox(height: 16.0),
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
                ReactiveTextField<String>(
                  formControlName: 'password',
                  obscureText: true,
                  validationMessages: (control) => {
                    ValidationMessage.required: 'The password must not be empty',
                    ValidationMessage.minLength:
                    'The password must be at least 8 characters',
                    ValidationMessage.maxLength:
                    'The password must be more than 16 characters',
                  },
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    helperText: '',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.blueGrey,
                    ),
                    helperStyle: TextStyle(height: 0.7),
                    errorStyle: TextStyle(height: 0.7),
                  ),
                ),
                const SizedBox(height: 16.0),
                ReactiveTextField<String>(
                  formControlName: 'passwordConfirmation',
                  decoration:
                  const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.blueGrey,
                    ),
                  ),
                  obscureText: true,
                  validationMessages: (control) => {
                    ValidationMessage.mustMatch:
                    'Password confirmation must match',
                  },
                  onSubmitted: () => form.focus('rememberMe'),
                  textInputAction: TextInputAction.next,
                ),
                /*Row(
                  children: [
                    ReactiveCheckbox(formControlName: 'rememberMe'),
                    const Text('Remember me')
                  ],
                ),*/
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async{
                        if (form.valid) {
                          showLoaderDialog(context);
                          username = form.value.values.elementAt(0).toString();
                          await _auth.createUserWithEmailAndPassword(email: form.value.values.elementAt(1).toString().trim(),
                              password: form.value.values.elementAt(2).toString().trim())
                              .then((value) => {
                            postUserDetails(username)
                          }).catchError((e){
                            print(e!.message);
                          });
                        } else {
                          form.markAllAsTouched();
                        }
                      },
                      child: const Text('Sign Up'),
                    ),
                    ElevatedButton(
                      onPressed: () => form.resetState({
                        'email': ControlState<String>(value: null),
                        'password': ControlState<String>(value: null),
                        //'rememberMe': ControlState<bool>(value: false),
                      }, removeFocus: true),
                      child: const Text('Reset all'),
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

  Future<void> postUserDetails(String userName) async{
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = userName;

    await firebaseFirestore.collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    print("account created successfully");
    Navigator.pop(context);
    Get.offAll(()=>const Home());

  }

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(margin: const EdgeInsets.only(left: 27),child:const Text("Signing In ..." )),
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



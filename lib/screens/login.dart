import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:get/get.dart';
import 'package:user_registration/screens/signup.dart';
import 'package:user_registration/home.dart';
import 'package:user_registration/screens/forgotpassword.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  FormGroup buildForm() => fb.group(<String, Object>{
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

  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log In"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ReactiveFormBuilder(
          form: buildForm,
          builder: (context, form, child) {
            return Column(
              children: [
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
                const SizedBox(height: 16.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => Get.to(()=>const ForgotPassword()),
                      child: const Text("Forgot Password ?", style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold
                      ),),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0,),
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
                          await _auth.signInWithEmailAndPassword(email: form.value.values.first.toString().trim(), password: form.value.values.last.toString().trim())
                              .then((uid) => {
                                Navigator.pop(context),
                                Get.offAll(()=>const Home())
                          }).catchError((e){
                            print(e!.message);
                          });
                        } else {
                          form.markAllAsTouched();
                        }
                      },
                      child: const Text('Log In'),
                    ),
                    ElevatedButton(
                      onPressed: () => form.resetState({
                        'email': ControlState<String>(value: null),
                        'password': ControlState<String>(value: null),
                        'rememberMe': ControlState<bool>(value: false),
                      }, removeFocus: true),
                      child: const Text('Reset all'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Get.to(()=>const Signup());
                      },
                      child: const Text("Create Account", style: TextStyle(
                          color: Colors.blue
                      ),),
                    ),
                  ],
                )

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
          Container(margin: const EdgeInsets.only(left: 27),child:const Text("Logging In ..." )),
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

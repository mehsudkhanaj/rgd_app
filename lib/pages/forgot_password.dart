import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rgd_app/pages/login.dart';
import 'package:rgd_app/pages/signup.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();

  var email = "";

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final emailController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    super.dispose();
  }

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Password Reset Email has been sent !',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              'No user found for that email.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Text(
              'Reset Link will be sent to your email id !',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        autofocus: false,
                        decoration: InputDecoration(
                          labelText: 'Email',

                          labelStyle: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: 'abc@gmail.com',
                          hintStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.redAccent,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.redAccent,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Email';
                          } else if (!value.contains('@')) {
                            return 'Please Enter Valid Email';
                          }
                          return null;
                        },
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(left: 60.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, otherwise false.
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  email = emailController.text;
                                });
                                resetPassword();
                              }
                            },
                            child: Text(
                              'Send Email',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 30.0,
                                vertical: 15.0,
                              ),
                            ),
                          ),
                          SizedBox(width: 20.0),
                          TextButton(
                            onPressed: () => {
                              Navigator.pushAndRemoveUntil(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, a, b) => Login(),
                                  transitionDuration: Duration(seconds: 0),
                                ),
                                    (route) => false,
                              )
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                          ),
                          TextButton(
                            onPressed: () => {
                              Navigator.pushAndRemoveUntil(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, a, b) => Signup(),
                                  transitionDuration: Duration(seconds: 0),
                                ),
                                    (route) => false,
                              )
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

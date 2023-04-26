import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rgd_app/pages/login.dart';
import 'package:rgd_app/pages/user/user_main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => FirebaseAuth.instance.currentUser == null
                ? Login()
                : UserMain()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            "Real Time Gas Detector",
            style: TextStyle(
                fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/gaswork.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

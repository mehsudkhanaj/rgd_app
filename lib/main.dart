import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:rgd_app/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  final result = await Permission.notification.isDenied;
  if (result) {
    Permission.notification.request();
  }
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          // Check for Errors
          if (snapshot.hasError) {
            print("Something Went Wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return GetMaterialApp(
            title: 'Real Time Gas Detector',
            theme: ThemeData(
              primarySwatch: Colors.orange,
            ),
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        });
  }
}

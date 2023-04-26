import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_background_service_ios/flutter_background_service_ios.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/sensor_data.dart';

class BackgroundService {
  final service = FlutterBackgroundService();

  static void backgroundTaskEntryPoint() async {
    // await Firebase.initializeApp();
    // FirebaseFirestore.instance
    //     .collection('Sensor Data')
    //     .where('email', isEqualTo: 'mutahara2023@namal.edu.pk')
    //     .snapshots()
    //     .listen((QuerySnapshot snapshot) async {
    //   List<SensorData> newSensorDataList =
    //       snapshot.docs.map((doc) => SensorData.fromFirestore(doc)).toList();
    //   List<SensorData> sensorDataList = [];
    //   sensorDataList.addAll(newSensorDataList);
    //   SensorData sensorData;
    //   for (sensorData in sensorDataList) {
    //     if (int.parse(sensorData.sensorValue) >= 1600) {
    //       await audioPlayer.play(assetSource, volume: 100.0);
    //       break;
    //     }
    //   }
    // });
    Timer.periodic(const Duration(seconds: 20), (timer) async {
      AssetSource assetSource = AssetSource('media/alarm.mp3');
      AudioPlayer audioPlayer = AudioPlayer();
      await Firebase.initializeApp();
      final data = await FirebaseFirestore.instance
          .collection('Sensor Data')
          .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
          .get();

      List<SensorData> sensorDataList = [];
      sensorDataList.addAll(
          data.docs.map((doc) => SensorData.fromFirestore(doc)).toList());
      SensorData sensorData;
      for (sensorData in sensorDataList) {
        if (int.parse(sensorData.sensorValue) >= 1400) {
          print('play');
          await audioPlayer.play(assetSource, volume: 100.0);
          audioPlayer.onPlayerStateChanged.listen((event) {
            if (event.name == PlayerState.completed.name) {
              print('Completed');
              audioPlayer.release();
            } else if (event.name == PlayerState.playing.name) {
              print('Playing');
            }
          });
          break;
        }
      }
    });
  }

  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,
        // auto start service
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
    service.invoke("setAsForeground");
    // service.startService();
  }

  @pragma('vm:entry-point')
  static onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();
    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
        service.setForegroundNotificationInfo(
          title: "Sensor Service Running",
          content: "Alarm will beep if something wrong happend with gas.",
        );
      });
      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });
    backgroundTaskEntryPoint();
  }
// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    return true;
  }
}

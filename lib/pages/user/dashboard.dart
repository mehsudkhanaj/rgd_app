import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/sensor_data.dart';
import '../../utils/backgound_service.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final email = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: getStreamSensorDataByEmail(email as String),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Data is available, convert it to a list of SensorData objects
              List<SensorData> sensorDataList = snapshot.data!.docs
                  .map((doc) => SensorData.fromFirestore(doc))
                  .toList();
              Future.delayed(
                const Duration(seconds: 5),
                    () {
                  if (int.parse(sensorDataList.first.sensorValue) >= 1400) {
                    Get.snackbar('Gas Alert', 'High Gas Alert Please Check',
                        backgroundColor: Colors.red, colorText: Colors.white);
                    //Stop Sensor
                  }
                },
              );
              // Display the sensor data in a ListView or other widget
              return ListView.builder(
                itemCount: sensorDataList.length,
                itemBuilder: (context, index) {
                  SensorData sensorData = sensorDataList[index];
                  return Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                sensorData.sensorValue,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'PPM',
                                textAlign: TextAlign.justify,
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(sensorData.sensorName),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(sensorData.email.split('@')[0]),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              // An error occurred, display an error message
              return Text('Error: ${snapshot.error}');
            } else {
              // Data is not yet available, display a loading indicator
              return const CircularProgressIndicator();
            }
          },
        ),
        // StreamBuilder<QuerySnapshot>(
        //   stream: getStreamSensorDataByEmail('mutahara2023@namal.edu.pk'),
        //   builder:
        //       (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //     if (snapshot.hasError) {
        //       return Center(
        //           child: Text('Error: ${snapshot.error}',
        //               style: TextStyle(fontSize: 18.0, color: Colors.red)));
        //     }

        //     if (snapshot.connectionState == ConnectionState.done) {
        //       if (!snapshot.hasData || snapshot.data == null) {
        //         return Center(
        //             child: Text('Error: ${snapshot.error}',
        //                 style: TextStyle(fontSize: 18.0, color: Colors.red)));
        //       }

        //       print('itemBuilder');
        //       print(snapshot.data!.docs.length);
        //       return ListView.builder(
        //         itemCount: snapshot.data!.docs.length,
        //         itemBuilder: (BuildContext context, int index) {
        //           final doc = snapshot.data!.docs[index];

        //           final String email = doc['email'];
        //           final String sensorName = doc['sensorName'];
        //           final String sensorValue = doc['sensorValue'];

        //           return Card(
        //             elevation: 5.0,
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(10.0),
        //             ),
        //             child: ListTile(
        //               title: Text(email.split('@')[0],
        //                   style: const TextStyle(
        //                       fontSize: 22.0, fontWeight: FontWeight.bold)),
        //               subtitle: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Text('Sensor Name: $sensorName',
        //                       style: const TextStyle(fontSize: 18.0)),
        //                   Text('Sensor Value: $sensorValue',
        //                       style: const TextStyle(fontSize: 18.0)),
        //                 ],
        //               ),
        //             ),
        //           );
        //         },
        //       );
        //     }
        //     return const Center(child: CircularProgressIndicator());
        //   },
        // ),
      ),
      // Center(
      //   child: Container(
      //     width: double.infinity,
      //     decoration: BoxDecoration(
      //       image: DecorationImage(
      //         image: NetworkImage(
      //             "https://live.staticflickr.com/1919/31771305328_4d5a05bcf2_b.jpg"),
      //         fit: BoxFit.cover,
      //       ),
      //     ),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Column(
      //           children: [
      //             CircleAvatar(
      //               radius: 60,
      //               backgroundColor: Colors.white.withOpacity(0.9),
      //               child: CircleAvatar(
      //                 radius: 55,
      //                 backgroundImage: AssetImage('assets/images/mydp.jpeg'),
      //               ),
      //             ),
      //           ],
      //         ),
      //         SizedBox(width: 10),
      //         Row(
      //           children: [
      //             CircleAvatar(
      //               radius: 60,
      //               backgroundColor: Colors.white.withOpacity(0.9),
      //               child: CircleAvatar(
      //                 radius: 55,
      //                 backgroundImage: AssetImage('assets/images/nida.jpeg'),
      //               ),
      //             ),
      //             SizedBox(width: 152),
      //             CircleAvatar(
      //               radius: 60,
      //               backgroundColor: Colors.white.withOpacity(0.9),
      //               child: CircleAvatar(
      //                 radius: 55,
      //                 backgroundImage:
      //                     AssetImage('assets/images/mutahara.jpeg'),
      //               ),
      //             ),
      //           ],
      //         ),
      //         SizedBox(
      //           height: 10,
      //         ),
      //         SizedBox(height: 20),
      //         Container(
      //           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(10),
      //             color: Colors.black.withOpacity(0.7),
      //           ),
      //           child: Text(
      //             "$email",
      //             style: TextStyle(
      //               fontSize: 22,
      //               fontWeight: FontWeight.bold,
      //               color: Colors.white,
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}

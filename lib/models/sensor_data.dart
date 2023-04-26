import 'package:cloud_firestore/cloud_firestore.dart';

class SensorData {
  final String email;
  final bool bit;
  final String sensorName;
  final String sensorValue;

  SensorData({
    required this.email,
    required this.bit,
    required this.sensorName,
    required this.sensorValue,
  });

  Map<String, dynamic> toMap() {
    return {
      'bit': bit,
      'email': email,
      'sensorName': sensorName,
      'sensorValue': sensorValue,
    };
  }

  factory SensorData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SensorData(
      email: data['email'],
      bit: data['bit'],
      sensorName: data['sensorName'],
      sensorValue: data['sensorValue'],
    );
  }
}

Future<QuerySnapshot> getSensorDataByEmail(String email) async {
  return await FirebaseFirestore.instance
      .collection('Sensor Data')
      .where('email', isEqualTo: email)
      .get();
}

Future<List<SensorData>> getListSensorDataByEmail(String email) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('Sensor Data')
      .where('email', isEqualTo: email)
      .get();

  List<SensorData> sensorDataList = [];

  querySnapshot.docs.forEach((doc) {
    SensorData sensorData = SensorData.fromFirestore(doc);
    sensorDataList.add(sensorData);
  });

  return sensorDataList;
}

Stream<QuerySnapshot> getStreamSensorDataByEmail(String email) {
  return FirebaseFirestore.instance
      .collection('Sensor Data')
      .where('email', isEqualTo: email)
      .snapshots();
  // .map((querySnapshot) => querySnapshot.docs
  // .map((doc) => SensorData.fromFirestore(doc))
  // .toList());
}

void addSensorData(String email, SensorData sensorData) {
  FirebaseFirestore.instance
      .collection('Sensor Data')
      .add(sensorData.toMap())
      .then((value) {
    print('Sensor Data added to Firestore!');
  }).catchError((error) {
    print('Failed to add Sensor Data to Firestore: $error');
  });
}

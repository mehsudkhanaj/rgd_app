import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String email;
  final String hashedPassword;
  final String phoneNo;
  final String location;

  UserModel({
    required this.name,
    required this.email,
    required this.hashedPassword,
    required this.phoneNo,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'hashedPassword': hashedPassword,
      'phoneNo': phoneNo,
      'location': location,
    };
  }
}

void addUserToFirestore(UserModel user) {
  FirebaseFirestore.instance
      .collection('Users')
      .add(user.toMap())
      .then((value) {
    print('User added to Firestore!');
  }).catchError((error) {
    print('Failed to add user to Firestore: $error');
  });
}


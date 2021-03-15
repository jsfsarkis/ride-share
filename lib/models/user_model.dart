import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String userId;
  String fullName;
  String phoneNumber;
  String email;

  UserModel({
    this.userId,
    this.fullName,
    this.phoneNumber,
    this.email,
  });

  UserModel.fromSnapshot(DataSnapshot snapshot) {
    this.userId = snapshot.key;
    this.phoneNumber = snapshot.value['phone'];
    this.email = snapshot.value['email'];
    this.fullName = snapshot.value['fullname'];
  }
}


// User Data Model on firestore database
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String? uid;
  String? email;
  String? password;
  String? name;
  String? mob;
  String? description;
  Timestamp? signUPDate;


  UserData({required this.uid,this.email ,this.password,this.name,this.mob,this.description,this.signUPDate});
  UserData.fromDoc(Map<String, dynamic> doc) {
    uid = doc['uid'];
    email = doc['email'];
    password = doc['password'];
    name = doc['name'];
    mob = doc['mob'];
    description = doc['description'];
    signUPDate = doc['signUPDate'];
  }
}

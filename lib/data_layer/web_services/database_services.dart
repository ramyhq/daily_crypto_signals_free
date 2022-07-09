// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_crypto_signals_free/data_layer/data_models/signal_model.dart';
import 'package:daily_crypto_signals_free/data_layer/data_models/user_data.dart';
import 'package:daily_crypto_signals_free/providers/authentication_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DatabaseServices {
  final String? uid; // we will pass uid with Constructor as we will use it much
  DatabaseServices({this.uid});


  // FireStore collections references
  final CollectionReference userData_collection = FirebaseFirestore.instance
      .collection('userData');
  final CollectionReference guestData_collection = FirebaseFirestore.instance
      .collection('guestData');
  final CollectionReference free_signals_collection = FirebaseFirestore.instance
      .collection('free_signals');
  final CollectionReference device_tokens_collection = FirebaseFirestore.instance
      .collection('device_tokens');

  /// ### userData Section ###

  // # userData Streams#
  Stream<UserData?> get userDataFromDBU {
    return userData_collection.doc(uid).snapshots().map((user) =>
        _dataUserFromSnapshot(user));
  }

  // Stream<DocumentSnapshot> get userDataFromDB {
  //   //var a = userData_collection.doc(uid).snapshots().map((doc) => UserData.fromDoc(doc.data()));
  //   return userData_collection.doc(uid).snapshots().map((doc) => UserData.fromDoc(doc);
  //
  // }
  Stream<UserData?>  userDataFromDB(userUid) {
    return  userData_collection.doc(userUid).snapshots().map((doc) => UserData.fromDoc(doc.data() as Map<String, dynamic>));
  }

  // update user data
  Future updateUserDate({
    required String email,
    required String password,
    required String name,
    required String mob,
    required String description,
    required DateTime signUPDate,
  }) async {
    return await userData_collection.doc(uid).set({
      'email': email,
      'password': password,
      'name': name,
      'mob': mob,
      'description': description,
      'signUPDate': signUPDate,
    });
  }

  // to convert snapshot to user data (from DocumentSnapshot)
  UserData? _dataUserFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      //userAdId: snapshot['userAdId'] ,
      email: snapshot['email'] ,
      //password: snapshot['password'] ,
      //name: snapshot['name'] ,
      //mob: snapshot.get('mob') ,
      //description: snapshot['description'],
      //signUPDate: snapshot['signUPDate'].toDate(),
    );
  }


  // ### Guest Data Section ###

  // update Guest data
  Future updateGuestDate(int? userAdId,) async {
    return await guestData_collection.doc(uid).set({
      'userAdId': userAdId,
    });
  }


  /// ### signals Section ###

  Stream<SignalModel?> adsDataFromDB(adID) {
    return free_signals_collection.doc(adID).snapshots().map((snapshot) =>
        _adModelFromSnapshotDoc(snapshot));
  }
  Stream<List<SignalModel?>?>? adsDataFromDBAllDocs() {
    return free_signals_collection.snapshots().map((snapshot) =>
        _adModelFromSnapshotAllDocs(snapshot));
  }

  // update user data
  Future updateAdDate({
    required String coinName,
    required String entryPrice,
    required String stopLoss,
    required String target1, // sell or rent
    required String target2,
    required String target3,
    required DateTime signalDate,
  }) async {
    try{return await free_signals_collection.doc(signalDate.millisecondsSinceEpoch.toString()).set({
      'coinName': coinName,
      'entryPrice': entryPrice,
      'stopLoss': stopLoss,
      'target1': target1,
      'target2': target2,
      'target3': target3,
      'signalDate': Timestamp.fromDate(signalDate),
    });
    }on FirebaseException catch(e){
      print(e.message);
    } catch(e){
      print('update method error 505: $e');
    }
  }

  
  // to convert snapshot (doc) to ad data (from DocumentSnapshot)
  SignalModel?  _adModelFromSnapshotDoc(DocumentSnapshot snapshot) {
    try {
        return SignalModel(
            coinName: snapshot['coinName'],
            entryPrice: snapshot['entryPrice'],
            stopLoss: snapshot['stopLoss'],
            target1: snapshot['target1'],
            target2: snapshot['target2'],
            target3: snapshot['target3'],
            signalDate: snapshot['signalDate'].toDate(),
          //title: snapshot['title'] ,
          //title: snapshot.get('title') ,
          //title: snapshot.get(FieldPath(['title'])) ,

        );
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // to convert snapshot to ad data (from QuerySnapshot)
  List<SignalModel?>? _adModelFromSnapshotAllDocs(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return SignalModel(
          coinName: doc.get('coinName')?? 'nulll',
          entryPrice: doc.get('entryPrice')?? 'nulll',
          stopLoss: doc.get('stopLoss')?? 'nulll',
          target1: doc.get('target1')?? 'nulll',
          target2: doc.get('target2')?? 'nulll',
          target3: doc.get('target3')?? 'nulll',
          signalDate: doc.get('signalDate').toDate()?? 'nulll',
        );
      }).toList();

    } catch (error) {
      print('***** ${error.toString()}');
      return null;
    }
  }

  /// Token data
  // update Token data
  Future updateToken(String deviceTokens) async{
    // return await device_tokens_collection.add({
    //   'deviceTokens': deviceTokens
    // });
    return await device_tokens_collection.doc(deviceTokens).set({
      'deviceTokens': deviceTokens
    });
  }




}
import 'dart:io';
import 'package:daily_crypto_signals_free/data_layer/data_models/user_data.dart';
import 'package:daily_crypto_signals_free/data_layer/shared_prefrences.dart';
import 'package:daily_crypto_signals_free/data_layer/web_services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _fbm = FirebaseMessaging.instance;

  User? ourUser;
  DateTime currentTime = DateTime.now();

  //AuthServices({this.ourUser});

  // to get token and safe it for push firebase notification
  void getToken() async {
    print('getToken is called 999');
    var token = await _fbm.getToken();
      if(token != null){
        DatabaseServices().updateToken(token);
        CachingData.saveString('notificationToken', token); // for later if needed
        CachingData.saveBool('isTokenSaved', true);
        print('getToken is called 995 ${await CachingData.getData('notificationToken')}');
        print('getToken is called 994 ${await CachingData.getData('isTokenSaved')}');

      }
  }


  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  void setIsLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  void setMessage(message) {
    _errorMessage = message;
    notifyListeners();
  }


// sign in anon
  Future signInAnon() async {
    setIsLoading(true);
    try {
      UserCredential result = await _firebaseAuth.signInAnonymously();
      ourUser = result.user;
      setIsLoading(false);
      //create empty doc for the Guest with his unique uid (for later)
      await DatabaseServices(uid: ourUser!.uid).updateGuestDate(0);
      getToken();
      return _ourUserDataFromFirebaseUser(ourUser);
    } on SocketException {
      setIsLoading(false);
      setMessage('No internet');
    } on FirebaseAuthException catch (e) {
      setIsLoading(false);
      setMessage(e.message);
      print(e.message);
    }
  }

  Future register(
      String email,
      String password,
      String name,
      String mob,
      String description,
      //DateTime? signUPDate,
      ) async {
    setIsLoading(true);
    try {
      UserCredential authResult = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      ourUser = authResult.user;
      setIsLoading(false);
      //create new doc for the user with his unique uid
      await DatabaseServices(uid: ourUser!.uid)
          .updateUserDate(
          email:email,
          password:password,
          name:name,
          mob:mob  ,
          description:description ,
          signUPDate:currentTime,
      );
      await CachingData.saveBool('isTokenSaved', false);
      getToken();
      return ourUser;
    } on SocketException {
      setIsLoading(false);
      setMessage('No internet');
    } on FirebaseAuthException catch (e) {
      setIsLoading(false);
      setMessage(e.message);
    }
    notifyListeners();
  }

  Future login(String email, String password) async {
    setIsLoading(true);
    try {
      UserCredential authResult = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      ourUser = authResult.user;
      setIsLoading(false);
      return ourUser;
    } on SocketException {
      setIsLoading(false);
      setMessage('No internet');
    } on FirebaseAuthException catch (e) {
      setIsLoading(false);
      setMessage(e.message);
    }
    notifyListeners();
  }

  Future logout() async {
    await _firebaseAuth.signOut();
    notifyListeners();
  }

  //Func that convert firebaseUser user to our user_data model object to use it in all app
  UserData? _ourUserDataFromFirebaseUser(User? user) {
    return user != null ? UserData(uid: user.uid) : null;
  }


  // ### streams ####

  // stream of (our UserData status)
  Stream<User?> get ourUserStatusStream => _firebaseAuth.authStateChanges()
      .map((User? user) => user);
}

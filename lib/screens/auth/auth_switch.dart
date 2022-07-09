// ignore_for_file: prefer_const_constructors

import 'package:daily_crypto_signals_free/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';


class AuthSwitch extends StatefulWidget {
  static const String id = 'AuthSwitch';

  const AuthSwitch({Key? key}) : super(key: key);

  @override
  _AuthSwitchState createState() => _AuthSwitchState();
}

class _AuthSwitchState extends State<AuthSwitch> {

  bool showRegister = false;
  void toggleRegister(){
    setState(() {
      showRegister = !showRegister;
      print('toggleRegister called');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showRegister){
      return SignUPScreen(toggleRegister: toggleRegister);
    }else {
      return LoginScreen(toggleRegister: toggleRegister);
    }

  }
}

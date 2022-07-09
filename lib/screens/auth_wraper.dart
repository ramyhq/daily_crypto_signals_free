import 'package:daily_crypto_signals_free/data_layer/data_models/signal_model.dart';
import 'package:daily_crypto_signals_free/data_layer/data_models/user_data.dart';
import 'package:daily_crypto_signals_free/data_layer/web_services/database_services.dart';
import 'package:daily_crypto_signals_free/screens/auth/login_screen.dart';
import 'package:daily_crypto_signals_free/screens/home_screen.dart';
import 'package:daily_crypto_signals_free/screens/start_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'auth/auth_switch.dart';

class AuthWrapper extends StatelessWidget {
  static const String id = 'AuthWrapper';
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ourUserState = Provider.of<User?>(context); // stream of (our UserData status) // for only user Login Status
    if (ourUserState == null) {
      print('if called in AuthWrapper build (ourUserState is null)');
      return AuthSwitch();
    } else {
      print('else called in AuthWrapper build (ourUserState NOT null)');
      return  MultiProvider(providers: [
        StreamProvider<UserData?>(
          create: (_) =>
              DatabaseServices().userDataFromDB(ourUserState.uid),
          initialData: null,
          catchError: (_, err) {
            print(err.toString());
          },
        ),
        StreamProvider<List<SignalModel?>?>(
            create: (_) => DatabaseServices().adsDataFromDBAllDocs(), // this is for all ads
            initialData: null,
            catchError: (_, err) {
              print('catchError from StreamProvider ** ${err.toString()}');
            }),

      ], child: MainPage());
    }

    }
}





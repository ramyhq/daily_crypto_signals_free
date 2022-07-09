// ignore_for_file: prefer_const_constructors

import 'package:daily_crypto_signals_free/providers/authentication_services.dart';
import 'package:daily_crypto_signals_free/screens/auth/auth_switch.dart';
import 'package:daily_crypto_signals_free/screens/auth/login_screen.dart';
import 'package:daily_crypto_signals_free/screens/auth/signup_screen.dart';
import 'package:daily_crypto_signals_free/screens/auth_wraper.dart';
import 'package:daily_crypto_signals_free/screens/home_screen.dart';
import 'package:daily_crypto_signals_free/screens/start_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'data_layer/shared_prefrences.dart';
import 'my_widgets/eroor_page.dart';
import 'my_widgets/loading_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

String? userUid;
int loginStatus = 12;
bool isTokenSaved = false;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/// receive msg when app is in background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  )); // to make status bar transparent useing flutter services  package:flutter/services.dart';

  final Future<FirebaseApp> init =  Firebase.initializeApp();
  await CachingData.init();
  userUid =  CachingData.getData('userUid').toString();
  loginStatus =  await CachingData.getData('loginStatus') ?? 12 ;
  isTokenSaved = await CachingData.getData('isTokenSaved') ?? false ;

  // to disable Rotate Orientations
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);


  /// push notification
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  ///-----********


  runApp( MyApp(init: init));
}


class MyApp extends StatelessWidget {
  final Future<FirebaseApp>? init;
  const MyApp({Key? key, this.init}) : super(key: key);
  @override
  Widget build(BuildContext context)  {

    print('MyApp build is called ');
    return  FutureBuilder(
        future: init,
        builder: (context,snapshot){
          if (snapshot.hasData){
            return MultiProvider(
              providers:  [
                ChangeNotifierProvider<AuthServices>.value(value: AuthServices()),
                StreamProvider<User?>(
                    create: (_) => AuthServices().ourUserStatusStream , // for only user Login Status
                    initialData: null),
              ],
              child:  MaterialApp(
                debugShowCheckedModeBanner: false ,
                title: '',
                initialRoute: AuthWrapper.id,
                routes:  {
                   AuthWrapper.id:(context) => loginStatus == 11 ? MainPage() : AuthWrapper(),
                  AuthSwitch.id:(context) =>  AuthSwitch(),
                   StartScreen.id: (context) =>  StartScreen(),
                   LoginScreen.id: (context) =>  LoginScreen(),
                   SignUPScreen.id: (context) =>  SignUPScreen(),
                   MainPage.id: (context) =>  MainPage(),
                },
              ),
            );
          } else if (snapshot.hasError){
            return const ErrorPage();
          }else {
            return const LoadingPage();
          }
        }
    );
  }
}


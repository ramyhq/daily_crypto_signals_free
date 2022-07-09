// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:daily_crypto_signals_free/consts/text_const.dart';
import 'package:daily_crypto_signals_free/my_widgets/login_button.dart';
import 'package:daily_crypto_signals_free/providers/authentication_services.dart';
import 'package:daily_crypto_signals_free/screens/home_screen.dart';
import 'package:daily_crypto_signals_free/util/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/auth_switch.dart';

class StartScreen extends StatelessWidget {
  static const String id = 'StartScreen';

  StartScreen({Key? key}) : super(key: key);

  final ButtonStyle myButtonStyle = ElevatedButton.styleFrom(
    splashFactory: NoSplash.splashFactory,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);
    print('StartScreen build is called');
    return SafeArea(
      child: DismissKeyboard(
        child: Scaffold(
          // resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width / 1.15,
              height: MediaQuery.of(context).size.height / 1.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'Daily Crypro Signals',
                          style: kLoginScreenTitle,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.monetization_on_outlined,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  LoginButton(
                    width: 210,
                    height: 60,
                    labelStyle: kLoginLabelStyle,
                    label: 'Skip Login',
                    onPressed: () async {
                      await loginProvider.signInAnon();
                      Navigator.pushReplacementNamed(context, MainPage.id);
                    },
                  ),
                  OutlinedButton(
                      style: myButtonStyle,
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context,AuthSwitch.id);
                      },
                      child: Text('Login', style: kSignUpStyle)),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

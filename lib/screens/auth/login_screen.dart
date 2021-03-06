// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:daily_crypto_signals_free/consts/text_const.dart';
import 'package:daily_crypto_signals_free/data_layer/shared_prefrences.dart';
import 'package:daily_crypto_signals_free/my_widgets/loading_widget.dart';
import 'package:daily_crypto_signals_free/my_widgets/login_button.dart';
import 'package:daily_crypto_signals_free/my_widgets/my_text_field.dart';
import 'package:daily_crypto_signals_free/providers/authentication_services.dart';
import 'package:daily_crypto_signals_free/screens/home_screen.dart';
import 'package:daily_crypto_signals_free/util/dismiss_keyboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'LoginScreen';
  final toggleRegister;
  const LoginScreen({Key? key,this.toggleRegister}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Variables
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _letsValidat = false;

  final ButtonStyle myButtonStyle = ElevatedButton.styleFrom(
    splashFactory: NoSplash.splashFactory,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
  );

  _storeUserUid(uid) async {
    print("_storeUserUid called");
    await CachingData.saveString('userUid', uid);
    print('after succ login UID is :${await CachingData.getData('userUid')}');
  }

  _storeloginStatus(loginStatus) async {
    print("_storeloginStatus called");
    await CachingData.saveInt('loginStatus', loginStatus);
    print('after succ login loginStatus is :${await CachingData.getData('loginStatus')}');
  }

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);
    final ourUser = Provider.of<AuthServices>(context);

    return SafeArea(
      child: DismissKeyboard(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              TextButton(
                  style: myButtonStyle,
                  onPressed: () async {
                    await loginProvider.signInAnon();
                    _storeloginStatus(11); // code 11 for OnTheFly user
                     Navigator.pushNamed(
                         context,MainPage.id);
                  },
                  child: Text('Skip', style: kSignUpStyle))
            ],
          ),
          //resizeToAvoidBottomInset: false,
          body: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width / 1.15,
              height: MediaQuery.of(context).size.height / 1.3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50.0),
                          child: Text(
                            'Coast',
                            style: kLoginScreenTitle,
                          ),
                        ),
                        MyTextField(
                          controller: _emailController,
                          validator: (val) {
                            if (_letsValidat) {
                              if (val!.isEmpty || !val.contains("@")) {
                                return "enter a valid email";
                              } else {
                                return null;
                              }
                            }
                          },
                          hintText: "Enter Your Email",
                          labelText: "Email",
                          prefixIcon: Icon(Icons.mail),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),
                        MyTextField(
                          controller: _passwordController,
                          validator: (val) {
                            if (_letsValidat) {
                              if (val!.length >= 6) {
                                return null;
                              } else {
                                return 'Password too short ... min is 6 char'
                                    ;
                              }
                            }
                          },
                          hintText: "Enter Your Password",
                          labelText: "Password",
                          prefixIcon: Icon(Icons.vpn_key),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: _obscureText
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off)),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          obscureText: _obscureText,
                        ),
                        loginProvider.isLoading
                            ? LoadingWidget()
                            : LoginButton(
                                width: 210,
                                height: 60,
                                labelStyle: kLoginLabelStyle,
                                label: 'Login',
                                onPressed: () async {
                                  FocusScope.of(context)
                                      .unfocus(); // to unfocused Keyboard
                                  setState(() {
                                    _letsValidat = true;
                                  });

                                  if (_formKey.currentState!.validate()) {
                                    User? ourNewUser = await loginProvider.login(
                                        _emailController.text.trim(),
                                        _passwordController.text.trim());
                                    print('succ login and use is ${ourNewUser!.email}');
                                    _storeUserUid(ourNewUser.uid);
                                    _storeloginStatus(13); // code 13 for Registered Users
                                    if (ourNewUser != null) {
                                      Navigator.pushReplacementNamed(
                                          context,MainPage.id);
                                    }
                                  }
                                },
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              style: myButtonStyle,
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context,LoginScreen.id);
                              },
                              child: Text(
                                'Forgot password ?',
                                style: kForgetPasswordS,
                              ),
                            ),
                            OutlinedButton(
                                style: myButtonStyle,
                                onPressed: () {
                                  widget.toggleRegister();
                                  // Navigator.pushReplacement(
                                  //     context,
                                  //     PageTransition(
                                  //         type: PageTransitionType.fade,
                                  //         child: SignUPScreen()));
                                },
                                child: Text('Sign up', style: kSignUpStyle)),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (loginProvider.errorMessage != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 0,
                            ),
                            width: double.infinity,
                            color: Colors.amber,
                            child: ListTile(
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  size: 20,
                                ),
                                onPressed: () {
                                  loginProvider.setMessage(null);
                                },
                              ),
                              title: Text(
                                loginProvider.errorMessage!,
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

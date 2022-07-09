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
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';


class SignUPScreen extends StatefulWidget {
  static const String id = 'SignUPScreen';
  final toggleRegister;
  const SignUPScreen({Key? key,this.toggleRegister}) : super(key: key);

  @override
  State<SignUPScreen> createState() => _SignUPScreenState();
}

class _SignUPScreenState extends State<SignUPScreen> {
  // Variables
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _mobController;
  late TextEditingController _descriptionController;
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
    print("Shared pref called");
    await CachingData.saveString('userUid', uid);
    print('after succ login UID is :${await CachingData.getData('userUid')}');
  }
  _storeloginStatus(loginStatus) async {
    print("Shared pref called");
    await CachingData.saveInt('loginStatus', loginStatus);
    print('after succ register loginStatus is :${await CachingData.getData('loginStatus')}');
  }

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _mobController = TextEditingController();
    _descriptionController = TextEditingController();
  }


  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _mobController.dispose();
    _descriptionController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);
    final ourUser = Provider.of<User?>(context,listen: true);// stream of (our UserData status) // for only user Login Status

    return SafeArea(
      child: DismissKeyboard(
        child: Scaffold(
          backgroundColor: Colors.white,
          //resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          elevation: 0,
            actions: [
              TextButton(
                  style: myButtonStyle,
                  onPressed: () async{
                    await loginProvider.signInAnon();
                    Navigator.pushReplacementNamed(
                        context,MainPage.id);
                  },
                  child: Text('Skip', style: kSignUpStyle))
            ],
          ),
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
                  autovalidateMode: AutovalidateMode.always,
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
                        // name
                        MyTextField(
                          controller: _nameController,
                          validator: (val) {
                            if (_letsValidat) {
                              if (val!.isEmpty ) {
                                return "enter your name";
                              } else {
                                return null;
                              }
                            }
                          },
                          hintText: "enter your name",
                          labelText: "name",
                          prefixIcon: Icon(Icons.mail),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                        ),
                        // email
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
                        //Password
                        MyTextField(
                          controller: _passwordController,
                          validator: (val) {
                            if (_letsValidat) {
                              if (val!.length < 6) {
                                return 'Password too short';
                              } else {
                                return null;
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
                          textInputAction: TextInputAction.next,
                          obscureText: _obscureText,
                        ),
                        // confirm Password
                        MyTextField(
                          controller: _confirmPasswordController,
                          validator: (val) {
                            if (_letsValidat) {
                              if (val != _passwordController.text) {
                                return 'Password not match';
                              } else {
                                return null;
                              }
                            }
                          },
                          hintText: "confirm Your Password",
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
                          textInputAction: TextInputAction.next,
                          obscureText: _obscureText,
                        ),
                        //mob
                        MyTextField(
                          controller: _mobController,
                          validator: (val) {
                            if (_letsValidat) {
                              if (val!.isEmpty || val.length < 11) {
                                return "enter a your mobile";
                              } else {
                                return null;
                              }
                            }
                          },
                          hintText: "enter your mobile",
                          labelText: "mobile",
                          prefixIcon: Icon(Icons.mail),
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                        ),
                        //description
                        MyTextField(
                          controller: _descriptionController,
                          validator: (val) {
                            if (_letsValidat) {
                                return null;
                            }
                          },
                          hintText: "description",
                          labelText: "description",
                          prefixIcon: Icon(Icons.mail),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                        ),
                        loginProvider.isLoading
                            ? LoadingWidget()
                            : LoginButton(
                                width: 210,
                                height: 60,
                                labelStyle: kLoginLabelStyle,
                                label: 'Sign up',
                                onPressed: () async {
                                  FocusScope.of(context).unfocus(); // to unfocused Keyboard
                                  setState(() {
                                    _letsValidat = true;
                                  });
                                  if (_formKey.currentState!.validate()) {
                                    User? ourNewUser = await loginProvider.register(
                                        _emailController.text.trim(),
                                        _passwordController.text.trim(),
                                        _nameController.text.trim(),
                                        _mobController.text.trim(),
                                        _descriptionController.text.trim(),
                                  );
                                    print('succ signup and use is ${ourNewUser!.email}');
                                    _storeUserUid(ourNewUser.uid);
                                    _storeloginStatus(13); // code 13 for Registered users
                                    // if successfully Sign up
                                    if(ourNewUser != null){
                                      Navigator.pushReplacementNamed(context,MainPage.id);
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
                                'Already have account ?',
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
                                  //         child: LoginScreen()));
                                },
                                child: Text('Login', style: kSignUpStyle)),
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
                              title: Text(loginProvider.errorMessage!,
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),),
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

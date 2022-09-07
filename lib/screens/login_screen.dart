import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/show_exception_alert_dialog.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: SizedBox(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 48.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email.', labelText: 'Email'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  obscureText: true, //for **** password
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      // overWirte hinttext
                      hintText: 'Enter your Password.',
                      labelText: 'Password'),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                    color: Colors.lightBlueAccent,
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      }); //end spinner
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: email!, password: password!);
                        if (user != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                        setState(() {
                          isLoading = false;
                        }); //end spinner
                      } on FirebaseException catch (e) {
                        showExceptionAlertDialog(context,
                            title: 'Error', exception: e);
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    textButton: 'Log In'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

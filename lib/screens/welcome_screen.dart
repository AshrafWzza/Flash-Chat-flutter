import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/rounded_button.dart';

//Todo:AnimatedTextKit repetition numbers
class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation? animation; //Curved Animation
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 1) /*upperBound:100.0*/);
    //animation = CurvedAnimation(parent: controller!, curve: Curves.easeIn);
    // When you use CurvedAnimation , the upperBound can't be greater than 1.0
    animation =
        ColorTween(begin: Colors.grey, end: Colors.white).animate(controller!);
    controller!.forward();

    //Go and Back  repetition
    // animation?.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) { //End
    //     controller?.reverse(from: 1.0);
    //   } else if (status == AnimationStatus.dismissed) {//Beginning
    //     controller?.forward();
    //   }
    // });
    controller!.addListener(() {
      setState(() {});
      //debugPrint(animation!.value);  //warning color not String
      //debugPrint('${animation!.value}');
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation!.value,
      //backgroundColor: Colors.blueGrey.withOpacity((controller?.value)!),
      // (!) to fix error double? cant be assigned to double
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                //Rotate logo
                AnimatedRotation(
                  turns: controller!.value.toDouble(),
                  curve: Curves.elasticInOut,
                  duration: const Duration(seconds: 2),
                  child: Hero(
                    tag: 'logo',
                    child: SizedBox(
                      child: Image.asset('images/logo.png'),
                      height: 60.0,
                    ),
                  ),
                ),
                //animated_text_kit
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flash Chat',
                      textStyle: const TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                  totalRepeatCount: 3,
                  pause: const Duration(milliseconds: 1000),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButton(
                color: Colors.lightBlueAccent,
                onPressed: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) {
                  //   return LoginScreen();
                  // }));
                  //---> USE PUSHNAMED
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                textButton: 'Log In'),
            RoundedButton(
                color: Colors.blueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                textButton: 'Register'),
          ],
        ),
      ),
    );
  }
}

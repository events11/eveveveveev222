import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import 'package:flutter_application_1/screens/pagewa_screen.dart';
import 'signin_screen.dart';
import 'signup_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_application_1/generated/l10n.dart';


class WelcomeScreen extends StatefulWidget {
  static const String screenRoute = 'welcome_screen';
  const WelcomeScreen({super.key});

  @override
  State createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 180,
                  child: Image.asset('images/event1.webp'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Mybutton(
                color: const Color.fromARGB(255, 210, 164, 38),
                title: S.of(context).Login,
                onpressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.screenRoute);
                }),
            Mybutton(
              color: const Color.fromARGB(255, 210, 164, 38),
              
              title:  S.of(context).signup,
              onpressed: () {
                Navigator.pushNamed(context, SignInScreen.screenRoute);
              },
            ),
            Mybutton(
                color: const Color.fromARGB(255, 210, 164, 38),
                title: S.of(context).Guest,
                onpressed: () {
                  Navigator.pushNamed(context, PagewaScreen.screenRoute);
                })
          ],
        ),
      ),
    );
  }
}

class Mybutton extends StatelessWidget {
  const Mybutton(
      {super.key,
      required this.color,
      required this.title,
      required this.onpressed});
  final Color color;
  final String title;
  final VoidCallback onpressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
          elevation: 5,
          color: color,
          borderRadius: BorderRadius.circular(10),
          child: MaterialButton(
            onPressed: onpressed,
            minWidth: 200,
            height: 42,
            child: Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          )),
    );
  }
}

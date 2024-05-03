import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:medyya/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Widget initialRoute = const HomePage();

  @override
  void initState() {
    super.initState();
    getInitialRoute();
  }

  Future<void> getInitialRoute() async {
    var p = await SharedPreferences.getInstance();
    if (p.getString('authToken') == null) {
      initialRoute = const LoginPage();
    } else {
      initialRoute = const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(children: [
        Image.asset(
          'assets/images/lotus.png',
          color: darkpink,
          scale: 5,
        ),
        const SizedBox(
          height: 7,
        ),
        Text(
          'MEDYYA',
          style: TextStyle(color: darkpink),
        ),
      ]),
      splashIconSize: 160,
      backgroundColor: Colors.white,
      nextScreen: initialRoute,
      duration: 1500,
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}


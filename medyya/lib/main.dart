import 'package:flutter/material.dart';
import 'package:medyya/pages/home.dart';
import 'package:medyya/pages/splash_screen.dart';
//import 'package:flutter/widgets.dart';
import './pages/login.dart';
// import './pages/register.dart';
// import 'package:shared_preferences/shavred_preferences.dart';
void main() {
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});
  // SharedPreferences p = await SharedPreferences.getInstance();
  // p.getString('authToken');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.pink[900]),
          bodyLarge:
              TextStyle(fontWeight: FontWeight.w400, color: Colors.pink[900]),
        ),
      ),
      home: const SplashScreen(),

    );
  }
}

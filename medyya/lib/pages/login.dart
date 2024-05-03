import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:http/http.dart' as http;
import 'package:medyya/pages/register.dart';
import 'dart:convert';
import '../components/text_field.dart';
import './home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medyya/constants.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _username_controller = TextEditingController();
  final TextEditingController _password_controller = TextEditingController();
  final TextEditingController _email_controller = TextEditingController();
  var _message = '';
  var _button_background = pink700;
  bool is_valid = true;
  Future<void> _login() async {
    var username = _username_controller.text.trim();
    var password = _password_controller.text.trim();
    var email = _email_controller.text.trim();
    Uri uri = Uri.parse(hosting_url + '/api/users/login/');
    final _res = await http.post(uri,
        body: jsonEncode(
            {"username": username.toString(), "password": password.toString()}),
        headers: {'Content-Type': 'application/json'});
    final dynamic _resData = jsonDecode(_res.body);
    if (_res.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('authToken', _resData['token']);
      setState(() {
        is_valid = true;
      });
    } else {
      var errors = _resData['error'];
      //var code = _res.statusCode;
      setState(() {
        is_valid = false;
        _message = (errors == null) ? 'Invalid Credentials' : '$errors';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightpink,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Image.asset(
                'assets/images/lotus.png',
                height: 150,
                width: 500,
                color: pink700,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Welcome Back, you were missed!  ', style: TextStyle(fontSize: 15),),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const SignupPage();
                      }));
                    },
                    child: const Text(
                      'Signup',
                      style: TextStyle(
                          color: Colors.teal, fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: _username_controller,
                obscureText: false,
                hintText: 'Username',
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: _password_controller,
                obscureText: true,
                hintText: 'Password',
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    _button_background = darkpink;
                  });
                },
                onTapCancel: () {
                  setState(() {
                    _button_background = pink700;
                  });
                },
                onTap: () async {
                  Loader.show(context,
                      progressIndicator:
                          CircularProgressIndicator(color: darkpink));
                  try {
                    await _login();
                    if (is_valid) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return const HomePage();
                      }));
                    }
                  } finally {
                    Loader.hide();
                  }
                },
                child: Container(
                  height: 60,
                  width: 500,
                  //padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: _button_background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: lightpink,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Visibility(
                visible: !is_valid,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: darkpink),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(_message),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

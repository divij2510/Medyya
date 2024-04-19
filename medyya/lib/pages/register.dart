// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:medyya/main.dart';
import 'package:medyya/pages/login.dart';
// import 'package:medyya/main.dart';
import 'dart:convert';
import '../components/text_field.dart';
import 'package:medyya/constants.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);
  @override
  State<SignupPage> createState() {
    return _SignupPageState();
  }
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _username_controller = TextEditingController();
  final TextEditingController _password_controller = TextEditingController();
  final TextEditingController _email_controller = TextEditingController();
  var _message = 'Enter all the details';
  var _button_background = pink400;
  bool is_valid = true;

  Future<void> _signup() async {
    var username = _username_controller.text.trim();
    var password = _password_controller.text.trim();
    var email = _email_controller.text.trim();
    Uri uri = Uri.parse(
        hosting_url + '/api/users/signup/');
    final _res = await http.post(uri,
        body: jsonEncode({
          "username": username.toString(),
          "password": password.toString(),
          "email": email.toString()
        }),
        headers: {'Content-Type': 'application/json'});
    if (_res.statusCode == 201) {
      setState(() {
        is_valid = true;
      });
    } else {
      var errors = _res.body;

      setState(() {
        is_valid = false;
        _message = "$errors";
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
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Create a new account,  '),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){return LoginPage();}));
                    },
                    child: const Text('Login', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w500),),
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
                controller: _email_controller,
                obscureText: false,
                hintText: 'Email',
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
                    _button_background = pink700;
                  });
                },
                onTapCancel: () {
                  setState(() {
                    _button_background = pink400;
                  });
                },
                onTap: () async{
                  await _signup();
                  if(is_valid){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LoginPage();
                  }));
                }},
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
                      'SIGN UP',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: lightpink,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Visibility(
                visible: !is_valid,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: darkpink),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(child: Text(_message)),
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

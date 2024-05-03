import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:permission_handler/permission_handler.dart';
import '../components/text_field.dart';
import './home.dart';
import 'package:medyya/constants.dart';
import 'package:medyya/models/profile_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:medyya/controllers/profile_controller.dart';

class UpdateProfilePage extends StatefulWidget {
  final UserProfile profile;
  final String tkn;
  const UpdateProfilePage(
      {super.key, required this.profile, required this.tkn});

  @override
  State<UpdateProfilePage> createState() {
    return _UpdateProfilePageState();
  }
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final TextEditingController _username_controller = TextEditingController();
  final TextEditingController _firstname_controller = TextEditingController();
  final TextEditingController _lastname_controller = TextEditingController();
  final TextEditingController _bio_controller = TextEditingController();
  var _button_background = pink700;
  bool isTapped = false;
  String pickedImagePath = '';
  bool isLoading = false;

  void initState() {
    super.initState();
    _username_controller.text = widget.profile.username;
    _firstname_controller.text = widget.profile.firstName;
    _lastname_controller.text = widget.profile.lastName;
    _bio_controller.text = widget.profile.bio;
  }

  Future<void> pick_image() async {
    var status = await Permission.storage.request();
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['png', 'jpg'] // Specify the file type as image
        );
    if (result != null) {
      pickedImagePath = result.files.first.path ?? '';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightpink,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  const Text(
                    'Edit your profile!',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: pick_image,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    Colors.pink[100] ?? Colors.pink, // Border color
                                width: 3.0,
                              ),
                            ),
                            child: ClipOval(
                              clipBehavior: Clip.antiAlias,
                              child: (pickedImagePath != '')
                                  ? Image.file(
                                      File(pickedImagePath),
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit
                                          .cover, // Ensure the image covers the oval shape
                                      color: isTapped
                                          ? Colors.black.withOpacity(0.5)
                                          : null, // Apply transparency when tapped
                                      colorBlendMode: isTapped
                                          ? BlendMode.srcOver
                                          : null, // Apply transparency mode
                                    )
                                  : Image.network(
                                      media_url + widget.profile.profilePicture,
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit
                                          .cover, // Ensure the image covers the oval shape
                                      color: isTapped
                                          ? Colors.black.withOpacity(0.5)
                                          : null, // Apply transparency when tapped
                                      colorBlendMode: isTapped
                                          ? BlendMode.srcOver
                                          : null, // Apply transparency mode
                                    ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            color: darkpink,
                            onPressed: () {
                              // Handle edit icon tap
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 170,
                        child: MyTextField(
                          controller: _firstname_controller,
                          obscureText: false,
                          hintText: 'New First Name',
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 170,
                        child: MyTextField(
                          controller: _lastname_controller,
                          obscureText: false,
                          hintText: 'New Last Name',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  MyTextField(
                    controller: _username_controller,
                    obscureText: false,
                    hintText: 'New Username',
                  ),
                  const SizedBox(height: 30),
                  MyTextField(
                    controller: _bio_controller,
                    obscureText: false,
                    hintText: 'Your Status...',
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTapDown: (_){
                      setState(() {
                        _button_background = darkpink;
                    });},
                    onTapCancel: () {
                      setState(() {
                        _button_background = pink700;
                      });
                    },
                    onTap: () async {
                        setState(() {
                          _button_background = darkpink;
                          isLoading = true;
                        });
                        await GetProfile(token: widget.tkn).updateUserProfile(
                          UserProfile(
                            username: _username_controller.text.trim(),
                            firstName: _firstname_controller.text.trim(),
                            lastName: _lastname_controller.text.trim(),
                            profilePicture: (pickedImagePath == '')
                                ? widget.profile.profilePicture
                                : pickedImagePath,
                            bio: _bio_controller.text.trim(),
                          ),
                          (pickedImagePath != '') ? true : false,
                        );

                        // Navigate to the HomePage
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                          return const HomePage();
                        }));
                        setState(() {
                          isLoading = false;
                        });

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
                          'UPDATE PROFILE',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: lightpink,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isLoading
                ? Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    color: darkpink,
                  ),
                ),
              ),
            )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}

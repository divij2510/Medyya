import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:medyya/constants.dart';
import 'package:medyya/pages/home.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:medyya/controllers/post_controller.dart';
import '../components/text_field.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

class CreatePost extends StatefulWidget {
  final GetPosts? gp;

  const CreatePost({super.key, required this.gp});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  TextEditingController _caption_controller = TextEditingController();
  final CropController _cropController = CropController();
  var _button_background = pink700;
  bool isTapped = false;
  String pickedImagePath = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    pick_image();
  }

  Future<void> pick_image() async {
    var status = await Permission.storage.request();
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['png', 'jpg'] // Specify the file type as image
        );
    setState(() {
      pickedImagePath = (result?.files.first.path ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 23),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Create a new Post!  ',
                      style: TextStyle(fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: pick_image,
                      child: const Text(
                        'Pick fresh image',
                        style: TextStyle(
                            color: Colors.teal,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.teal,
                            decorationThickness: 1),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                (pickedImagePath != '')
                    ? Image.file(
                        File(pickedImagePath),
                        height: 300,
                        width: 350,
                        fit: BoxFit
                            .contain, // Ensure the image covers the oval shape
                        color: isTapped
                            ? Colors.black.withOpacity(0.5)
                            : null, // Apply transparency when tapped
                        colorBlendMode: isTapped
                            ? BlendMode.srcOver
                            : null, // Apply transparency mode
                      )
                    : const SizedBox(
                        height: 300,
                        width: 300,
                        child: Center(
                            child: Text('No Image Selected :(',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w300))),
                      ),
                const SizedBox(height: 40),
                MyTextField(
                  controller: _caption_controller,
                  obscureText: false,
                  hintText: 'Caption... ',
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
                    setState(() {
                      isLoading = true;
                    });

                    bool is_valid = await widget.gp!.make_post(
                        bio: _caption_controller.text.trim(),
                        pickedImagePath: pickedImagePath);

                    if (is_valid) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return const HomePage();
                      }));
                      setState(() {
                        isLoading = false;
                      });
                    } else if (!is_valid) {
                      setState(() {
                        _button_background = pink700;
                      });
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
                        'POST',
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
    );
  }
}

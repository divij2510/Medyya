import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medyya/models/post_model.dart';
import 'package:medyya/constants.dart';
import 'package:medyya/models/profile_model.dart';
import 'package:medyya/pages/update_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medyya/controllers/post_controller.dart';
import 'package:intl/intl.dart';
import 'package:medyya/controllers/notification_controller.dart';
import 'package:medyya/pages/profile_page.dart';

class Post extends StatefulWidget {
  final PostModel post;
  final UserProfile? myprofile;
  GetNotifications? gn;
  final String tkn;
  GetPosts? gp;
  Post(
      {super.key,
      required this.post,
      required this.tkn,
      required this.gn,
      required this.gp, required this.myprofile});

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  IconData? _i;
  bool? isLiked;
  Color? button_fill;
  Color? button_text_color;
  String? button_text;
  bool connection_button_visibility = false;
  int? _likes;
  @override
  void initState() {
    super.initState();
    setState(() {
      _likes = widget.post.likes;
    });
    widget.gp?.check_like(widget.post.id).then((bool_val) {
      if (mounted) {
        setState(() {
          isLiked = bool_val;
          _i = (bool_val) ? Icons.diamond_rounded : Icons.diamond_outlined;
        });
      }
    });
    widget.gn?.check_connection(username: widget.post.user).then((code) {
      setState(() {
        if (code == 302 || code == 208) {
          connection_button_visibility = false;
        } else if (code == 404) {
          connection_button_visibility = true;
          button_text = 'Connect';
          button_text_color = Colors.teal;
          button_fill = Colors.transparent;
        } else if (code == 102) {
          connection_button_visibility = true;
          button_text = 'Requested';
          button_text_color = Colors.white;
          button_fill = Colors.teal;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 7),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              ClipOval(
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.pink, Colors.purpleAccent],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                      ),
                    ),
                    Image.network(
                      widget.post.profileImage,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  if(widget.post.user==widget.myprofile?.username)
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return UpdateProfilePage(tkn: widget.tkn,profile: widget.myprofile!);
                    }));
                  }
                  else{
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ProfilePage(
                          tkn: widget.tkn, username: widget.post.user);
                    }));
                  }

                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 21,
                      ),
                    ),
                    Text('@${widget.post.user}'),
                  ],
                ),
              ),
              const Spacer(),
              connection_button_visibility
                  ? GestureDetector(
                      onTap: () async {
                        if (button_text == 'Connect') {
                          setState(() {
                            button_text = 'Requested';
                            button_text_color = Colors.white;
                            button_fill = Colors.teal;
                          });
                          await widget.gn!.handle_request(
                              username: widget.post.user, action: 'request');
                        } else if (button_text == 'Requested') {
                          setState(() {
                            button_text = 'Connect';
                            button_text_color = Colors.teal;
                            button_fill = Colors.transparent;
                          });
                          await widget.gn!.handle_request(
                              username: widget.post.user, action: 'delete');
                        }
                      },
                      child: SizedBox(
                        width: 100,
                        child: Container(
                          //padding: EdgeInsets.all(5),
                          height: 35,
                          width: 80,
                          decoration: BoxDecoration(
                            color: button_fill,
                            border: Border.all(
                              color: Colors.teal,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: Center(
                            child: Text(
                              button_text ?? 'Connect',
                              style: TextStyle(
                                color: button_text_color,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(width: 20)
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: Image.network(
              media_url + widget.post.postImage,
              width: 373,
              fit: BoxFit.fitWidth,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Container(
                  color: darkpink,
                  height: 370,
                  width: 370,
                  padding: const EdgeInsets.all(100),
                  child: CircularProgressIndicator(
                    color: lightpink,
                    strokeWidth: 1.2,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () async {
                  if (isLiked ?? false) {
                    setState(() {
                      _i = Icons.diamond_outlined;
                      if (_likes != widget.post.likes - 1 && _likes != null) {
                        _likes = _likes! - 1;
                      }
                      isLiked = false;
                    });
                  } else {
                    setState(() {
                      _i = Icons.diamond_rounded;
                      if (_likes != widget.post.likes + 1 && _likes != null) {
                        _likes = _likes! + 1;
                      }
                      isLiked = true;
                    });
                  }
                  await widget.gp
                      ?.like(id: widget.post.id, to_like: (isLiked ?? false));
                },
                child: Icon(_i ?? Icons.diamond_outlined,
                    size: 40, color: darkpink),
              ),
              const SizedBox(width: 10),
              Text(
                _likes == null
                    ? '${widget.post.likes} ${widget.post.likes == 1 ? 'like' : 'likes'}'
                    : '$_likes ${_likes == 1 ? 'like' : 'likes'}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 12),
            child: Text(
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
              widget.post.caption,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(DateFormat('MMMM d, yyyy, hh:mm a').format(
                DateTime.parse(widget.post.createdAt)
                    .add(const Duration(hours: 5, minutes: 30)))),
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}

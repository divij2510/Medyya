import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medyya/models/post_model.dart';
import 'package:medyya/models/profile_model.dart';
import 'package:medyya/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medyya/controllers/post_controller.dart';
import 'package:intl/intl.dart';

class Post extends StatefulWidget {
  final PostModel post;
  SharedPreferences? p;
  String? tkn;
  GetPosts? gp;
  int _l = 0;
  Post(
      {Key? key,
      required this.post,
      required this.p,
      required this.tkn,
      required this.gp})
      : super(key: key) {
    _l = post.likes;
  }

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  IconData _i = Icons.energy_savings_leaf_outlined;
  bool like = false;
  Color button_fill = Colors.transparent;
  Color button_text_color = Colors.teal;
  String button_text = 'Connect';
  void initState() {
    print(widget.post?.createdAt);
    widget.gp?.check_like(widget.post.id).then((bool_val) {
      like = bool_val;
      _i = (!bool_val)
          ? Icons.energy_savings_leaf
          : Icons.energy_savings_leaf_outlined;
    });
  }

  Future<bool> _liked(int id, bool to_like) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    GetPosts gp = GetPosts(token: token);
    bool like = await gp.is_liked(id, to_like);
    return like;
  }

  void _likePost() async {
    if (like == false) {
      setState(() {
        like = true;
        widget._l++;
        _i = Icons.energy_savings_leaf;
      });
      await _liked(widget.post.id, like);
    } else {
      setState(() {
        like = false;
        widget._l--;
        _i = Icons.energy_savings_leaf_outlined;
      });
      await _liked(widget.post.id, like);
    }
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
                      hosting_url + widget.post.profileImage,
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
              Column(
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
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    button_fill = Colors.teal;
                    button_text_color = Colors.white;
                    button_text = 'Requested';
                  });
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
                        button_text,
                        style: TextStyle(
                          color: button_text_color,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20)
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: Image.network(
              hosting_url + widget.post.postImage,
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
                onTap: _likePost,
                child: Icon(_i, size: 40, color: darkpink),
              ),
              const SizedBox(width: 10),
              Text(
                '${widget._l} ${widget._l == 1 ? 'like' : 'likes'}',
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

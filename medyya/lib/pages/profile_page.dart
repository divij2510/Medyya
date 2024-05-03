import 'package:flutter/material.dart';
import 'package:medyya/controllers/notification_controller.dart';
import 'package:medyya/controllers/profile_controller.dart';
import 'package:medyya/models/profile_model.dart';
import 'package:medyya/constants.dart';

class ProfilePage extends StatefulWidget {
  final String tkn;
  final String username;
  const ProfilePage({super.key, required this.tkn, required this.username});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile? profile;
  Color? button_fill;
  Color? button_text_color;
  String? button_text;
  bool connection_button_visibility = false;

  @override
  void initState() {
    super.initState();
    GetProfile(token: widget.tkn)
        .get_profile(username: widget.username)
        .then((p) {
      setState(() {
        profile = p;
      });
    });
    GetNotifications(token: widget.tkn)
        .check_connection(username: widget.username)
        .then((code) {
      setState(() {
        if (code == 302) {
          connection_button_visibility = false;
          button_text = 'Connected!';
          button_text_color = Colors.white;
          button_fill = Colors.teal;
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
        } else if (code == 208) {
          connection_button_visibility = true;
          button_text = 'Accept Request';
          button_text_color = Colors.teal;
          button_fill = Colors.transparent;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightpink,
      appBar: AppBar(
        backgroundColor: darkpink,
        foregroundColor: lightpink,
        title: Text(
          profile?.username ?? '',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: profile != null
          ? SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, bottom: 10, left: 15),
                      child: ClipOval(
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            media_url + (profile?.profilePicture ?? ''),
                            fit: BoxFit.cover,
                            height: 140,
                            width: 140,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return SizedBox(
                                height: 120,
                                width: 120,
                                child: CircularProgressIndicator(
                                  color: lightpink,
                                  strokeWidth: 120,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        '${profile?.firstName ?? ''} ${profile?.lastName ?? ''}',
                        style: TextStyle(
                          color: darkpink,
                          fontWeight: FontWeight.w500,
                          fontSize: 29,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 10, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '@${profile?.username ?? ''}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 19,
                              color: darkpink,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          const Icon(
                            Icons.supervised_user_circle_outlined,
                            color: Colors.brown,
                            size: 19,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            '${profile?.connectionsCount} Connections',
                            style: const TextStyle(
                                color: Colors.brown, fontSize: 19),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.pink.withOpacity(0.27),
                      indent: 17,
                      endIndent: 17,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 14.0, bottom: 14, left: 16),
                      child: Text(
                        profile?.bio ?? '',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: darkpink,
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.pink.withOpacity(0.27),
                      indent: 17,
                      endIndent: 17,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    connection_button_visibility
                        ? GestureDetector(
                            onTap: () async {
                              if (button_text == 'Connect') {
                                setState(() {
                                  button_text = 'Requested';
                                  button_text_color = Colors.white;
                                  button_fill = Colors.teal;
                                });
                                await GetNotifications(token: widget.tkn)
                                    .handle_request(
                                        username: widget.username,
                                        action: 'request');
                              } else if (button_text == 'Requested') {
                                setState(() {
                                  button_text = 'Connect';
                                  button_text_color = Colors.teal;
                                  button_fill = Colors.transparent;
                                });
                                await GetNotifications(token: widget.tkn)
                                    .handle_request(
                                        username: widget.username,
                                        action: 'delete');
                              } else if (button_text == 'Accept Request') {
                                setState(() {
                                  button_text = 'Connected!';
                                  button_text_color = Colors.white;
                                  button_fill = Colors.teal;
                                });

                                await GetNotifications(token: widget.tkn)
                                    .handle_request(
                                        username: widget.username,
                                        action: 'accept');
                              }
                            },
                            child: Center(
                              child: SizedBox(
                                width: 370,
                                child: Container(
                                  //padding: EdgeInsets.all(5),

                                  decoration: BoxDecoration(
                                    color: button_fill,
                                    border: Border.all(
                                      color: Colors.teal,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(17),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        button_text ?? 'Connect',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: button_text_color,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: SizedBox(
                              width: 370,
                              child: Container(
                                //padding: EdgeInsets.all(5),

                                decoration: BoxDecoration(
                                  color: Colors.teal,
                                  border: Border.all(
                                    color: Colors.teal,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(17),
                                ),
                                child: const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                      'Connected!',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            )
          : const Center(
              child: Text('loading profile....',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300))),
    );
  }
}

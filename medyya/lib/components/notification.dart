import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medyya/constants.dart';
import 'package:medyya/controllers/notification_controller.dart';

import '../pages/profile_page.dart';
import '../pages/update_profile.dart';

class MyNotification extends StatefulWidget {
  final NotificationModel notification;
  final String tkn;
  final Function(NotificationModel) pop_notification;
  const MyNotification(
      {super.key,
      required this.notification,
      required this.tkn,
      required this.pop_notification});

  @override
  State<MyNotification> createState() => _MyNotificationState();
}

class _MyNotificationState extends State<MyNotification> {
  Future<void> _connection_action({required action, required username}) async {
    bool completed =
        await GetNotifications(token: widget.tkn).handle_request(action: action, username: username);
    if (completed) {
      widget.pop_notification(widget.notification);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            ClipOval(
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
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
                    '$media_url/${widget.notification.profile_picture}',
                    width: 60,
                    height: 60,
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
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ProfilePage(
                            tkn: widget.tkn, username: widget.notification.username);
                      }));
                  },
                  child: Text(
                    '${widget.notification.firstName} ${widget.notification.lastName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 21,
                    ),
                  ),
                ),
                Text('@${widget.notification.username}'),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () async {
                await _connection_action(
                    action: 'accept', username: widget.notification.username);
              },
              child: const Icon(
                Icons.check_circle_outline_sharp,
                size: 32,
                color: Colors.teal,
              ),
            ),
            const SizedBox(
              width: 7,
            ),
            GestureDetector(
              onTap: () async {
                await _connection_action(
                    action: 'delete', username: widget.notification.username);
              },
              child: const Icon(
                CupertinoIcons.xmark_circle,
                size: 32,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}

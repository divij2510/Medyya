import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../controllers/notification_controller.dart';
import 'package:medyya/components/notification.dart';

class ConnectionPage extends StatefulWidget {
  final String tkn;
  const ConnectionPage({super.key, required this.tkn});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  GetNotifications? gn;
  List<NotificationModel> notifications = [];

  Future<void> get_notifications({required gn}) async {
    gn!.get_notifications().then((notss) {
      setState(() {
        //toggle rebuild
        notifications = notss;
      });
    });
  }

  void _pop_notification(notification){
    setState(() {
      notifications.remove(notification);
    });

  }

  @override
  void initState() {
    super.initState();
    gn = GetNotifications(token: widget.tkn);
    get_notifications(gn: gn);
  }

  @override
  Widget build(BuildContext context) {
    return (notifications.isEmpty)
        ? const Center(child: Text('No Pending Requests', style: TextStyle(
        fontSize: 24, fontWeight: FontWeight.w300)))
        : Column(
            children: [
              Card(
                shape: const Border(),
                elevation: 0.5,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Text(
                        'Connection Requests (${notifications.length})',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MyNotification(gn: gn!,notification: notifications[index], pop_notification: _pop_notification,);
                  },
                  addAutomaticKeepAlives: true,
                  cacheExtent: 1000,
                ),
              )
            ],
          );
  }
}

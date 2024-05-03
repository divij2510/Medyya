import 'dart:convert';
import 'package:medyya/constants.dart';
import 'package:http/http.dart' as http;

class NotificationModel {
  final String username;
  final String createdAt;
  final String firstName;
  final String lastName;
  final String profile_picture;

  NotificationModel(
      {required this.firstName,
      required this.lastName,
      required this.profile_picture,
      required this.username,
      required this.createdAt});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
        username: json['from_user'],
        createdAt: json['created_at'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        profile_picture: json['profile_picture']);
  }
}

class GetNotifications {
  String? token;
  GetNotifications({required this.token});

  Future<List<NotificationModel>> get_notifications() async {
    final Uri uri = Uri.parse('$hosting_url/api/users/connection/view-all/');
    final res = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      "Authorization": "Token $token"
    });
    final notificationsListJson = jsonDecode(res.body) as List<dynamic>;
    var notifications = notificationsListJson.map((n) {
      return NotificationModel.fromJson(n);
    }).toList();
    print('!!!!!!!!!!!!'+notificationsListJson.toString());
    return notifications;
  }

  Future<bool> handle_request({required username, required action}) async {
    final Uri uri =
        Uri.parse('$hosting_url/api/users/connection/$action/$username/');
    final res = await http.post(uri, headers: {
      'Content-Type': 'application/json',
      "Authorization": "Token $token"
    });

    if (res.statusCode == 200 ||
        (action == 'request' && res.statusCode == 201)) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> check_connection({required username}) async{
    final Uri uri =
    Uri.parse('$hosting_url/api/users/connection/check/$username/');
    final res = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      "Authorization": "Token $token"
    });
    return res.statusCode;
  }
}

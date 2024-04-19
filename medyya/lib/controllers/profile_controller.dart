import '../models/profile_model.dart';
import 'package:medyya/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetProfile{
  String? token;
  GetProfile({required this.token});

  Future<UserProfile> get_profile() async {
    final Uri uri = Uri.parse('$hosting_url/api/users/profile/view/mine/');
    final res = await http.get(
      uri,
      headers: {'Content-Type':'application/json', "Authorization":"Token $token"}
    );
    try{
      final profile = jsonDecode(res.body);
      return UserProfile.fromJson(profile);
    }
    catch(_){
      print(_);
      throw Exception('Failed to load user profile');
    }
  }
}
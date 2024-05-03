import '../models/profile_model.dart';
import 'package:medyya/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetProfile{
  String? token;
  GetProfile({required this.token});

  Future<UserProfile> get_profile({String username=''}) async {
    if(username=='')
      {
        username = 'mine';
      }
    final Uri uri = Uri.parse('$hosting_url/api/users/profile/view/$username/');
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
      throw Exception('!!Failed to load user profile');
    }
  }

  Future<bool> updateUserProfile(UserProfile updatedProfile, bool imageChange) async {
    final Uri uri = Uri.parse('$hosting_url/api/users/profile/update/');
    final Uri uri_for_user = Uri.parse('$hosting_url/api/users/profile/user-update/');
    final res = await http.put(
      uri_for_user,
      headers: {'Content-Type':'application/json', "Authorization":"Token $token"},
      body: jsonEncode({
        "first_name" : updatedProfile.firstName,
        "last_name" : updatedProfile.lastName
      })
    );

    var request = http.MultipartRequest('PUT', uri);
    request.fields['bio'] = updatedProfile.bio;
    // Add profile picture
    if (imageChange) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_picture', // Field name for the image file
          updatedProfile.profilePicture,
        ),
      );
    }

    // Add token to headers
    request.headers['Authorization'] = 'Token $token';

    var response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.reasonPhrase);
      return false;
    }
  }


}
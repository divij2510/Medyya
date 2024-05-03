import '../models/post_model.dart';
import 'package:medyya/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class GetPosts{
  String? token;
  GetPosts({required this.token});

  Future<List<PostModel>> get_posts() async{
    final Uri uri = Uri.parse('$hosting_url/api/posts/view/all/');
    final res = await http.get(
        uri,
        headers: {'Content-Type':'application/json', "Authorization":"Token $token"}
    );
    try{
      final posts = jsonDecode(res.body) as List<dynamic>;
      var postss = posts.map((e) => PostModel.fromJson(e)).toList();
      //print(postss);
      return postss;
    }
    catch (_) {
      return [];
    }

  }
  Future<bool> like({required int id, required bool to_like}) async{
    Uri uri=Uri.parse('');
    if(to_like==true) {
      uri = Uri.parse('$hosting_url/api/posts/like/$id/');
    }
    else{
      uri = Uri.parse('$hosting_url/api/posts/unlike/$id/');
    }

    final res = await http.post(
      uri,
      headers: {'Content-Type':'application/json', "Authorization":"Token $token"},
    );
    if(res.statusCode==201||res.statusCode==208||res.statusCode==410)
      {
        return true;
      }
    else{
        return false;
    }
  }
  Future<bool> check_like(int id) async{
    final Uri uri = Uri.parse('$hosting_url/api/posts/check-like/$id/');
    final res = await http.get(
      uri,
      headers: {'Content-Type':'application/json', "Authorization":"Token $token"},
    );
    if(res.statusCode==208){
      return true;
    }
    else{
      return false;
    }
  }
  Future<bool> make_post({required String bio, required String pickedImagePath}) async {
    final Uri uri = Uri.parse('$hosting_url/api/posts/create/');
    var request = http.MultipartRequest('POST', uri);
    if(pickedImagePath=='')
      {
        return false;
      }
    request.fields['caption'] = bio;
    request.files.add(
      await http.MultipartFile.fromPath(
        'post_image', // Field name for the image file
        pickedImagePath,
      ),
    );
    request.headers['Authorization'] = 'Token $token';
    var response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 201) {
      return true;
    } else {
      print(response.reasonPhrase);
      return false;
    }
  }

}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seoul_education_service/community/models/postlist.dart';
import 'package:seoul_education_service/community/constant.dart';
class ApiService{

  static Future<List<Data>?> fetchPosts() async{
    var response = await http.get(Uri.parse('$localhost/post'));
    if(response.statusCode == 200){
      var jsonResponse = jsonDecode(response.body);
      var posts = postlist.fromJson(jsonResponse);
      return posts.data;
    }else{
      print('${response.statusCode}');
    }
  }
}
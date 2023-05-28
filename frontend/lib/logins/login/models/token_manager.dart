import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/course_api.dart';

class CustomTokenManager {

  callRefreshToken(String accessToken, String refreshToken) async {

    String endPointUrl = LoginAPI().Reissuance();
    final Uri url = Uri.parse(endPointUrl);

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'accessToken': 'Bearer $accessToken',
        'refreshToken': 'Bearer $refreshToken',
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', jsonResponse['accessToken'] as String);
      await prefs.setString('refreshToken', jsonResponse['refreshToken'] as String);
    } else {
      throw Exception('Failed to refresh access token');
    }
  }
}
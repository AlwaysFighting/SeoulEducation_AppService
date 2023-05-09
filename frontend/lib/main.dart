import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:seoul_education_service/logins/login/views/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'const/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  KakaoSdk.init(
    nativeAppKey: '${FlutterConfig.get('KAKAOLOGIN_APP_KEY')}',
  );

  // SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  // String? email = prefs.getString('email');
  // String? password = prefs.getString('password');
  //
  // bool isLoggedIn = email != null && password != null;

  bool isLoggedIn = false;

  runApp(
    _APP(
      isLoggedIn: isLoggedIn,
    ),
  );
}

class _APP extends StatelessWidget {
  final bool isLoggedIn;

  const _APP({
    super.key,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Spoqa Han Sans Neo'),
      home: isLoggedIn ?  const Navigation() : const LoginPage(),
    );
  }
}

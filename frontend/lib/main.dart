import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:seoul_education_service/logins/login/views/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  KakaoSdk.init(
    nativeAppKey: '${FlutterConfig.get('KAKAOLOGIN_APP_KEY')}',
  );

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Spoqa Han Sans Neo'),
      home: const LoginPage(),
    ),
  );
}

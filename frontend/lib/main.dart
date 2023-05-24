import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:seoul_education_service/logins/login/views/login_page.dart';
import 'const/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  AuthRepository.initialize(appKey: '${FlutterConfig.get('KAKAO_JAVA_KEY')}' ?? '');

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

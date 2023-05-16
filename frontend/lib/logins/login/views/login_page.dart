import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'package:seoul_education_service/const/navigation.dart';
import 'package:seoul_education_service/logins/register/views/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/course_api.dart';
import '../models/divider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // 패스워드 보이기 유무
  bool hidePassword = true;

  late final TextEditingController _loginEditingController = TextEditingController();
  late final TextEditingController _passwordEditingController = TextEditingController();

  bool _isLoginButtonEnabled = false;
  bool _isEmailError = false;
  bool _isPasswordError = false;

  final mainTextStyle = const TextStyle(
    color: textColor1,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: "Spoqa Han Sans Neo",
  );

  void _kakaoLoginState() async {
    // 카카오 로그인 구현 예제
    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인

    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  void _updateLoginButtonState() {
    setState(() {
      _isLoginButtonEnabled = _loginEditingController.text.isNotEmpty &&
          _passwordEditingController.text.isNotEmpty;
    });
  }

  _isLogin(String key, String value) async {
    final response = await http.post(
      Uri.parse(EMAIL_LOGIN_API),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': key,
        'password': value,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _isEmailError = false;
        _isPasswordError = false;
      });

      final responseJson = json.decode(response.body);
      final String accessToken = responseJson['data']['accessToken'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('accessToken', accessToken);

      // await prefs.setString('email', key);
      // await prefs.setString('password', value);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Navigation()),
      );

    } else if (response.statusCode == 401) {
      print("로그인 실패: 해당 이메일이 존재하지 않습니다.");
      setState(() {
        _isEmailError = true;
      });
    } else if (response.statusCode == 403) {
      print("로그인 실패: 비밀번호가 틀렸습니다.");
      setState(() {
        _isPasswordError = true;
      });
    } else {
      print("운영팀에게 문의주세요.");
    }
  }

  void _handleButtonPressed(String key, String value) {
    _isLogin(key, value);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 120),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: const [
                      Text("LOGO",
                          style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Spoqa Han Sans Neo",
                              color: Color(0xFF737373))),
                      // Image.asset(
                      //   "assets/images/logo.png",
                      //   // 이미지 꽉차게 적용하기
                      //   fit: BoxFit.fill,
                      //   height: 70,
                      //   width: 100,
                      // ),
                    ],
                  ),
                  const SizedBox(height: 105),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("아이디(이메일)", style: mainTextStyle),
                        const SizedBox(height: 10),
                        _login(),
                        const SizedBox(height: 16),
                        Text("비밀번호", style: mainTextStyle),
                        const SizedBox(height: 10),
                        _password(),
                        const SizedBox(height: 40.0),
                        _loginBtn(),
                        const SizedBox(height: 22.0),
                        const ORDivider(),
                        const SizedBox(height: 22.0),
                        _kakaoLoginBtn(),
                        const SizedBox(height: 100.0),
                        _register(mainTextStyle: mainTextStyle)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Center _kakaoLoginBtn() {
    return Center(
      child: SizedBox(
        height: 48,
        child: OutlinedButton(
          autofocus: false,
          onPressed: () {
            print("카카오톡 로그인");
            _kakaoLoginState();
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 358),
            side: const BorderSide(color: mainColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0), // 모서리 둥글기 정도
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 20.0),
              Image.asset(
                "assets/images/kakaoLogin.png",
                // 이미지 꽉차게 적용하기
                fit: BoxFit.fill,
              ),
              const SizedBox(width: 65.0),
              const Text(
                '카카오로 로그인',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: mainColor,
                  fontFamily: "Spoqa Han Sans Neo",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Center _loginBtn() {
    return Center(
      child: SizedBox(
        height: 48,
        child: ElevatedButton(
          autofocus: false,
          onPressed: _isLoginButtonEnabled
              ? () => _handleButtonPressed(
                  _loginEditingController.text, _passwordEditingController.text)
              : null,
          style: ElevatedButton.styleFrom(
            // 메인 컬러
            backgroundColor: _isLoginButtonEnabled ? mainColor : textColor2,
            // 버튼 안 텍스트 스타일
            textStyle: mainTextStyle.copyWith(
              fontSize: 16.0,
              color: Colors.white,
              fontFamily: "Spoqa Han Sans Neo",
            ),
            minimumSize: const Size(double.infinity, 358),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0), // 모서리 둥글기 정도
            ),
          ),
          child: const Text('로그인'),
        ),
      ),
    );
  }

  _password() {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: _passwordEditingController,
        onChanged: (_) => _updateLoginButtonState(),
        obscureText: hidePassword,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          hintText: "비밀번호를 입력해주세요.",
          hintStyle: mainTextStyle.copyWith(color: textColor2, fontWeight: FontWeight.w400),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _isPasswordError ? errorColor : backgroundBtnColor, width: _isPasswordError ? 1.0 : 0.0),
            borderRadius: BorderRadius.circular(24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            borderSide: BorderSide(width: 1, color: _isPasswordError ? errorColor : mainColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          suffixIcon: IconButton(
            icon: hidePassword
                ? const Icon(Icons.visibility_off_outlined)
                : const Icon(Icons.visibility_outlined),
            onPressed: () {
              setState(() {
                hidePassword = !hidePassword;
              });
            },
              color: _isPasswordError ? errorColor : mainColor,
          ),
          filled: true,
          fillColor: backgroundBtnColor,
        ),
      ),
    );
  }

  _login() {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: _loginEditingController,
        onChanged: (_) => _updateLoginButtonState(),
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          hintText: "이메일을 입력해주세요.",
          hintStyle: mainTextStyle.copyWith(color: textColor2, fontWeight: FontWeight.w400),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _isEmailError ? errorColor : backgroundBtnColor, width: _isEmailError ? 1.0 : 0.0),
            borderRadius: BorderRadius.circular(24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            borderSide: BorderSide(width: 1, color: _isEmailError ? errorColor : mainColor),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          filled: true,
          fillColor: backgroundBtnColor,
        ),
      ),
    );
  }
}

class _register extends StatelessWidget {
  const _register({
    super.key,
    required this.mainTextStyle,
  });

  final TextStyle mainTextStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("계정이 아직 없으신가요?"),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RegisterPage()),
            );
          },
          child: Text(
            "회원가입",
            style: mainTextStyle.copyWith(
              fontWeight: FontWeight.w700,
              color: mainColor,
            ),
          ),
        )
      ],
    );
  }
}
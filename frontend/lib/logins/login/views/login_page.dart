import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:redis/redis.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'package:seoul_education_service/logins/register/views/register_page.dart';

import '../../../home/homepage/controllers/homepage.dart';
import '../models/divider.dart';

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
  bool _isLoginError = false;

  // 서버 연결
  final conn = RedisConnection();

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

  void _connectToRedis(String email, String password) {
    conn.connect('localhost', 6379).then((Command command) {
      command.send_object(["GET", email]).then((var response) {
        if (response == password) {
          print("로그인 성공!");
          setState(() {
            _isLoginError = false;
          });
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return const HomePage();
              }));
          conn.close();
        } else {
          print("로그인 실패: 올바르지 않은 아이디 또는 비밀번호입니다.");
          setState(() {
            _isLoginError = true;
          });
          conn.close();
        }
      });
    });
  }

  void _handleButtonPressed(String key, String value) {
    // 버튼이 클릭될 때 실행될 작업을 여기에 구현합니다.
    // 예를 들어, 아이디와 비밀번호를 검증하고 로그인하는 등의 작업을 수행합니다.
    print("Key : $key, Value : $value");
    _connectToRedis(key, value);
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
      body: Padding(
        padding: const EdgeInsets.only(top: 170),
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
                    Center(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          autofocus: false,
                          onPressed: _isLoginButtonEnabled
                              ? () => _handleButtonPressed(_loginEditingController.text, _passwordEditingController.text)
                              : null,
                          style: ElevatedButton.styleFrom(
                            // 메인 컬러
                            backgroundColor: _isLoginButtonEnabled ? mainColor :textColor2,
                            // 버튼 안 텍스트 스타일
                            textStyle: mainTextStyle.copyWith(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontFamily: "Spoqa Han Sans Neo",
                            ),
                            minimumSize: const Size(double.infinity, 358),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(24.0), // 모서리 둥글기 정도
                            ),
                          ),
                          child: const Text('로그인'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22.0),
                    const ORDivider(),
                    const SizedBox(height: 22.0),
                    Center(
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
                              borderRadius:
                                  BorderRadius.circular(24.0), // 모서리 둥글기 정도
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
                    ),
                    const SizedBox(height: 100.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("계정이 아직 없으신가요?"),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => RegisterPage()),
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
                    )
                  ],
                ),
              )
            ],
          ),
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
            borderSide: BorderSide(color: _isLoginError ? errorColor : backgroundBtnColor, width: _isLoginError ? 1.0 : 0.0),
            borderRadius: BorderRadius.circular(24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            borderSide: BorderSide(width: 1, color: _isLoginError ? errorColor : mainColor),
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
              color: _isLoginError ? errorColor : mainColor,
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
            borderSide: BorderSide(color: _isLoginError ? errorColor : backgroundBtnColor, width: _isLoginError ? 1.0 : 0.0),
            borderRadius: BorderRadius.circular(24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            borderSide: BorderSide(width: 1, color: _isLoginError ? errorColor : mainColor),
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

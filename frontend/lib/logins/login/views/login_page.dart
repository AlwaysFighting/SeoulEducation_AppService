import 'package:flutter/material.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'package:seoul_education_service/logins/register/views/register_page.dart';

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

  final mainTextStyle = const TextStyle(
    color: textColor1,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: "Spoqa Han Sans Neo",
  );

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
                          onPressed: () {
                            print("Clicked");
                          },
                          style: ElevatedButton.styleFrom(
                            // 메인 컬러
                            backgroundColor: mainColor,
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
                            print("Clicked");
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
        onChanged: (value) {
          print("password: $value");
        },
        obscureText: hidePassword,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          hintText: "비밀번호를 입력해주세요.",
          hintStyle: mainTextStyle.copyWith(color: textColor2, fontWeight: FontWeight.w400),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: backgroundBtnColor, width: 0.0),
            borderRadius: BorderRadius.circular(24),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            borderSide: BorderSide(width: 1, color: mainColor),
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
        onChanged: (value) {
          print("login: $value");
        },
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          hintText: "이메일을 입력해주세요.",
          hintStyle: mainTextStyle.copyWith(color: textColor2, fontWeight: FontWeight.w400),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: backgroundBtnColor, width: 0.0),
            borderRadius: BorderRadius.circular(24),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            borderSide: BorderSide(width: 1, color: mainColor),
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

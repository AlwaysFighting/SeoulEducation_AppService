import 'package:flutter/material.dart';
import 'package:redis/redis.dart';
import 'package:seoul_education_service/const/colors.dart';

import '../models/dividers.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool allAgree = false;

  late final TextEditingController _emailEditingController = TextEditingController();
  late final TextEditingController _verifyEditingController = TextEditingController();
  late final TextEditingController _passwordEditingController = TextEditingController();
  late final TextEditingController _rePasswordEditingController = TextEditingController();
  late final TextEditingController _nameEditingController = TextEditingController();

  final mainTextStyle = const TextStyle(
    color: textColor1,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    fontFamily: "Spoqa Han Sans Neo",
  );

  final textStyle = const TextStyle(
    color: textColor1,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: "Spoqa Han Sans Neo",
  );

  final conn = RedisConnection();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailEditingController.dispose();
    _verifyEditingController.dispose();
    _passwordEditingController.dispose();
    _rePasswordEditingController.dispose();
    _nameEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        foregroundColor: textColor1,
        elevation: 0,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          clipBehavior: Clip.none,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("회원가입", style: mainTextStyle),
                    const SizedBox(height: 40.0),
                    Text("이메일", style: mainTextStyle.copyWith(fontSize: 14.0)),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        _email(),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: SizedBox(
                            width: 84,
                            height: 48,
                            child: ElevatedButton(
                              autofocus: false,
                              onPressed: (){

                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainColor,
                                textStyle: mainTextStyle.copyWith(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                              child: const Text('인증하기'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Text("인증번호", style: mainTextStyle.copyWith(fontSize: 14.0)),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        _verified(),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: SizedBox(
                            width: 84,
                            height: 48,
                            child: ElevatedButton(
                              autofocus: false,
                              onPressed: () {
                                print("Login Button");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainColor,
                                textStyle: mainTextStyle.copyWith(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                              child: const Text('확인'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Text("비밀번호", style: mainTextStyle.copyWith(fontSize: 14.0)),
                    const SizedBox(height: 10.0),
                    _password("비밀번호를 입력해주세요."),
                    const SizedBox(height: 16.0),
                    Text("비밀번호 확인",
                        style: mainTextStyle.copyWith(fontSize: 14.0)),
                    const SizedBox(height: 10.0),
                    _RePassword("비밀번호를 다시 입력해주세요."),
                    const SizedBox(height: 16.0),
                    Text("이름", style: mainTextStyle.copyWith(fontSize: 14.0)),
                    const SizedBox(height: 10.0),
                    _userName(),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
              const Dividers(),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("약관동의", style: textStyle),
                        const SizedBox(height: 16.0),
                        Card(
                          color: Colors.white,
                          shape: const RoundedRectangleBorder(
                              side: BorderSide(color: lineColor, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          clipBehavior: Clip.antiAlias,
                          child: SizedBox(
                            width: 358.0,
                            height: 210.0,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  height: 48.0,
                                  color: Colors.white,
                                  child: _terms("전체 동의합니다."),
                                ),
                                const Divider(
                                  height: 10,
                                  thickness: 1,
                                  indent: 0,
                                  endIndent: 0,
                                  color: lineColor,
                                ),
                                Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        children: [
                                          _terms("이용약관에 동의 합니다. (필수)"),
                                          _terms("개인정보 수집 및 이용에 동의합니다. (필수)"),
                                          _terms("만 14세 이상입니다. (필수)"),
                                        ],
                                      )),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 80.0,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: allAgree ? _doSomething : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: mainColor,
            disabledBackgroundColor: const Color(0xFF5DBFF0),
            alignment: Alignment.center,
          ),
          child: Text('가입하기', style: textStyle.copyWith(fontSize: 16.0, color: Colors.white)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Row _terms(String termsText) {
    return Row(
      children: [
        Material(
          child: Checkbox(
            value: allAgree,
            onChanged: (value) {
              setState(() {
                allAgree = value ?? false;
              });
            },
            checkColor: Colors.white,
            shape: const CircleBorder(),
            activeColor: mainColor,
          ),
        ),
        Text(
          termsText,
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }

  void _doSomething() {
    print("가입하기!");
  }

  _userName() {
    return SizedBox(
      width: 260,
      height: 48,
      child: TextField(
        controller: _nameEditingController,
        onChanged: (value) {
          print("닉네임: $value");
        },
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          hintText: "사용할 닉네임을 입력해주세요.",
          hintStyle: textStyle.copyWith(
              color: textColor2, fontWeight: FontWeight.w400),
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

  _email() {
    return SizedBox(
      width: 260,
      height: 48,
      child: TextField(
        controller: _emailEditingController,
        onChanged: (value) {
          String? email = _emailEditingController.text;
          if (true) {
            // 이메일 형식이 맞는 경우
          } else {
            // 이메일 형식이 아닌 경우
          }
        },
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          hintText: "이메일을 입력해주세요.",
          hintStyle: textStyle.copyWith(
              color: textColor2, fontWeight: FontWeight.w400),
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

  _verified() {
    return SizedBox(
      width: 260,
      height: 48,
      child: TextField(
        controller: _verifyEditingController,
        onChanged: (value) {
          print("인증번호 : $value");
        },
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          hintText: "인증번호를 입력해주세요.",
          hintStyle: textStyle.copyWith(
              color: textColor2, fontWeight: FontWeight.w400),
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

  _password(String hintTexts) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: _passwordEditingController,
        onChanged: (value) {
          print("비밀번호 : $value");
        },
        obscureText: true,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          hintText: hintTexts,
          hintStyle: textStyle.copyWith(
              color: textColor2, fontWeight: FontWeight.w400),
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
          filled: true,
          fillColor: backgroundBtnColor,
        ),
      ),
    );
  }

  _RePassword(String hintTexts) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: _rePasswordEditingController,
        onChanged: (value) {
          print("비밀번호 확인: $value");
        },
        obscureText: true,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          hintText: hintTexts,
          hintStyle: textStyle.copyWith(
              color: textColor2, fontWeight: FontWeight.w400),
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
          filled: true,
          fillColor: backgroundBtnColor,
        ),
      ),
    );
  }
}

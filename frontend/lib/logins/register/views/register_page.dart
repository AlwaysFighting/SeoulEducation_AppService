import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'package:http/http.dart' as http;

import '../../../api/course_api.dart';
import '../models/dividers.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _emailEditingController =
      TextEditingController();
  late final TextEditingController _verifyEditingController =
      TextEditingController();
  late final TextEditingController _passwordEditingController =
      TextEditingController();
  late final TextEditingController _rePasswordEditingController =
      TextEditingController();
  late final TextEditingController _nameEditingController =
      TextEditingController();

  // 텍스트필드 Null 값 판단
  bool _isAuthButtonEnabled = false;
  bool _isAuthConfirmButtonEnabled = false;

  // 등록하기 버튼 활성화 유무
  bool _isRegisterButtonEnabled = false;

  // 이름
  bool _isUserButtonEnabled = false;

  bool isPasswordWrite = false;
  bool isRePasswordWrite = false;
  int isEqualedPassword = 0;

  bool isEmailVerify = false;
  int isCodeVerify = 0;

  bool isNameWrite = false;
  bool allAgree = false;

  Duration duration = const Duration(seconds: 300);
  int _remainingSeconds = 300;
  bool isTimerRunning = false;

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

  String get timerDisplayString {
    int minutes = (_remainingSeconds ~/ 60).toInt();
    int seconds = (_remainingSeconds % 60).toInt();

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void popScreen(BuildContext context) {
    Navigator.of(context).pop();
  }

  void updateRegisterButtonState() {
    setState(
      () {
        _isRegisterButtonEnabled = isEmailVerify &&
            isCodeVerify == 3 &&
            isEqualedPassword == 2 &&
            _isUserButtonEnabled &&
            allAgree;
      },
    );
  }

  void _startTimer() {
    setState(() {
      isTimerRunning = true;
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          isTimerRunning = false;
          timer.cancel();
        }
      });
    });
  }

  void _updateUserButtonState() {
    setState(() {
      _isUserButtonEnabled = _nameEditingController.text.isNotEmpty;
      updateRegisterButtonState();
    });
  }

  void _equaledPassword() {
    setState(
      () {
        if (_passwordEditingController.text == _rePasswordEditingController.text) {
          isEqualedPassword = 2;
        } else {
          isEqualedPassword = 1;
        }
        updateRegisterButtonState();
      },
    );
  }

  void _updateAuthButtonState() {
    setState(() {
      _isAuthButtonEnabled = _emailEditingController.text.isNotEmpty;
    });
  }

  void _updateAuthConfirmButtonState() {
    setState(() {
      _isAuthConfirmButtonEnabled = _verifyEditingController.text.isNotEmpty;
      updateRegisterButtonState();
    });
  }

  // 등록하기 API
  void _handleRegisterButton(
      String emailText, String passwordText, String nicknameText) async {
    final response = await http.post(
      Uri.parse(REGISTER_API),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": emailText,
        "password": passwordText,
        "nickname": nicknameText,
      }),
    );

    // Response Body - message
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final String message = responseData['message'];

    if (response.statusCode == 200) {
      print("회원가입 성공! : ${response.body}");
      setState(() {
        popScreen(context);
      });
    } else if (message == "Email Already Exists") {
      setState(() {
        isEmailVerify = false;
      });
      print("해당 이메일로 이미 가입된 정보가 존재합니다.");
    } else if (message == "Invalid Password") {
      print("비밀번호 값이 유효성 검사를 통과하지 못했습니다.");
    } else if (message == "Invalid Nickname.") {
      _isUserButtonEnabled = false;
      print("닉네임 값이 유효성 검사를 통과하지 못했습니다.");
    } else {
      print("Server Error");
    }
  }

  // 이메일 전송 API
  void _handleEmailButton(String emailText) async {
    final response = await http.post(
      Uri.parse(EMAIL_CODE_REQUEST_API),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': emailText,
      }),
    );

    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final String message = responseData['message'];

    if (response.statusCode == 200) {
      print("이메일 요청 성공! : ${response.body}");
      setState(() {
        isEmailVerify = true;
        isCodeVerify = 1;
        _startTimer();
      });
    } else if (message == "Email Already Exists") {
      setState(() {
        isEmailVerify = false;
      });
      print("해당 이메일로 이미 가입된 정보가 존재합니다.");
    } else if (message == "Invalid Email.") {
      setState(() {
        isEmailVerify = false;
      });
      print("이메일 값이 올바르지 않습니다.");
    } else {
      print("Server Error");
    }
  }

  // 인증코드 API
  void _handleConfirmButton(String email, String confirmText) async {
    final response = await http.post(
      Uri.parse(EMAIL_CODE_CONFIRM_API),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'code': confirmText,
      }),
    );

    if (response.statusCode == 200) {
      print("확인 성공!");
      setState(() {
        isCodeVerify = 3;
      });
    } else if (response.statusCode == 400) {
      setState(() {
        isCodeVerify = 2;
      });
      print("요청하신 이메일이 아닙니다..");
    } else if (response.statusCode == 401) {
      setState(() {
        isCodeVerify = 2;
      });
      print("인증코드가 일치하지 않습니다.");
    } else {
      print("서버 오류.");
      print(response.body);
    }
  }

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
                    _email(),
                    const SizedBox(height: 16.0),
                    Text("인증번호", style: mainTextStyle.copyWith(fontSize: 14.0)),
                    const SizedBox(height: 10.0),
                    _verify(),
                    const SizedBox(height: 8.0),
                    isCodeVerify == 2
                        ? const Text(
                            " 인증번호가 일치하지 않습니다.",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: errorColor,
                            ),
                          )
                        : Container(),
                    const SizedBox(height: 8.0),
                    Text("비밀번호", style: mainTextStyle.copyWith(fontSize: 14.0)),
                    const SizedBox(height: 10.0),
                    _password("비밀번호를 입력해주세요."),
                    const SizedBox(height: 16.0),
                    Text("비밀번호 확인",
                        style: mainTextStyle.copyWith(fontSize: 14.0)),
                    const SizedBox(height: 10.0),
                    _rePassword("비밀번호를 다시 입력해주세요."),
                    const SizedBox(height: 8.0),
                    isEqualedPassword == 1 && _passwordEditingController.text.isNotEmpty
                        ? const Text(
                            " 비밀번호가 일치하지 않습니다.",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: errorColor,
                            ),
                          )
                        : Container(),
                    const SizedBox(height: 8.0),
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
                        _agreement(),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _registerButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // 등록하기 버튼
  SizedBox _registerButton() {
    return SizedBox(
      height: 80.0,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isRegisterButtonEnabled
            ? () {
                _handleRegisterButton(_emailEditingController.text, _passwordEditingController.text, _nameEditingController.text);
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: mainColor,
          disabledBackgroundColor: const Color(0xFF5DBFF0),
          alignment: Alignment.center,
        ),
        child: Text('가입하기',
            style: textStyle.copyWith(fontSize: 16.0, color: Colors.white)),
      ),
    );
  }

  Card _agreement() {
    return Card(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
          side: BorderSide(color: lineColor, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
    );
  }

  // 이메일
  Row _email() {
    return Row(
      children: [
        SizedBox(
          width: 260,
          height: 48,
          child: TextFormField(
            controller: _emailEditingController,
            onChanged: (_) => _updateAuthButtonState(),
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              hintText: "이메일을 입력해주세요.",
              hintStyle: textStyle.copyWith(
                  color: textColor2, fontWeight: FontWeight.w400),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: backgroundBtnColor, width: 0.0),
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
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              autofocus: false,
              onPressed: _isAuthButtonEnabled
                  ? () => _handleEmailButton(
                        _emailEditingController.text,
                      )
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isAuthButtonEnabled ? mainColor : textColor2,
                textStyle: mainTextStyle.copyWith(
                  fontSize: 15.0,
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
    );
  }

  // 인증번호
  Row _verify() {
    return Row(
      children: [
        SizedBox(
          width: 260,
          height: 48,
          child: Stack(
            children: [
              TextFormField(
                controller: _verifyEditingController,
                onChanged: (_) => _updateAuthConfirmButtonState(),
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  hintText: "인증번호를 입력해주세요.",
                  hintStyle: textStyle.copyWith(
                      color: textColor2, fontWeight: FontWeight.w400),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                      BorderSide(color: isCodeVerify == 3 || isCodeVerify == 0 ||  isCodeVerify == 1 ? backgroundBtnColor : errorColor, width: isCodeVerify == 3 || isCodeVerify == 0 ||  isCodeVerify == 1  ? 0.0 : 1.0),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                    borderSide: BorderSide(width: 1, color: isCodeVerify == 3 || isCodeVerify == 0 ||  isCodeVerify == 1  ? mainColor : errorColor),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  filled: true,
                  fillColor: backgroundBtnColor,
                ),
              ),
              isTimerRunning && isCodeVerify == 1
                  ? Positioned(
                      right: 15,
                      bottom: 16,
                      child: Text(
                        timerDisplayString,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: mainColor,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              autofocus: false,
              onPressed: _isAuthConfirmButtonEnabled
                  ? () => _handleConfirmButton(
                        _emailEditingController.text,
                        _verifyEditingController.text,
                      )
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isAuthConfirmButtonEnabled ? mainColor : textColor2,
                textStyle: mainTextStyle.copyWith(
                  fontSize: 15.0,
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
    );
  }

  // 비밀번호 입력
  _password(String hintTexts) {
    return SizedBox(
      height: 48,
      child: TextFormField(
        controller: _passwordEditingController,
        onChanged: (value) {},
        obscureText: true,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          hintText: hintTexts,
          hintStyle: textStyle.copyWith(
            color: textColor2,
            fontWeight: FontWeight.w400,
          ),
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

  // 비밀번호 재입력
  _rePassword(String hintTexts) {
    return SizedBox(
      height: 48,
      child: TextFormField(
        controller: _rePasswordEditingController,
        onChanged: (_) => _equaledPassword(),
        obscureText: true,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          hintText: hintTexts,
          hintStyle: textStyle.copyWith(
              color: textColor2, fontWeight: FontWeight.w400),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: isEqualedPassword == 2 || isEqualedPassword == 0 ? backgroundBtnColor: errorColor, width: isEqualedPassword == 2 ? 0.0 : 1.0),
            borderRadius: BorderRadius.circular(24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            borderSide: BorderSide(width: 1, color: isEqualedPassword == 2 || isEqualedPassword == 0 ? mainColor : errorColor),
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

  // 사용할 닉네임
  _userName() {
    return SizedBox(
      width: 260,
      height: 48,
      child: TextFormField(
        controller: _nameEditingController,
        onChanged: (_) => _updateUserButtonState(),
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

  // 약관동의
  Row _terms(String termsText) {
    return Row(
      children: [
        Material(
          child: Checkbox(
            value: allAgree,
            onChanged: (value) {
              setState(() {
                allAgree = value ?? false;
                updateRegisterButtonState();
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
}

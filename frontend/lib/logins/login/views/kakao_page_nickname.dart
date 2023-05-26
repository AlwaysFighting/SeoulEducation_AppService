import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/course_api.dart';
import '../../../const/back_button.dart';
import '../../../const/colors.dart';
import '../../../const/navigation.dart';

import 'package:http/http.dart' as http;

class KakaoLickname extends StatefulWidget {

  final int id;

  const KakaoLickname({Key? key, required this.id}) : super(key: key);

  @override
  State<KakaoLickname> createState() => _KakaoLicknameState();
}

class _KakaoLicknameState extends State<KakaoLickname> {
  late final TextEditingController _nameEditingController =
      TextEditingController();

  // 등록하기 버튼 활성화 유무
  bool _isRegisterButtonEnabled = false;

  // 이름
  bool _isUserButtonEnabled = false;

  // 확인 눌렀을 때 null 인 경우
  bool checkNull = false;

  void _updateUserButtonState() {
    setState(() {
      _isUserButtonEnabled = _nameEditingController.text.isNotEmpty;
      updateRegisterButtonState();
    });
  }

  void updateRegisterButtonState() {
    setState(
      () {
        _isRegisterButtonEnabled = _isUserButtonEnabled;
      },
    );
  }

  // 닉네임 설정하기
  Future<void> kakaoCreateNickame(String nick) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userID = prefs.getInt('userID');

    String endPointUrl = LoginAPI().RegisterLickname(userID ?? 0);

    final response = await http.post(
      Uri.parse(endPointUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nickname': nick,
      }),
    );

    String responseBody = response.body;
    Map<String, dynamic> responseData = jsonDecode(responseBody);
    final String accessToken = responseData['data']['accessToken'];

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', accessToken);
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) {
            return const Navigation();
          }));
    } else {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: const CustomBackButton(),
          elevation: 0,
          title: const Text(
            "닉네임 설정",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: textColor1,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "닉네임",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                  color: textColor1,
                ),
              ),
              const SizedBox(height: 15.0),
              _userName(),
            ],
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 60.0,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_isRegisterButtonEnabled == true) {
                kakaoCreateNickame(_nameEditingController.text);
              }
            },
            style: ElevatedButton.styleFrom(
              primary: _isRegisterButtonEnabled == true
                  ? mainColor
                  : const Color(0xFF5DBFF0),
            ),
            child: const Text(
              '확인',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _userName() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: TextFormField(
        controller: _nameEditingController,
        onChanged: (_) => _updateUserButtonState(),
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          hintText: "사용할 닉네임을 입력해주세요.",
          hintStyle: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: textColor2,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: backgroundBtnColor, width: 0.0),
            borderRadius: BorderRadius.circular(24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            borderSide: _nameEditingController.text.isEmpty
                ? const BorderSide(width: 1, color: errorColor)
                : const BorderSide(width: 1, color: mainColor),
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

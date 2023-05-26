import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'changeprivate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:seoul_education_service/api/course_api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class changepassword extends StatefulWidget{
  final usernickname;
  const changepassword({Key? key, required this.usernickname}):super(key:key);

  @override
  State<changepassword> createState() => _changepassword();
}
class _changepassword extends State<changepassword> {
  bool _showSuffixicon1 = false;
  bool _showSuffixicon2 = false;
  bool _showSuffixicon3 = false;
  bool _iscorrespond = false;
  bool _isnotcorrect = false;
  final TextEditingController _currentcontroller = TextEditingController();
  final TextEditingController _newcontroller = TextEditingController();
  final TextEditingController _checkcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    ScreenUtil.init(context);
    _loadAccessToken();
  }

  Future<String?> _loadAccessToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> _editPassword() async {
    String? accessToken = await _loadAccessToken();
    final url = Uri.parse(API_MYPAGE_PASSWORD_CHANGE);
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };
    final body = jsonEncode(
        {"password": _currentcontroller.text,
          "newPassword": _checkcontroller.text});
    final response = await http.patch(
      url, headers: headers, body: body
    );
    if(response.statusCode == 200){
      print("Updated Successfully");
    }
    else if(response.statusCode == 401)
      {
        print("Token problem");
      }
    else if(response.statusCode == 403){
      print("Invalid User");
      setState(() {
        _isnotcorrect = true;
      });
    }
    else if(response.statusCode == 400){
      print("Invalid Password");
    }
    else{
      print("Server error");
    }
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SizedBox(height: 44.h,),
          appbar(),
          SizedBox(height: 20.h,),
          content(),
          Spacer(),
          success(),
        ],
      ),
    );
  }

  Widget appbar() {
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 56,
      child: Row(
        children: [
          SizedBox(width: 16,),
          GestureDetector(
            onTap: () {
              //알림창
              backDialog();
            },
            child: Image.asset(
              'assets/images/Const/ArrowLeft.png', width: 24, height: 24),
          ),
          SizedBox(width: 109.w),
          Expanded(
            child: Container(
              //alignment: Alignment.center,
              child: Text("기본정보 수정",
                style: TextStyle(
                  fontFamily: 'Spoqa Han Sans Neo',
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget content(){
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 16),
            Text("현재 비밀번호",
            style: TextStyle(
              fontFamily: 'Spoqa Han Sans Neo',
              fontSize: 14,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
            ),)
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            SizedBox(width: 16),
            SizedBox(
              width: 358.w,
              height: 48.h,
              child: TextFormField(
                obscureText: true,
                controller: _currentcontroller,
                onChanged: (currentcontroller){
                  setState(() {
                    _showSuffixicon1 = currentcontroller.isNotEmpty;
                  });
                },
                style: TextStyle(
                  fontFamily: 'Spoqa Han Sans Neo',
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  suffixIcon: Visibility(
                    visible: _currentcontroller.text.isNotEmpty,
                    child:GestureDetector(
                      onTap: (){
                        _currentcontroller.clear();
                      },
                      child: const Icon(Icons.cancel, color:textColor2),
                    ),
                  ),
                  border: InputBorder.none,
                  hintText: "현재 비밀번호 입력",
                  hintStyle: TextStyle(
                    fontFamily: 'Spoqa Han Sans Neo',
                    fontSize:14,
                    color: textColor2,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: EdgeInsets.fromLTRB(16.w, 16.h, 232.w, 15.h ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:_isnotcorrect ? errorColor: mainColor),
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                    borderSide: BorderSide(color:_isnotcorrect ? errorColor: mainColor),
                  ),
                  filled: true,
                  fillColor: backgroundBtnColor,
                ),
              ),
            ),
          ],
        ),
        Visibility(
          visible: _isnotcorrect,
            child: Column(
              children: [
                SizedBox(height: 8.h,),
                Row(
                  children: [
                    SizedBox(width: 16),
                    Text("비밀번호가 맞지 않습니다. 다시 확인해주세요",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Spoqa Han Sans Neo',
                      color: errorColor,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                    ),),
                  ],
                ),
              ],
            )),
        //새로운 비밀번호 입력하는
        SizedBox(height: 40.h,),
        Row(
          children: [
            SizedBox(width: 16.w,),
            Text("새로운 비밀번호",
              style: TextStyle(
                fontFamily: 'Spoqa Han Sans Neo',
                fontSize: 14,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
              ),)
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            SizedBox(width: 16),
            SizedBox(
              width: 358.w,
              height: 48.h,
              child: TextFormField(
                obscureText: true,
                controller: _newcontroller,
                onChanged: (newcontroller){
                  setState(() {
                    _showSuffixicon2 = newcontroller.isNotEmpty;
                  });
                },
                style: TextStyle(
                  fontFamily: 'Spoqa Han Sans Neo',
                  fontSize: 14.sp,
                ),
                decoration: InputDecoration(
                  suffixIcon: Visibility(
                    visible: _newcontroller.text.isNotEmpty,
                    child:GestureDetector(
                        onTap: (){
                          _newcontroller.clear();
                        },
                        child:const Icon(Icons.cancel, color:textColor2),
                    ),
                  ),
                  border: InputBorder.none,
                  hintText: "새로운 비밀번호를 입력해주세요",
                  hintStyle: TextStyle(
                    fontFamily: 'Spoqa Han Sans Neo',
                    fontSize: ScreenUtil().setSp(14),
                    color: textColor2,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: EdgeInsets.fromLTRB(16.w, 16.h, 236.w, 15.h
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: mainColor),
                    borderRadius: BorderRadius.all(Radius.circular(24)),

                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    borderSide: BorderSide(color: mainColor),
                  ),
                  filled: true,
                  fillColor: backgroundBtnColor,
                ),
              ),
            ),
          ],
        ),
        //비밀번호 확인
        SizedBox(height: 40.h,),
        Row(
          children: [
            SizedBox(width: 16.w,),
            Text("새로운 비밀번호 확인",
              style: TextStyle(
                fontFamily: 'Spoqa Han Sans Neo',
                fontSize: 14,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
              ),)
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            SizedBox(width: 16),
            SizedBox(
              width: 358.w,
              height: 48.h,
              child: TextFormField(
                obscureText: true,
                controller: _checkcontroller,
                onChanged: (checkcontroller){
                  setState(() {
                    _showSuffixicon3 = checkcontroller.isNotEmpty;
                  });
                },
                style: TextStyle(
                  fontFamily: 'Spoqa Han Sans Neo',
                  fontSize: 14.sp,
                ),
                decoration: InputDecoration(
                  suffixIcon: Visibility(
                    visible: _checkcontroller.text.isNotEmpty,
                    child:GestureDetector(
                        onTap: (){
                          _checkcontroller.clear();
                        },
                        child:const Icon(Icons.cancel, color:textColor2),
                    ),
                  ),
                  border: InputBorder.none,
                  hintText: "새로운 비밀번호를 한번 더 입력해주세요",
                  hintStyle: TextStyle(
                    fontFamily: 'Spoqa Han Sans Neo',
                    fontSize: 14,
                    color: textColor2,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: EdgeInsets.fromLTRB(16.w, 16.h, 236.w, 15.h
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _iscorrespond ? errorColor : mainColor),
                    borderRadius: const BorderRadius.all(Radius.circular(24)),

                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                    borderSide: BorderSide(color:_iscorrespond ? errorColor : mainColor),
                  ),
                  filled: true,
                  fillColor: backgroundBtnColor,
                ),
              ),
            ),
          ],
        ),
        Visibility(
            visible: _iscorrespond,
            child: Column(
              children: [
                SizedBox(height: 8.h,),
                Row(
                  children: [
                    SizedBox(width: 16.w,),
                    Text("비밀번호가 맞지 않습니다. 다시 확인해주세요.",
                      style: TextStyle(
                        fontFamily: 'Spoqa Han Sans Neo',
                        fontSize: 12,
                        color:errorColor,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ],
            )),
      ],
    );
  }

  void backDialog(){
    showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
            ),
            title: Column(
              children: <Widget>[
                Text("뒤로가기",
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'Spoqa Han Sans Neo',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                  ),),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("변경사항이 저장되지 않습니다.\n그래도 나가시겠습니까?",
                  style: TextStyle(
                    fontFamily: 'Spoqa Han Sans Neo',
                    fontSize: 13,
                    color: textColor2,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                  ),

                )
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                  },
                      child: const Text("아니요",
                        style: TextStyle(
                          fontFamily: 'Spoqa Han Sans Neo',
                          color: mainColor,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  TextButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => changeprivate(usernickname: widget.usernickname,),
                      ),
                    );
                  },
                      child: const Text("예",
                        style: TextStyle(
                          fontFamily: 'Spoqa Han Sans Neo',
                          color: mainColor,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                ],
              )
            ],
          );
        });
  }
  Widget success(){
    return GestureDetector(
      onTap: () async{
        //패스워드 확인 결과 불일치라면
        if(_newcontroller.text != _checkcontroller.text)
          {
            setState(() {
              _iscorrespond =true;
            });
          }
        else{
          await _editPassword();
          if(_isnotcorrect)
            {
              print("현재 비밀번호를 다시 확인하세요");
            }
          else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => changeprivate(usernickname: widget.usernickname,),
              ),
            );
          }
        }
      },
      child: Container(
        height: 80.h,
        color: mainColor,
        child: Center(
          child: Text("확인",
            style: TextStyle(
              fontFamily: 'Spoqa Han Sans Neo',
              fontSize: 16,
              color: Colors.white,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
            ),),
        ),
      ),
    );
  }


}
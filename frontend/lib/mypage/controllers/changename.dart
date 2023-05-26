import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'package:seoul_education_service/mypage/controllers/changeprivate.dart';
import 'package:seoul_education_service/api/course_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class changename extends StatefulWidget{
  final usernickname;
  final email;
  const changename({Key? key, required this.usernickname, this.email}):super(key:key);
  @override
  State<changename> createState() => _changename();
}
class _changename extends State<changename> {
  late String _updateNickname;
  bool _showSuffixicon = false;
  final TextEditingController _textcontroller = TextEditingController();
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

  Future<void> _editNickname() async{
    String? accessToken = await _loadAccessToken();
    final url = Uri.parse(API_MYPAGE_NICKCHANGE);
    final headers = {'Authorization' : 'Bearer $accessToken', 'Content-Type': 'application/json'};
    final body = jsonEncode({"nickname":_textcontroller.text});
    final response = await http.patch(url, headers:headers, body:body);
    if(response.statusCode == 200){
      print("Updated Successfully");
    }
    else{
      print('${response.statusCode}');
    }
  }

  @override
  void didChange(){
    super.didChangeDependencies();
    _updateNickname = widget.usernickname;
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
      height: 56.h,
      child: Row(
        children: [
          SizedBox(width: 16.w,),
          GestureDetector(
            onTap: () {
              backDialog();
            },
            child: Image.asset(
              'assets/images/Const/ArrowLeft.png', width: 24, height: 24,),
          ),
          SizedBox(width: 123.w,),
          Text("이름 수정",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Spoqa Han Sans Neo',
              fontSize: 16.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  Widget content(){
    return SizedBox(
          child:Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 16,),
                  Text("이름",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Spoqa Han Sans Neo',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                    ),),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(16, 10, 16, 0),
                width: 358,
                height: 48,
                child: TextFormField(
                  controller: _textcontroller,
                  onChanged: (value){
                    setState(() {
                      _showSuffixicon = value.isNotEmpty;
                    });
                  },
                  style: TextStyle(
                    fontFamily: 'Spoqa Han Sans Neo',
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    suffixIcon: Visibility(
                      visible: _showSuffixicon,
                      child:GestureDetector(
                          onTap: (){
                            _textcontroller.clear();
                          },
                          child:Container(
                            padding: EdgeInsets.fromLTRB(0, 12, 16, 12),
                              width: 24,
                              height: 24,
                              child: Image.asset("assets/images/Const/XCircle.png"))
                      ),
                    ),
                    border: InputBorder.none,
                    hintText: "${widget.usernickname}",
                    hintStyle: TextStyle(
                      fontFamily: 'Spoqa Han Sans Neo',
                      fontSize: ScreenUtil().setSp(14),
                      color: textColor2,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(16, 16, 0, 15 ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: mainColor),
                      borderRadius: BorderRadius.all(Radius.circular(24)),

                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      borderSide: BorderSide(color:mainColor),
                    ),
                    filled: true,
                    fillColor: backgroundBtnColor,
                  ),
                ),
              ),
            ],
          )

      );
  }
  Widget success(){
    return GestureDetector(
      onTap: () async{
        if( _textcontroller.text.isNotEmpty){
        await _editNickname();
        Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) => changeprivate(usernickname:  _textcontroller.text,email: widget.email),
        ),
        );
        }
        else{
          print("이름이 입력되지 않음");
        }
      },
      child: Container(
        height: 80,
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
                        ),
                      )),
                ],
              )
            ],
          );
        });
  }
}
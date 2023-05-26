import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'selectlecture.dart';
import 'writed.dart';
import 'recentlecture.dart';
import 'changeprivate.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'package:seoul_education_service/mypage/model/memberModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:seoul_education_service/api/course_api.dart';
import 'dart:convert';
import 'settings.dart';
import 'package:seoul_education_service/logins/login/views/login_page.dart';
import 'package:seoul_education_service/notification/controllers/alarm_page.dart';

class MyPage extends StatefulWidget {
  //final bool? islogin;
  const MyPage({Key? key}) : super(key: key);
  @override
  State<MyPage> createState() => _MypageState();
}

class  _MypageState extends State<MyPage>{
  List<Member>? _infolist;
  String? usernickname;

  @override
  void initState(){
    super.initState();
    //ScreenUtil.init(context);
    _loadAccessToken();
    _fetchmember();
  }
  //accesstoken 호출
  Future<String?> _loadAccessToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> _fetchmember() async{
    String? accessToken = await _loadAccessToken();
    var response= await http.get(
      Uri.parse(API_MEMBER_INFO),
      headers:{'Authorization' : 'Bearer $accessToken'},
    );
    if(response.statusCode ==200){
      var jsonResponse = jsonDecode(response.body);
      var info = memberModel.fromJson(jsonResponse);
      setState(() {
        _infolist = info.data != null ? [info.data!] : [];
      });
    }
  }

  @override
  Widget build(BuildContext context)
  {ScreenUtil.init(context, designSize: const Size(390,844));
  return Scaffold(
    body: Column(
      children: [
        appbar(),
        middle(),
        bottom(),
      ],
    ),
  );
  }
  Widget appbar(){
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 56,
      child: Padding(
        padding: EdgeInsets.fromLTRB(350.w, 16.h, 16.w, 16.h),
        child: GestureDetector(
          onTap: (){
            //알림페이지로
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AlarmPage()),
            );
          },
          child: Image.asset("assets/images/Const/Bell.png", width: 24,height: 24,),
        ),
      ),
    );
  }
  Widget middle(){
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      //height: 233,
      child: Column(
        children: [
          Row(
            //환영이랑 프로필
            children: [
              SizedBox(width: 16),
              //환영멘트
              Expanded(
                child: _infolist != null ? Text("${_infolist!.first.nickname} 님,\n오늘도 배움을 응원합니다!",
                  style: TextStyle(
                    fontFamily: 'Spoqa Han Sans Neo',
                    fontSize: 20,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ) :
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: 183.w,
                        height: 28.h,
                        child: Row(
                          children: [
                            Text("로그인 및 회원가입",
                            style: TextStyle(
                              fontFamily: 'Spoqa Han Sans Neo',
                              fontSize: 20,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                            ),),
                            Image.asset("assets/images/Const/CaretRight.png", width: 24,height: 24,),
                          ],
                        ),
                      ),
                    ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.only(right: 16),
                    child: Image.asset("assets/images/Const/profile.png",width: 60,height: 60)),
              ),
            ],
          ),
          SizedBox(height: 40),
          //개인의 강의들
          Container(
            width: 293,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SelectLecture(),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Image.asset("assets/images/Const/scrap.png",width:54,height: 54,),
                        SizedBox(height: 12),
                        Text("찜한강의",style:
                          TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Spoqa Han Sans Neo',
                            fontWeight: FontWeight.w500,
                          ),)
                      ],
                   )),
                SizedBox(width: 60.w,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const writed(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset("assets/images/Const/mywritten.png",width:54,height: 54,),
                      SizedBox(height: 12),
                      Text("내가쓴글",style:
                      TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Spoqa Han Sans Neo',
                        fontWeight: FontWeight.w500,
                      ),)
                    ],
                  ),
                ),
                SizedBox(width: 60.w,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  recentlecture(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset("assets/images/Const/myrecent.png",width:54,height: 54,),
                      SizedBox(height: 12),
                      Text("최근본강의",style:
                      TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Spoqa Han Sans Neo',
                        fontWeight: FontWeight.w500,
                      ),)
                    ],
                  ),
                )

              ],
            ),
          ),
          SizedBox(height: 30,),
          SizedBox(height: 10,
            child: Container(color: lightBackgroundColor,),)
        ],
      ),
    );
  }
  Widget bottom(){
    return Column(
      children: [
        GestureDetector(
          onTap: ()async{
            //기본정보수정으로
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => changeprivate(usernickname: "${_infolist!.first.nickname}", email: "${_infolist!.first.email}"),
              ),
            );
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 56,
            child: Row(
              children: [
                SizedBox(width: 16,),
                Expanded(
                  child: Text("기본정보 수정",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      fontFamily: 'Spoqa Han Sans Neo',
                        fontStyle: FontStyle.normal,

                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(right: 16),
                    child: Image.asset("assets/images/Const/CaretRight.png",width: 24,height: 24,)),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const settings()
              ),
            );
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 56,
            child: Row(
              children: [
                SizedBox(width: 16,),
                Expanded(
                  child: Text("설정",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      fontFamily: 'Spoqa Han Sans Neo',
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(right: 16),
                    child: Image.asset("assets/images/Const/CaretRight.png",width: 24,height: 24,)),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            //공지사항으로

          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 56,
            child: Row(
              children: [
                SizedBox(width: 16,),
                Expanded(
                  child: Text("공지사항",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      fontFamily: 'Spoqa Han Sans Neo',
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(right: 16),
                    child: Image.asset("assets/images/Const/CaretRight.png",width: 24,height: 24,)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

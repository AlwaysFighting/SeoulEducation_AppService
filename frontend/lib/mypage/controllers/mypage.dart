import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'selectlecture.dart';
import 'writed.dart';
import 'recentlecture.dart';
import 'changeprivate.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'package:seoul_education_service/mypage/model/writerModel.dart';
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
  final List<Model> _writtenlist = [];
  String? usernickname;

  @override
  void initState(){
    super.initState();
    //ScreenUtil.init(context);
    _loadAccessToken();
    _fetchcontent();
  }
  //accesstoken 호출
  Future<String?> _loadAccessToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> _fetchcontent() async{
    String? accessToken = await _loadAccessToken();
    var response= await http.get(
      Uri.parse(API_MYPAGE_WRITED),
      headers:{'Authorization' : 'Bearer $accessToken'},
    );
    if(response.statusCode == 200){
      var jsonResponse = jsonDecode(response.body);
      var writer = Writer.fromJson(jsonResponse);
      if(writer.data != null){
        var model = writer.data![0];
        setState(() {
          usernickname = model.userNickname;
        });
      }
      else{
        print('${response.statusCode}');
      }

    }
    else{
      print('${response.statusCode}');
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
      height: 233,
      child: Column(
        children: [
          Row(
            //환영이랑 프로필
            children: [
              SizedBox(width: 16),
              //환영멘트
              Expanded(
                child: usernickname != null ? Text("$usernickname 님,\n오늘도 배움을 응원합니다!",
                  style: TextStyle(
                    fontFamily: 'Spoqa Han Sans Neo',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
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
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Spoqa Han Sans Neo',
                              fontSize: 20.sp,
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
          SizedBox(height: 42),
          //개인의 강의들
          Container(
            width: 293,
            height: 83,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //SizedBox(width: 49),
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
                        SizedBox(height: 12.h,),
                        Text("찜한강의",style:
                          TextStyle(
                            fontSize: 14.sp,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Spoqa Han Sans Neo',
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
                      SizedBox(height: 12.h,),
                      Text("내가쓴글",style:
                      TextStyle(
                        fontSize: 14.sp,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Spoqa Han Sans Neo',
                      ),)
                    ],
                  ),
                ),
                SizedBox(width: 60.w,),
                GestureDetector(
                  onTap: (){
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  recentlecture(),
                      ),
                    );*/
                  },
                  child: Column(
                    children: [
                      Image.asset("assets/images/Const/myrecent.png",width:54,height: 54,),
                      SizedBox(height: 12.h,),
                      Text("최근본강의",style:
                      TextStyle(
                        fontSize: 14.sp,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Spoqa Han Sans Neo',
                      ),)
                    ],
                  ),
                )

              ],
            ),
          ),
          SizedBox(height: 30.h,),
          SizedBox(height: 10.h,
            child: Container(color: lightBackgroundColor,),)
        ],
      ),
    );
  }
  Widget bottom(){
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            //기본정보수정으로
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => changeprivate(usernickname: usernickname ?? '',),
              ),
            );
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 56.h,
            child: Row(
              children: [
                SizedBox(width: 16.w,),
                Expanded(
                  child: Text("기본정보 수정",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      fontFamily: 'Spoqa Han Sans Neo',
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
            height: 56.h,
            child: Row(
              children: [
                SizedBox(width: 16.w,),
                Expanded(
                  child: Text("설정",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      fontFamily: 'Spoqa Han Sans Neo',
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
            height: 56.h,
            child: Row(
              children: [
                SizedBox(width: 16.w,),
                Expanded(
                  child: Text("공지사항",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      fontFamily: 'Spoqa Han Sans Neo',
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

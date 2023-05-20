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

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);
  @override
  State<MyPage> createState() => _MypageState();
}

class  _MypageState extends State<MyPage>{
  List<Model>? _writtenlist = [];
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
      Uri.parse('${API_MYPAGE_WRITED}'),
      headers:{'Authorization' : 'Bearer ${accessToken}'},
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
      height: 56.h,
      child: Padding(
        padding: EdgeInsets.fromLTRB(350.w, 16.h, 16.w, 16.h),
        child: GestureDetector(
          onTap: (){
            //알림페이지로
          },
          child: Image.asset("assets/images/Const/Bell.png", width: 24,height: 24,),
        ),
      ),
    );
  }
  Widget middle(){
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 264.h,
      child: Column(
        children: [
          Row(
            //환영이랑 프로필
            children: [
              SizedBox(width: 16.w,),
              //환영멘트
              Text("${usernickname} 님,\n오늘도 배움을 응원합니다!",
                style: TextStyle(
                  fontFamily: 'Spoqa Han Sans Neo',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
              SizedBox(width: 60.w,),
              Image.asset("assets/images/Const/profile.png",width: 60.w,height: 60.h,),
            ],
          ),
          SizedBox(height: 42.h,),
          //개인의 강의들
          Row(
            children: [
              SizedBox(width: 48.w,),
              GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectLecture(),
                      ),
                    );
                  },
                  child: Image.asset("assets/images/Const/scraplecture.png",width:54.w,height: 83.h,)),
              SizedBox(width: 60.w,),
              GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => writed(),
                      ),
                    );
                  },
                  child: Image.asset("assets/images/Const/writed.png",width:54.w,height: 83.h,)),
              SizedBox(width: 60.w,),
              GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => recentlecture(),
                      ),
                    );
                  },
                  child: Image.asset("assets/images/Const/recentlecture.png",width:54.w,height: 83.h,)),

            ],
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
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 56.h,
            child: Row(
              children: [
                SizedBox(width: 16.w,),
                Text("기본정보 수정",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    fontFamily: 'Spoqa Han Sans Neo',
                  ),
                ),
                SizedBox(width:242.w),
                Image.asset("assets/images/Const/CaretRight.png",width: 24.w,height: 24.h,),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            //설정으로
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 56.h,
            child: Row(
              children: [
                SizedBox(width: 16.w,),
                Text("설정",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    fontFamily: 'Spoqa Han Sans Neo',
                  ),
                ),
                SizedBox(width:304.w),
                Image.asset("assets/images/Const/CaretRight.png",width: 24.w,height: 24.h,),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

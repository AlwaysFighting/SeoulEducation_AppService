import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'package:seoul_education_service/const/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:seoul_education_service/api/course_api.dart';
import 'package:http/http.dart' as http;

class settings extends StatefulWidget{
  const settings({Key? key}) : super(key:key);
  @override
  State<settings> createState() => _settings();
}

class _settings extends State<settings> {
  bool isalarm = true;

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

  Future<void> logout_api() async{
    String? accessToken = await _loadAccessToken();
    final url = Uri.parse(API_LOGOUT);
    final headers = {'Authorization': 'Bearer $accessToken'};
    final response=await http.post(
      url,headers: headers
    );
    if(response.statusCode == 200){
      print("Signed out Successfully");
    }
    else if(response.statusCode == 401){
      print("Token problem");
    }
    else if(response.statusCode == 403){
      print("invalid User");
    }
    else{
      print("Server error");
    }
  }

  @override
  Widget build(BuildContext context){
    ScreenUtil.init(context, designSize: const Size(390, 844));
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 44.h,),
          appbar(),
          SizedBox(height: 20.h,),
          Row(
            children: [
              SizedBox(width: 16.w,),
              Text("버전정보",
              style: TextStyle(
                fontFamily: 'Spoqa Han Sans Neo',
                fontSize: 14.sp,
                color: textColor2
              ),)
            ],
          ),
          SizedBox(height: 16.h,),
          version(),
          SizedBox(height: 16.h,),
          blank(),
          SizedBox(height: 20.h,),
          Row(
            children: [
              SizedBox(width: 16.w,),
              Text(
                "알림",
                style: TextStyle(
                  fontFamily: 'Spoqa Han Sans Neo',
                  fontSize: 14.sp,
                  color: textColor2,
                ),
              )
            ],
          ),
          SizedBox(height: 16.h,),
          pushalarm(),
          SizedBox(height: 20.h,),
          blank(),
          SizedBox(height: 20.h,),
          Row(
            children: [
              SizedBox(width: 16.w,),
              Text(
                "기타설정",
                style: TextStyle(
                  fontFamily: 'Spoqa Han Sans Neo',
                  fontSize: 14.sp,
                  color: textColor2,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h,),
          content(),
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
            onTap: () async{
              //마이페이지로
              await Navigator.push(context, MaterialPageRoute(builder: (context) =>
              const Navigation(initialIndex: 2,)));
            },
            child: Image.asset(
              'assets/images/Const/ArrowLeft.png', width: 24.w, height: 24.w,),
          ),
          SizedBox(width: 140.w,),
          Text("설정",
            style: TextStyle(
              fontFamily: 'Spoqa Han Sans Neo',
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  Widget version(){
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 56.h,
      child: Row(
        children: [
          SizedBox(width: 16.w,),
          Text("현재버전",
          style: TextStyle(
            fontSize: 16.sp,
            fontFamily: 'Spoqa Han Sans Neo',
          ),),
          SizedBox(width: 266.w,),
          Text("1.0.1",
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'Spoqa Han Sans Neo',
              color: textColor2,
            ),),
        ],
      ),
    );
  }

  Widget blank(){
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 10.h,
      child: Container(
        color: backgroundBtnColor,
      ),
    );
  }

  Widget pushalarm() {
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 56.h,
      child: Row(
        children: [
          SizedBox(width: 16.w,),
          Text("푸시알림",
            style: TextStyle(
              fontFamily: 'Spoqa Han Sans Neo',
              fontSize: 16.sp,
            ),
          ),
          SizedBox(width: 235.w,),
          Switch(value: isalarm,
              onChanged: (value){
            setState(() {
              isalarm = value;
            });
              },
          activeColor: mainColor,
          )
        ],
      ),
    );
  }

  Widget content(){
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            logoutDialog();
          },
          child: SizedBox(
            height: 56.h,
            child: Row(
              children: [
                SizedBox(width: 16.w,),
                Text("로그아웃",
                  style: TextStyle(
                    fontFamily: 'Spoqa Han Sans Neo',
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(width: 275.w,),
                Image.asset("assets/images/Const/CaretRight.png",width: 24.w, height: 24.h,),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            //회원탈퇴
          },
          child: SizedBox(
            height: 56.h,
            child: Row(
              children: [
                SizedBox(width: 16.w,),
                Text("탈퇴하기",
                  style: TextStyle(
                    fontFamily: 'Spoqa Han Sans Neo',
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(width: 275.w,),
                Image.asset("assets/images/Const/CaretRight.png",width: 24.w, height: 24.h,),
              ],
            ),
          ),
        )
      ],
    );
  }
  void logoutDialog(){
    showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
            ),
            contentPadding: EdgeInsets.fromLTRB(16.w, 40.h, 16.w, 20.h),
            title: Row(
              children: <Widget>[
                SizedBox(width: 75.w,),
                Text("로그아웃 안내",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: 'Spoqa Han Sans Neo',
                  ),),
                SizedBox(width: 40.w,),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close)
                )
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("로그아웃 하시겠습니까?",
                  style: TextStyle(
                    fontFamily: 'Spoqa Han Sans Neo',
                    fontSize: 16.sp,
                    color: textColor2,
                  ),
                ),
                SizedBox(height: 24.h,),
                Row(
                  children: [
                    SizedBox(
                      width: 130.w,
                      height: 48.h,
                      child: ElevatedButton(onPressed: (){
                        Navigator.pop(context);
                      },
                          child: Text("취소", style: (
                          TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'Spoqa Han Sans Neo',
                            color: Colors.black,
                          )
                          ),),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(backgroundBtnColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)
                            )
                          )
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w,),
                    SizedBox(
                      child: SizedBox(
                        width: 130.w,
                        height: 48.h,
                        child: ElevatedButton(onPressed: () async{
                          await logout_api();
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          const Navigation(initialIndex: 2,)));
                        },
                          child: Text("로그아웃", style: (
                              TextStyle(
                                fontSize: 16.sp,
                                fontFamily: 'Spoqa Han Sans Neo',
                                color: Colors.white,
                              )
                          ),),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(mainColor),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24)
                                  )
                              )
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }
  /*void withdrawDialog(){
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
                    fontSize: 17.sp,
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
                    fontSize: 13.sp,
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
  }*/


}




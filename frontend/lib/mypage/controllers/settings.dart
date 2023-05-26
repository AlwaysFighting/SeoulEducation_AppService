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

  Future<void> secession_api() async{
    String? accessToken = await _loadAccessToken();
    final url = Uri.parse(API_SECESSION);
    final headers = {'Authorization': 'Bearer $accessToken'};
    final response=await http.delete(
        url,headers: headers
    );
    if(response.statusCode == 200){
      print("Account deleted Successfully");
    }
    else if(response.statusCode==500){
      print("Server error");
    }
    else{
      print("${response.statusCode}error code");
    }
  }



  @override
  Widget build(BuildContext context){
    ScreenUtil.init(context, designSize: const Size(390, 844));
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 44,),
          appbar(),
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 16,),
              Text("버전정보",
              style: TextStyle(
                fontFamily: 'Spoqa Han Sans Neo',
                fontSize: 14,
                color: textColor2,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
              ),)
            ],
          ),
          SizedBox(height: 16,),
          version(),
          SizedBox(height: 16,),
          blank(),
          SizedBox(height: 20,),
          Row(
            children: [
              SizedBox(width: 16,),
              Text(
                "알림",
                style: TextStyle(
                  fontFamily: 'Spoqa Han Sans Neo',
                  fontSize: 14,
                  color: textColor2,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
          SizedBox(height: 16,),
          pushalarm(),
          SizedBox(height: 20,),
          blank(),
          SizedBox(height: 20,),
          Row(
            children: [
              SizedBox(width: 16,),
              Text(
                "기타설정",
                style: TextStyle(
                  fontFamily: 'Spoqa Han Sans Neo',
                  fontSize: 14,
                  color: textColor2,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 16,),
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
      height: 56,
      child: Row(
        children: [
          SizedBox(width: 16),
          GestureDetector(
            onTap: () async{
              //마이페이지로
              await Navigator.push(context, MaterialPageRoute(builder: (context) =>
              const Navigation(initialIndex: 2,)));
            },
            child: Image.asset(
              'assets/images/Const/ArrowLeft.png', width: 24, height: 24,),
          ),
          SizedBox(width: 140.w,),
          Text("설정",
            style: TextStyle(
              fontFamily: 'Spoqa Han Sans Neo',
              fontSize: 16,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
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
      height: 56,
      child: Row(
        children: [
          SizedBox(width: 16.w,),
          Text("현재버전",
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Spoqa Han Sans Neo',
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
          ),),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Text("1.0.1",
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Spoqa Han Sans Neo',
                color: textColor2,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
              ),),
          ),
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
      height: 10,
      child: Container(
        color: lightBackgroundColor,
      ),
    );
  }

  Widget pushalarm() {
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 56,
      child: Row(
        children: [
          SizedBox(width: 16,),
          Text("푸시알림",
            style: TextStyle(
              fontFamily: 'Spoqa Han Sans Neo',
              fontSize: 16,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(right:16.0),
            child: Switch(value: isalarm,
                onChanged: (value){
              setState(() {
                isalarm = value;
              });
                },
            activeColor: mainColor,
            ),
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
                SizedBox(width: 16,),
                Text("로그아웃",
                  style: TextStyle(
                    fontFamily: 'Spoqa Han Sans Neo',
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                //SizedBox(width: 275.w,),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(right:16.0),
                  child: Image.asset("assets/images/Const/CaretRight.png",width: 24, height: 24,),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            secssion_dialog();
          },
          child: SizedBox(
            height: 56,
            child: Row(
              children: [
                SizedBox(width: 16,),
                Text("탈퇴하기",
                  style: TextStyle(
                    fontFamily: 'Spoqa Han Sans Neo',
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(right:16.0),
                  child: Image.asset("assets/images/Const/CaretRight.png",width: 24, height: 24,),
                ),
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
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 20),
            title: Row(
              children: <Widget>[
                SizedBox(width: 75.w,),
                Container(
                  padding: EdgeInsets.only(top:24.h),
                  child: Text("로그아웃 안내",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: 'Spoqa Han Sans Neo',
                    ),),
                ),
                SizedBox(width: 40.w,),
                Container(
                  padding: EdgeInsets.only(top: 0),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close)
                  ),
                )
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 16.h),
                  child: Text("로그아웃 하시겠습니까?",
                    style: TextStyle(
                      fontFamily: 'Spoqa Han Sans Neo',
                      fontSize: 16,
                      color: textColor2,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 24),
                      child: SizedBox(
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
                    ),
                    SizedBox(width: 8,),
                    Container(
                      padding: EdgeInsets.only(top: 24),
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
  void secssion_dialog(){
    showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 20),
            title: Row(
              children: <Widget>[
                SizedBox(width: 73.w,),
                Container(
                  padding: EdgeInsets.only(top: 24),
                  child: Text("탈퇴하기 안내",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: 'Spoqa Han Sans Neo',
                    ),),
                ),
                SizedBox(width: 40.w,),
                Container(
                  padding: EdgeInsets.only(top: 0),
                  child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close)
                  ),
                )
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(22, 16, 22, 0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("탈퇴를 하시면 모든 정보가 삭제됩니다\n탈퇴하시겠습니까?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Spoqa Han Sans Neo',
                        fontSize: 16.sp,
                        color: textColor2,
                      ),
                    ),
                  ),
                ),
                //SizedBox(height: 24.h,),
                Container(
                  padding: EdgeInsets.only(top: 24),
                  child: Row(
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
                            await secession_api();
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            const Navigation(initialIndex: 2,)));
                          },
                            child: Text("탈퇴하기", style: (
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
                  ),
                )
              ],
            ),
          );
        });
  }


}




import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'changeprivate.dart';
//비밀번호 입력시 한번에 x 버튼 나오는 문제 해결해야함

class changepassword extends StatefulWidget{
  const changepassword({Key? key}):super(key:key);

  @override
  State<changepassword> createState() => _changepassword();
}
class _changepassword extends State<changepassword> {
  bool _showSuffixicon = false;
  TextEditingController _currentcontroller = TextEditingController();
  TextEditingController _newcontroller = TextEditingController();
  TextEditingController _checkcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    ScreenUtil.init(context);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844));
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 44.h,),
          appbar(),
          SizedBox(height: 20.h,),
          content(),
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
              //알림창
              backDialog();
            },
            child: Image.asset(
              'assets/images/ArrowLeft.png', width: 24.w, height: 24.w,),
          ),
          SizedBox(width: 109.w,),
          Text("기본정보 수정",
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

  Widget content(){
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 16.w,),
            Text("현재 비밀번호",
            style: TextStyle(
              fontFamily: 'Spoqa Han Sans Neo',
              fontSize: 14.sp,
            ),)
          ],
        ),
        SizedBox(height: 10.h,),
        SizedBox(
          width: 358.w,
          height: 48.h,
          child: TextFormField(
            obscureText: true,
            controller: _currentcontroller,
            onChanged: (_currentcontroller){
              setState(() {
                _showSuffixicon = _currentcontroller.isNotEmpty;
              });
            },
            style: TextStyle(
              fontFamily: 'Spoqa Han Sans Neo',
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              suffixIcon: Visibility(
                visible: _showSuffixicon,
                child:GestureDetector(
                    onTap: (){
                      //다지워지기
                    },
                    child:SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: Image.asset("assets/images/XCircle.png"))
                ),
              ),
              border: InputBorder.none,
              hintText: "현재 비밀번호 입력",
              hintStyle: TextStyle(
                fontFamily: 'Spoqa Han Sans Neo',
                fontSize: ScreenUtil().setSp(14),
                color: textColor2,
              ),
              contentPadding: EdgeInsets.fromLTRB(16.w, 16.h, 0, 15.h
              ),
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
        //새로운 비밀번호 입력하는
        SizedBox(height: 40.h,),
        Row(
          children: [
            SizedBox(width: 16.w,),
            Text("새로운 비밀번호",
              style: TextStyle(
                fontFamily: 'Spoqa Han Sans Neo',
                fontSize: 14.sp,
              ),)
          ],
        ),
        SizedBox(height: 10.h,),
        SizedBox(
          width: 358.w,
          height: 48.h,
          child: TextFormField(
            obscureText: true,
            controller: _newcontroller,
            onChanged: (_newcontroller){
              setState(() {
                _showSuffixicon = _newcontroller.isNotEmpty;
              });
            },
            style: TextStyle(
              fontFamily: 'Spoqa Han Sans Neo',
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              suffixIcon: Visibility(
                visible: _showSuffixicon,
                child:GestureDetector(
                    onTap: (){
                      //다지워지기
                    },
                    child:SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: Image.asset("assets/images/XCircle.png"))
                ),
              ),
              border: InputBorder.none,
              hintText: "새로운 비밀번호를 입력해주세요",
              hintStyle: TextStyle(
                fontFamily: 'Spoqa Han Sans Neo',
                fontSize: ScreenUtil().setSp(14),
                color: textColor2,
              ),
              contentPadding: EdgeInsets.fromLTRB(16.w, 16.h, 0, 15.h
              ),
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
        //비밀번호 확인
        SizedBox(height: 40.h,),
        Row(
          children: [
            SizedBox(width: 16.w,),
            Text("새로운 비밀번호 확인",
              style: TextStyle(
                fontFamily: 'Spoqa Han Sans Neo',
                fontSize: 14.sp,
              ),)
          ],
        ),
        SizedBox(height: 10.h,),
        SizedBox(
          width: 358.w,
          height: 48.h,
          child: TextFormField(
            obscureText: true,
            controller: _checkcontroller,
            onChanged: (value){
              setState(() {
                _showSuffixicon = value.isNotEmpty;
              });
            },
            style: TextStyle(
              fontFamily: 'Spoqa Han Sans Neo',
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              suffixIcon: Visibility(
                visible: _showSuffixicon,
                child:GestureDetector(
                    onTap: (){
                      //다지워지기
                    },
                    child:SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: Image.asset("assets/images/XCircle.png"))
                ),
              ),
              border: InputBorder.none,
              hintText: "새로운 비밀번호를 한번 더 입력해주세요",
              hintStyle: TextStyle(
                fontFamily: 'Spoqa Han Sans Neo',
                fontSize: ScreenUtil().setSp(14),
                color: textColor2,
              ),
              contentPadding: EdgeInsets.fromLTRB(16.w, 16.h, 0, 15.h
              ),
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
                        builder: (context) => changeprivate(),
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
  Widget success(){
    return GestureDetector(
      onTap: (){
       ( _currentcontroller.text.isNotEmpty || _newcontroller.text.isNotEmpty || _checkcontroller.text.isNotEmpty) ? Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => changeprivate(),
          ),
        ) : print("이름이 입력되지 않음");
      },
      child: Container(
        height: 80.h,
        color: mainColor,
        child: Center(
          child: Text("확인",
            style: TextStyle(
              fontFamily: 'Spoqa Han Sans Neo',
              fontSize: 16.sp,
              color: Colors.white,
            ),),
        ),
      ),
    );
  }


}
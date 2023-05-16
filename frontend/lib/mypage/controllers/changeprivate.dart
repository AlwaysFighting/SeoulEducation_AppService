import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'changename.dart';
import 'changepassword.dart';

class changeprivate extends StatefulWidget{
  const changeprivate({Key? key}):super(key:key);

  @override
  State<changeprivate> createState() => _privateState();
}
class _privateState extends State<changeprivate> {
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
          SizedBox(height: 60.h,),
          appbar(),
          SizedBox(height: 20.h,),
          user(),
          Container(
            height: 10.h,
            color: lightBackgroundColor,
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
            onTap: () {
              Navigator.pop(context);
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
  Widget user(){
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 179.h,
        child: Column(
        children: [
          Image.asset("assets/images/profile.png",width: 60.w,height: 60.h,),
          SizedBox(height: 16.h,),
          Text("usernickname",
          style: TextStyle(
            fontSize: 16.sp,
            fontFamily: 'Spoqa Han Sans'
          ),
          ),
          SizedBox(height: 4.h,),
          Text("user_email",
            style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Spoqa Han Sans',
                color: textColor2,
            ),
          ),
        ],
    ),
    );
  }
  Widget content(){
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            //이름변경화면으로
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => changename(),
              ),
            );
          },
          child: SizedBox(
            height: 56.h,
            child: Row(
              children: [
                SizedBox(width: 16.w,),
                Text("이름",
                style: TextStyle(
                  fontFamily: 'Spoqa Han Sans Neo',
                  fontSize: 16.sp,
                ),
                ),
                Spacer(),
                Text("usernickname",
                  style: TextStyle(
                    fontFamily: 'Spoqa Han Sans Neo',
                    fontSize: 14.sp,
                    color: textColor2,
                  ),
                ),
                Image.asset("assets/images/CaretRight.png",width: 24.w, height: 24.h,),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            //비밀번호변경화면
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => changepassword(),
              ),
            );
          },
          child: SizedBox(
            height: 56.h,
            child: Row(
              children: [
                SizedBox(width: 16.w,),
                Text("비밀번호",
                  style: TextStyle(
                    fontFamily: 'Spoqa Han Sans Neo',
                    fontSize: 16.sp,
                  ),
                ),
                Spacer(),
                Image.asset("assets/images/CaretRight.png",width: 24.w, height: 24.h,),
              ],
            ),
          ),
        )
      ],
    );
  }

}

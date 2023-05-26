import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'package:seoul_education_service/mypage/controllers/changename.dart';
import 'package:seoul_education_service/mypage/controllers/mypage.dart';
import 'changepassword.dart';
import 'package:seoul_education_service/const/navigation.dart';

class changeprivate extends StatefulWidget{
  final usernickname;
  final email;
  const changeprivate({Key? key, required this.usernickname, this.email}):super(key:key);

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
          SizedBox(height: 20),
          user(),
          Container(
            height: 10,
            color: lightBackgroundColor,
          ),
          SizedBox(height: 16),
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
          SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
              const Navigation(initialIndex: 2,)));
            },
            child: Image.asset(
              'assets/images/Const/ArrowLeft.png', width: 24, height: 24,),
          ),
          SizedBox(width: 109.w,),
          Text("기본정보 수정",
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
  Widget user(){
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 179.h,
        child: Column(
        children: [
          Image.asset("assets/images/Const/profile.png",width: 60,height: 60,),
          SizedBox(height: 16),
          Text("${widget.usernickname}",
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Spoqa Han Sans',
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w400,
          ),
          ),
          SizedBox(height: 4),
          Text("${widget.email}",
            style: TextStyle(
                fontSize: 14,
                fontFamily: 'Spoqa Han Sans',
                color: textColor2,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
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
                builder: (context) => changename(usernickname: widget.usernickname,email:widget.email),
              ),
            );
          },
          child: SizedBox(
            height: 56,
            child: Row(
              children: [
                SizedBox(width: 16,),
                Text("이름",
                style: TextStyle(
                  fontFamily: 'Spoqa Han Sans Neo',
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                ),
                ),
                Spacer(),
                Text('${widget.usernickname}',
                  style: TextStyle(
                    fontFamily: 'Spoqa Han Sans Neo',
                    fontSize: 14,
                    color: textColor2,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Image.asset("assets/images/Const/CaretRight.png",width: 24, height: 24,),
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
                builder: (context) => changepassword(usernickname : widget.usernickname),
              ),
            );
          },
          child: SizedBox(
            height: 56,
            child: Row(
              children: [
                SizedBox(width: 16,),
                Text("비밀번호",
                  style: TextStyle(
                    fontFamily: 'Spoqa Han Sans Neo',
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                Image.asset("assets/images/Const/CaretRight.png",width: 24, height: 24,),
              ],
            ),
          ),
        )
      ],
    );
  }

}

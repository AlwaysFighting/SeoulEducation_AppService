import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class recentlecture extends StatefulWidget{
  const recentlecture({Key? key}):super(key:key);

  @override
  State<recentlecture> createState() => _recentState();
}
class _recentState extends State<recentlecture> {

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
              'assets/images/Const/ArrowLeft.png', width: 24.w, height: 24.w,),
          ),
          SizedBox(width: 125.w,),
          Text("최근본강의",
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
}
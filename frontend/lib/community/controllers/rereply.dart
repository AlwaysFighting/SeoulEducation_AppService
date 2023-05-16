//detailcontent로 부터 commentid 전달받기
//해당 댓글 내용 전부 전달받아야함
import 'package:flutter/material.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class rereply extends StatefulWidget {
  final int commentid;
  const rereply({Key? key, required this.commentid}) : super(key:key);


  @override
  State<rereply> createState() => RereplyState();
}
class RereplyState extends State<rereply> {
  @override
  void initState() {
    ScreenUtil.init(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    ScreenUtil.init(context, designSize: const Size(390, 844));
    return Scaffold(
      body: Column(

      ),
    );
  }
}
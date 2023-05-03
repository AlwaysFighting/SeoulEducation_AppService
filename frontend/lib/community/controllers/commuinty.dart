import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/screen_util.dart';
import 'writing.dart';
import 'searching.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityState();
}

  class _CommunityState extends State<CommunityPage>{
    @override
    Widget build(BuildContext context) {
      ScreenUtil.init(context, designSize: const Size(390,844));
      return Scaffold(
        body: Stack(
        children: [
          Positioned(
            top:ScreenUtil().setHeight(17),
              child: appbar()),
          Positioned(
            bottom: ScreenUtil().setHeight(40),
              right: ScreenUtil().setWidth(16),
              child: button()),
        ],
      ),
      );
    }

    Widget appbar(){
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

              Padding(
                padding: EdgeInsets.only(left:ScreenUtil().setWidth(16)),
                child: Text(
                  '질문게시판',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(18),
                    fontWeight: FontWeight.bold,
                    fontFamily: "Spoqa Han Sans Neo",
                  ),
                ),
              ),
            //padding: EdgeInsets.fromLTRB(ScreenUtil().setHeight(310), ScreenUtil().setHeight(16), ScreenUtil().setHeight(56), ScreenUtil().setHeight(16)),
            SizedBox(width: ScreenUtil().setWidth(211),),
          SizedBox(
            width: ScreenUtil().setWidth(40),
            height:ScreenUtil().setHeight(50),
            child: IconButton(onPressed: (){
              //검색화면으로
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => writingScreen()));
            },
                      icon: Image.asset("assets/images/MagnifyingGlass.png"),
                 iconSize:24,
               ),
          ),
           


            //padding: EdgeInsets.fromLTRB(ScreenUtil().setHeight(350), ScreenUtil().setHeight(16), ScreenUtil().setHeight(16), ScreenUtil().setHeight(16)),
          SizedBox(width: ScreenUtil().setWidth(0),),
          SizedBox(
            width: ScreenUtil().setWidth(40),
            height:ScreenUtil().setHeight(50),
            child: IconButton(onPressed: (){
              //알림화면으로
            },
                      icon: Image.asset("assets/images/Bell.png"),
                  iconSize:24,
                ),
          ),


        ],
      );
  }
  Widget button()
  {
    return FloatingActionButton(
        child:Image.asset('assets/images/writing.png'),
        onPressed: (){
          towritingScreen(context);
        });
  }
  //글쓰기 버튼 누를시 이동
  void towritingScreen(BuildContext context){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => writingScreen()));
  }
  }

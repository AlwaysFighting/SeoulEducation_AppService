import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/screen_util.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'commuinty.dart';

class writingScreen extends StatefulWidget{
  const writingScreen({super.key});

  @override
  State<writingScreen> createState() => _writingState();
}
class _writingState extends State<writingScreen>{
  @override
  Widget build(BuildContext context)
  {
    ScreenUtil.init(context, designSize: const Size(390,844));
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: ScreenUtil().setHeight(35),),
          //앱 상단에 해당하는 것
          Row(
            children: [
              SizedBox(width: ScreenUtil().setWidth(16),),
              GestureDetector(
                onTap:(){
                  xDialog();
                },
                child: Image.asset('assets/images/close.png', width: ScreenUtil().setWidth(24),height: ScreenUtil().setHeight(24),),
              ),
              SizedBox(width: ScreenUtil().setWidth(132),),
              Text('글쓰기',
                style: TextStyle(
                  fontFamily: "Spoqa Han Sans Neo",
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(16)
                ),),
              SizedBox(width: ScreenUtil().setWidth(127),),
              Text('완료',
                style: TextStyle(
                    fontFamily: "Spoqa Han Sans Neo",
                  //추가적으로 글쓰기 완료시 색깔 변하고 버튼 활성화 기능 구현
                    fontSize: ScreenUtil().setSp(16)
                ),),
            ],
          ),
          SizedBox(height: ScreenUtil().setHeight(29),),
          Container(
            width: ScreenUtil().setWidth(358),
              child:TextFormField(
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color:textColor2)
                  ),
                    hintText: '제목을 입력해주세요',
                  hintStyle: TextStyle(
                    color: textColor2,
                    fontSize: 16,
                    fontFamily:"Spoqa Han Sans Neo"
                  )
                ),
              )
          ),
          Container(
              width: ScreenUtil().setWidth(358),
              child:SizedBox(
                height: ScreenUtil().setHeight(608),
                child: TextFormField(
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                      hintText: '강좌에 대해 궁금한 점이나\n평생학습센터에 대해 궁금한 점을 물어보세요.',
                      hintStyle: TextStyle(
                          color: textColor2,
                          fontSize: 14,
                          fontFamily:"Spoqa Han Sans Neo"
                      )
                  ),
                ),
              )
          ),
        ],
      )
    );
  }

  void xDialog(){
    showDialog(context: context,
        //팝업 제외한 다른 화면 터치 안되도록
        barrierDismissible: false,
        builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
            title: Column(
              children: <Widget>[
                Text("취소하기",
                style: TextStyle(
                  fontFamily: "Spoqa Han Sans Neo",
                  fontSize: ScreenUtil().setSp(17),
                ),),

              ],
            ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("이전까지 작성된 내용이 저장되지 않습니다\n그래도 나가시겠습니까?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Spoqa Han Sans Neo",
                  fontSize: ScreenUtil().setSp(13),
                  color: textColor2,
                ),)
            ],
          ),
          actions:
            [
              TextButton(onPressed: (){
                Navigator.pop(context);
              },
                  child: Text("아니오"),
              ),
              TextButton(onPressed: (){
                //게시판 화면으로
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommunityPage()));
              },
                  child: Text("예")),
            ]
        );
        });
  }

}
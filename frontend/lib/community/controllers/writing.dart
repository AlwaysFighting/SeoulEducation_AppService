import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/screen_util.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'package:seoul_education_service/const/navigation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:seoul_education_service/api/course_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class writingScreen extends StatefulWidget{
  final postid;
  const writingScreen({Key? key, this.postid}) : super(key:key);

  @override
  State<writingScreen> createState() => _writingState();
}
class _writingState extends State<writingScreen>{
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  //final navigationState = Navigation.navigationKey.currentState;

  @override
  void initState() {
    //ScreenUtil.init(context);
    super.initState();
    //_loadAccessToken();
  }

  //accesstoken 호출
  Future<String?> _loadAccessToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  @override
  Widget build(BuildContext context)
  {
    ScreenUtil.init(context, designSize: const Size(390,844));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SizedBox(height: ScreenUtil().setHeight(50),),
          //앱 상단에 해당하는 것
          Row(
            children: [
              SizedBox(width: ScreenUtil().setWidth(16),),
              GestureDetector(
                onTap:(){
                  xDialog();
                },
                child: Image.asset('assets/images/community/close.png', width: ScreenUtil().setWidth(24),height: ScreenUtil().setHeight(24),),
              ),
              SizedBox(width: ScreenUtil().setWidth(132),),
              Text('글쓰기',
                style: TextStyle(
                  fontFamily: "Spoqa Han Sans Neo",
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(16)
                ),),
              SizedBox(width: ScreenUtil().setWidth(127),),
              GestureDetector(
                onTap: () async{
                  await _sendPostRequest();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Navigation(),
                    ),
                  );
                },
                child: Text('완료',
                  style: TextStyle(
                      fontFamily: "Spoqa Han Sans Neo",
                    //추가적으로 글쓰기 완료시 색깔 변하고 버튼 활성화 기능 구현
                      fontSize: ScreenUtil().setSp(16)
                  ),),
              ),
            ],
          ),
          SizedBox(height: ScreenUtil().setHeight(29),),
          //제목 입력칸
          SizedBox(
            width: ScreenUtil().setWidth(358),
              child:TextFormField(
                maxLength: 40,
                controller: _titleController,
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
          //내용 입력칸
          SizedBox(
              width: ScreenUtil().setWidth(358),
              child:SizedBox(
                height: ScreenUtil().setHeight(608),
                child: TextFormField(
                  controller: _contentController,
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
                  child: const Text("아니오"),
              ),
              TextButton(onPressed: (){
                //게시판 화면으로
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                const Navigation(initialIndex: 1,),
                ));

                },
                  child: const Text("예")),
            ]
        );
        });
  }
  //글작성 api처리
  Future<void> _sendPostRequest() async{
    String? accessToken = await _loadAccessToken();
      final url = Uri.parse(API_COMMUNITY_WRITING);
      //로그인 부분과 합치면 받아오기
      final headers={'Authorization':'Bearer $accessToken', "Content-Type": "application/json"};
      bool _submitForm(){
        if(_titleController.text.isEmpty || _contentController.text.isEmpty){
          if(_titleController.text.isEmpty)
          {
            print("Title is Empty.");
          }
          if(_contentController.text.isEmpty)
          {
            print("Content is Empty.");
          }
          return false;
        }
        return true;
      }
      if(!_submitForm()){
        return;
      }
      //null value인지 체크하기 위해 호출
      _submitForm();
      final body = jsonEncode(
          {"title": _titleController.text,
            "content": _contentController.text});
      final response = await http.post(url, headers: headers, body: body);
      print('request body:$body');
      if(response.statusCode == 200){

        print("Successfully Saved.");
      }
      else if(response.statusCode == 401){
        print("Token Expired...");
      }
      else if(response.statusCode == 403){
        print("Invalid User.");
      }
      else if(response.statusCode == 400){
        if(_titleController.text.length>40)
        {
          print("Title is too long");
        }
        if(_titleController.text.isEmpty){
          print("Title is empty");
        }
        if(_contentController.text.isEmpty){
          print("Content is empty");
        }
        else{
          print("${response.statusCode}Value required");
        }
      }
      else{
        print("Server Error");
      }

  }
}
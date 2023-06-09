import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seoul_education_service/api/course_api.dart';
import 'package:flutter_screenutil/src/screen_util.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'package:seoul_education_service/const/navigation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'commuinty.dart';

//user id로 권한 부여하기
class editingScreen extends StatefulWidget{
  final postid;
  final title;
  final content;
  const editingScreen({Key? key, required this.postid, this.title, this.content}):super(key:key);

  @override
  State<editingScreen> createState() => _editingState();
}
class _editingState extends State<editingScreen>{
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool cando = false;


  @override
  void initState(){
    super.initState();
    _loadAccessToken();
    _titleController.text = widget.title;
    _contentController.text= widget.content;
  }


  Future<String?> _loadAccessToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> _editPostRequest() async{
    String? accessToken = await _loadAccessToken();
    final url = Uri.parse('$API_COMMUNITY_EDIT/${widget.postid}');
    final headers={'Authorization':'Bearer $accessToken', "Content-Type": "application/json"};
    final body = jsonEncode(
        {"title": _titleController.text,
          "content": _contentController.text});
    final response = await http.patch(url, headers: headers, body: body);
    print('request body:$body');
    if(response.statusCode == 200){
      cando = true;
      print("Successfully Updated.");
    }
    else{
      print("${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context){
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
                        Text('편집하기',
                          style: TextStyle(
                              fontFamily: "Spoqa Han Sans Neo",
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                          ),),
                        Spacer(),
                        GestureDetector(
                          onTap: () async{
                            await _editPostRequest();
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            const Navigation(initialIndex: 1,)));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right:16.0),
                            child: Text('완료',
                              style: TextStyle(
                                  fontFamily: "Spoqa Han Sans Neo",
                                  fontSize: 16,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  color: mainColor,
                              ),),
                          ),
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
                                  fontFamily:"Spoqa Han Sans Neo",
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
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
                                    fontFamily:"Spoqa Han Sans Neo",
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
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

}
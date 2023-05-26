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
                child: Image.asset('assets/images/community/close.png', width: 24,height: 24,),
              ),
              SizedBox(width: 132,),
              Text('글쓰기',
                style: TextStyle(
                  fontFamily: "Spoqa Han Sans Neo",
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(16)
                ),),
              //SizedBox(width: ScreenUtil().setWidth(127),),
              Spacer(),
              GestureDetector(
                onTap: () async{
                  await _sendPostRequest();
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  const Navigation(initialIndex: 1,)));
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: _titleController.text == '' && _contentController.text == '' ?
                  Text('완료',
                    style: TextStyle(
                        fontFamily: "Spoqa Han Sans Neo",
                        fontSize: 16,
                      color: textColor2,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                    ),) :Text('완료',
                    style: TextStyle(
                      fontFamily: "Spoqa Han Sans Neo",
                      fontSize: 16,
                      color: mainColor,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                    ),)
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
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
                    border: InputBorder.none,
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
                  fontSize: 17,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
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
                  fontSize: 13,
                  color: textColor2,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                ),),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 24),
                    child: SizedBox(
                      width: 100,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text("아니오", style: (
                            TextStyle(
                              fontSize: 16,
                              fontFamily: 'Spoqa Han Sans Neo',
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
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
                      width: 100,
                      height: 48,
                      child: ElevatedButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            const Navigation(initialIndex: 1,),
                            ));
                          },
                          child: Text("예", style: (
                              TextStyle(
                                fontSize: 16,
                                fontFamily: 'Spoqa Han Sans Neo',
                                color: Colors.white,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
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
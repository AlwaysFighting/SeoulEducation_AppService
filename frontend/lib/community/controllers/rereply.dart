//detailcontent로 부터 commentid 전달받기
//해당 댓글 내용 전부 전달받아야함
import 'package:flutter/material.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:seoul_education_service/api/course_api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'detailcontent.dart';

class rereply extends StatefulWidget {
  final commentid;
  final content;
  final userNickname;
  final publishDate;
  final postId;
  const rereply({Key? key, required this.commentid, this.content, this.userNickname,this.publishDate,this.postId}) : super(key:key);


  @override
  State<rereply> createState() => RereplyState();
}
class RereplyState extends State<rereply> {
  final TextEditingController _rereplycotroller = TextEditingController();
  @override
  void initState() {
    ScreenUtil.init(context);
    super.initState();
    _loadAccessToken();
    _sendRereply();
  }
  Future<String?> _loadAccessToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> _sendRereply() async{
    String? accessToken = await _loadAccessToken();
    final url = Uri.parse('${API_COMMUNITY_REREPLY}/${widget.commentid}');
    final headers = {'Authorization' : 'Bearer ${accessToken}',"Content-Type" : "application/json"};
    bool _rereplyForm(){
      if(_rereplycotroller.text.isEmpty || _rereplycotroller.text==' '){
        print('작성하지 않았습니다');
        return false;
      }
      return true;
    }
    if(!_rereplyForm()){
      return;
    }
    _rereplyForm();
    final body = jsonEncode(
      {
        "content": "${_rereplycotroller.text}"
      }
    );
    final response = await http.post(
      url, headers: headers, body: body
    );
    if(response.statusCode == 200){
      print("successfully saved");
    }
    else{
      print("${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context){
    ScreenUtil.init(context, designSize: const Size(390, 844));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 44.h,),
              appbar(),
              replycontent(),
            ],
          ),
          Positioned(
              bottom: 10,
              child: replybar()
          ),
        ],
      ),
    );
  }

  Widget appbar(){
    return SizedBox(
      height: 56.h,
      child: Row(
        children: [
          SizedBox(width:166.w ,),
          Text('답글쓰기',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              fontFamily: 'Spoqa Han Sans Neo',
            ),),
          SizedBox(width:125.w),
          GestureDetector(
            onTap:(){
              Navigator.pop(context);
            },
            child: Image.asset('assets/images/community/close.png', width: ScreenUtil().setWidth(24),height: ScreenUtil().setHeight(24),),
          ),
        ],
      ),
    );
  }
  Widget replycontent(){
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 16.w,),
            Text("${widget.userNickname}",
            style: TextStyle(
              fontFamily: 'Spoqa Han Sans Neo',
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),),
            SizedBox(width: 280.w,),
            GestureDetector(
              onTap: (){
                //신고하기 기능
              },
              child: Image.asset('assets/images/community/DotsThreeVerticalgrey.png',width: 24.w, height: 24.h,),
            )
          ],
        ),
        SizedBox(height: 10.h,),
        Row(
          children: [
            SizedBox(width: 16.w,),
            Text('${widget.content}',
            style: TextStyle(
              fontFamily: 'Spoqa Han Sans Neo',
              fontSize: 14.sp,
            ),
            ),
          ],
        ),
        SizedBox(height: 16.h,),
        Row(
          children: [
            SizedBox(width: 16.w,),
            Text('답글쓰기',
            style: TextStyle(
              fontFamily: 'Spoqa Han Sans Neo',
              fontSize: 12.sp,
              color: textColor2,
            ),),
            SizedBox(width: 240.w,),
            Text("${widget.publishDate}".substring(0,"${widget.publishDate}".indexOf('T')),
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(12),
                  fontFamily: 'Spoqa Han Sans Neo',
                  color: textColor2
              ),),
          ],
        )
      ],
    );
  }
  Widget replybar(){
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(bottom:MediaQuery.of(context).viewInsets.bottom,),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setHeight(8), ScreenUtil().setWidth(16), ScreenUtil().setHeight(8)),
              child: SizedBox(
                width: ScreenUtil().setWidth(318),
                height: ScreenUtil().setHeight(45),
                child: TextFormField(
                  controller: _rereplycotroller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "댓글을 입력해주세요.",
                    hintStyle: TextStyle(
                      fontFamily: 'Spoqa Han Sans Neo',
                      fontSize: ScreenUtil().setSp(14),
                      color: textColor2,
                    ),
                    /*contentPadding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setHeight(12), ScreenUtil().setWidth(179), ScreenUtil().setHeight(11)
                              ),*/
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(20)),

                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: backgroundBtnColor,
                  ),
                ),
              ),
            ),

            GestureDetector(
              onTap: () async{
                //댓글작성 api 호출
                await _sendRereply();
                _rereplycotroller.clear();
               //detailcontent로 넘어가야함
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Detailcontent(postid: widget.postId!),
                  ),
                );
              },
              child: Image.asset("assets/images/community/PaperPlaneRight.png", width: 24,height: 24,),
            ),

          ],
        ),
      ),
    );


  }
}
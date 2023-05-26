import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seoul_education_service/community/controllers/editing.dart';
import 'package:seoul_education_service/community/controllers/rereply.dart';
import 'package:seoul_education_service/community/model/detailmodel.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seoul_education_service/api/course_api.dart';
import 'package:seoul_education_service/community/model/replylist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:seoul_education_service/const/navigation.dart';
import 'commuinty.dart';
import 'package:seoul_education_service/mypage/model/memberModel.dart';

import '../../notification/models/alarm.dart';

class Detailcontent extends StatefulWidget {
  final int postid;
  const Detailcontent({Key? key, required this.postid}) : super(key:key);


  @override
  State<Detailcontent> createState() => DetailState();
}
class DetailState extends State<Detailcontent> {
  final TextEditingController _replycotroller = TextEditingController();
  List<Data>? _detaillist;
  replylist? _replylist;
  bool cando = false;
  List<Member>? _infolist;
  CommunityPage communitypage = const CommunityPage();


  @override
  void initState() {
    //ScreenUtil.init(context);
    super.initState();
    _loadAccessToken();
      _fetchDetails();
      _fetchReply();
    _sendReply();
    _fetchmember();
  }
  //accesstoken 호출
  Future<String?> _loadAccessToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> _fetchmember() async{
    String? accessToken = await _loadAccessToken();
    var response= await http.get(
      Uri.parse(API_MEMBER_INFO),
      headers:{'Authorization' : 'Bearer $accessToken'},
    );
    if(response.statusCode ==200){
      var jsonResponse = jsonDecode(response.body);
      var info = memberModel.fromJson(jsonResponse);
      setState(() {
        _infolist = info.data != null ? [info.data!] : [];
      });
    }
  }

  //게시글 조회
  Future<void> _fetchDetails() async {
    String? accessToken = await _loadAccessToken();
    var response = await http.get(
      Uri.parse('$API_DETAIL_COMMUNITY${widget.postid}'),
      //API_DETAIL_COMMUNITY
      headers: {'Authorization':'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      // (response.body);
      var jsonResponse = jsonDecode(response.body);
      var details = DetailResponse.fromJson(jsonResponse);
      setState(() {
        _detaillist = [details.data!];
      });
    }
    else {
      print('${response.statusCode}');
      setState(() {
        _detaillist = [];
      });
    }
    setState(() {
    });
  }

  //게시글 삭제
  Future<void> _deleteData() async{
    String? accessToken = await _loadAccessToken();
    final url = Uri.parse('$API_DELETE_COMMUNITY/${widget.postid}');
    final headers = {'Authorization':'Bearer $accessToken'};
    var response = await http.delete(url, headers: headers);
    if(response.statusCode==401){
      print('Token Required');
    }
    if(response.statusCode == 200){
      print('Successfully Deleted');
      cando=true;
    }
    if(response.statusCode == 403){
      print('Invalid User');
    }
    if(response.statusCode==400){
      print('Invalid PostId');
    }
    if(response.statusCode==500){
      print('Server Error');
    }
  }
  //댓글조회
  Future<void> _fetchReply() async{
    String? accessToken = await _loadAccessToken();
    var response2 = await http.get(
      Uri.parse('$API_REPLY_COMMUNITY/${widget.postid}'),
      headers: {'Authorization' : 'Bearer $accessToken'}
    );
    if(response2.statusCode == 200){
      // print(response2.body);
      var jsonResponse = jsonDecode(response2.body);
      var replies = replylist.fromJson(jsonResponse);
      setState(() {
        _replylist = replies;
      });
    }
    else{
      print("${response2.statusCode}");
      setState(() {
        _replylist = null;
      });
    }
    setState(() {
    });
  }

  //댓글 작성
  Future<void> _sendReply() async{
    String? accessToken = await _loadAccessToken();
    final url = Uri.parse('$API_WRITING_REPLY/${widget.postid}');
    final headers = {'Authorization' : 'Bearer $accessToken', "Content-Type" : "application/json"};
    bool _replysumitForm(){
      if(_replycotroller.text.isEmpty){
        print("content is empty");
        return false;
      }
      if(_replycotroller.text == " "){
        print("content cannot be null");
        return false;
      }
      return true;
    }
    if(!_replysumitForm()){
      return;
    }
    //nullvalue 체크하기 위해 호출
    _replysumitForm();
    final body=jsonEncode({
      "content": _replycotroller.text
    });
    final response = await http.post(url,headers:headers, body:body);

    if(response.statusCode == 200){
      await ConnectSocket().commentAlarm(widget.postid);
      print("Successfully Saved");
    }
    else{
      print("${response.statusCode}");
    }
  }



  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844));
    final postid = widget.postid;
      return Scaffold(
        resizeToAvoidBottomInset: false,
          body:Stack(
            children: [
              Column(
                children:[
                  SizedBox(height: ScreenUtil().setHeight(60)),
                  appbar(),
                  detail(),
                  blank(),
                  Expanded(child: replycontent(),)
                ],
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      replybar(),
                      Container(
                        height: 30,
                        color: Colors.white,
                      )
                    ],
                  )
                  ),

            ]
          )
      );


  }

  Widget appbar(){
    var data = _detaillist?.isNotEmpty == true ? _detaillist![0] : null;
    return Row(
      children: [
        const SizedBox(width: 16,),
           GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Image.asset('assets/images/community/ArrowLeft.png',width: 24,height:24),
          ),
        SizedBox(width: ScreenUtil().setWidth(310),),
        GestureDetector(
          onTap: (){
            //작성자 판별하여 팝업창
          },
          child: GestureDetector(
            onTap: (){
              showModalBottomSheet(context: context,
                  builder: (BuildContext context){
                    return SizedBox(
                      height: 150.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ListTile(
                            title:const Align(
                              alignment : Alignment.center,
                              child: Text("글편집하기",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Spoqa Han Sans Neo",
                                fontWeight: FontWeight.bold,
                              ),),
                            ),
                            onTap: ()async{
                              if(_infolist!.first.nickname == data!.userNickname)
                                {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        editingScreen(postid:widget.postid,
                                          title:data?.title ??'',
                                          content: data?.content ?? '',)),
                                  );
                                }
                              else {
                                print("편집 권한이 없습니다.");
                              }
                            },
                          ),
                          ListTile(
                              title:const Align(
                                alignment:Alignment.center,
                                child: Text("글삭제하기",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Spoqa Han Sans Neo",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),),
                              ),
                            onTap: () async{
                                DeleteDialog();
                            },
                          ),
                        ],
                      ),
                    );
                  });
            },
              child: Image.asset('assets/images/community/DotsThreeVertical.png',width: 24,height:24)),



        )],
    );
  }



  Widget detail(){
    if(_detaillist==null || _detaillist!.isEmpty){
      return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.5),
          child: const Center(child:CircularProgressIndicator()));
    }
    else{
      var data = _detaillist![0];
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data.title!,
            style: TextStyle(
              fontFamily: "Spoqa Han Sans Neo",
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
            ),
            SizedBox(height: 6,),
            Row(
              children: [
                data.userId != null ? Text(
                  data.userNickname!,
                  style: const TextStyle(fontFamily: "Spoqa Han Sans Neo",
                    fontSize: 12,
                    color: textColor2,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ) :Text(
                  '(알 수 없음)',
                  style: const TextStyle(fontFamily: "Spoqa Han Sans Neo",
                    fontSize: 12,
                    color: textColor2,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                const SizedBox(width: 10,),
                Text(data.publishDate!.substring(0,data.publishDate!.indexOf('T')),
                  style: TextStyle(
                    color: textColor2,
                    fontFamily: "Spoqa Han Sans Neo",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              data.content!,
              style: TextStyle(fontFamily: "Spoqa Han Sans Neo",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  '조회 ${data.viewCount!.toString()}',
                  style: TextStyle(fontFamily: "Spoqa Han Sans Neo",
                    fontSize: ScreenUtil().setSp(12),
                    color: textColor2,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                const SizedBox(width: 8),
                Image.asset("assets/images/community/ChatCircleDots.png", width: ScreenUtil().setWidth(14),height: ScreenUtil().setHeight(14),),
                const SizedBox(width: 4),
                Text(data.commentCount!.toString(),
                  style: TextStyle(
                    color: textColor2,
                    fontFamily: "Spoqa Han Sans Neo",
                    fontSize: ScreenUtil().setSp(12),
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                //댓글수 추가해야함
              ],
            )
          ],
        ),
      );
    }
  }
  Widget blank(){
    return Container(
      height: 16.h,
      color: backgroundBtnColor,
    );
  }

  //댓글 보여주기
  Widget replycontent(){
    if(_replylist==null || _replylist!.data == null || _replylist!.data!.isEmpty)
      {
        return Container();
      }
    else{
      return ListView.builder(
        itemCount: _replylist!.data!.length,
        itemBuilder: (BuildContext context, int index){
          var reply = _replylist!.data![index];
          var userNickname = reply.userNickname ?? '(알 수 없음)';
          var content = reply.content ?? '';
          var publishdate=reply.publishDate ?? '';
              return ListTile(
                title: Row(
                  children: [
                    Text(userNickname,
                      style: TextStyle(
                        fontFamily:'Spoqa Han Sans Neo',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    Spacer(),
                    //Image.asset('assets/images/community/DotsThreeVerticalgrey.png',width: 24,height: 24,),
                  Padding(
                  padding: EdgeInsets.only(right:16),
          child: Text(publishdate.substring(0,publishdate.indexOf('T')),
          style: TextStyle(
          fontSize: 12,
          fontFamily: 'Spoqa Han Sans Neo',
          color: textColor2,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          )))
          ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(content,
                      style: TextStyle(
                        fontFamily: 'Spoqa Han Sans Neo',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        GestureDetector(
                            onTap: ()async{
                              //답글쓰기 창으로
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    rereply(commentid:reply.commentId ?? '',
                                      content: reply.content ?? '',
                                    userNickname: reply.userNickname ?? '',
                                    publishDate: reply.publishDate ?? '',
                                    postId: widget.postid,)),
                              );
                            },
                            child: Text("답글쓰기",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Spoqa Han Sans Neo',
                                  color: textColor2,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),)
                        ),
                        Spacer(),
                         Padding(
                            padding: EdgeInsets.only(right:16),
                            child: Image.asset('assets/images/community/DotsThreeVerticalgrey.png',width: 24,height: 24,)
                          ),

                      ],
                    ),
                    SizedBox(height: 20,),
                    Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reply.reply != null ? reply.reply!.length:0,
                        itemBuilder: (BuildContext innerContext, int innerIndex){
                          var rereply = reply.reply != null ? reply.reply![innerIndex]:null;
                          var usernickname = rereply?.userNickname ?? '(알 수 없음)';
                          var content = rereply?.content ?? '';
                          var publishdate = rereply?.publishDate ?? '';
                          return ListTile(
                            title: Row(
                              children: [
                                Image.asset("assets/images/community/ArrowElbowDownRight.png", width: 16,height:16),
                                SizedBox(width: 8),
                                Text(usernickname,
                                  style: const TextStyle(
                                    fontFamily: 'Spoqa Han Sans Neo',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    fontStyle: FontStyle.normal
                                  ),
                                ),
                               Spacer(),
                                /*Expanded(
                                  child: Padding(
                                    padding:EdgeInsets.only(right:16.0,left: 20),
                                    child: Text(publishdate.substring(0,publishdate.indexOf('T')),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Spoqa Han Sans Neo',
                                          color: textColor2,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                      ),),
                                  ),
                                ),*/
                                Expanded(
                                    child: Text(publishdate.substring(0,publishdate.indexOf('T')),
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Spoqa Han Sans Neo',
                                        color: textColor2,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                      ),),

                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10.h,),
                                Row(
                                  children: [
                                    SizedBox(width: 24.w,),
                                    Text(content,
                                      style: TextStyle(
                                        fontFamily: 'Spoqa Han Sans Neo',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    SizedBox(width: 24),
                                    GestureDetector(
                                        onTap: (){
                                          //답글쓰기 창으로
                                        },
                                        child: Text("답글쓰기",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Spoqa Han Sans Neo',
                                              color: textColor2,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                          ),)
                                    ),
                                    SizedBox(width: 170.w,),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
        },
      );
    }
  }

  Widget replybar(){
         return SingleChildScrollView(
           physics: const BouncingScrollPhysics(),
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
                            controller: _replycotroller,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "댓글을 입력해주세요.",
                              contentPadding: EdgeInsets.fromLTRB(16, 12, 0, 11),
                              hintStyle: TextStyle(
                                fontFamily: 'Spoqa Han Sans Neo',
                                fontSize: 14,
                                color: textColor2,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                              ),
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
                          await _sendReply();
                          _replycotroller.clear();
                          _fetchReply();
                        },
                        child: Image.asset("assets/images/community/PaperPlaneRight.png", width: 24,height: 24,),
                      ),

                  ],
                ),
           ),
         );
          
    
  }
  void DeleteDialog(){
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
                Text("삭제하기",
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
                Text("정말로 삭제하시겠습니까?",
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
                          onPressed: ()async{
                            await _deleteData();
                            if(cando){
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              const Navigation(initialIndex: 1,)));
                            }
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
}
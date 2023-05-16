
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seoul_education_service/community/controllers/editing.dart';
import 'package:seoul_education_service/community/models/detailmodel.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seoul_education_service/community/constant.dart';
import 'package:seoul_education_service/community/models/replylist.dart';


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


  @override
  void initState() {
    ScreenUtil.init(context);
    super.initState();
    if(widget.postid != null)
      {
        _fetchDetails();
        _fetchReply();
      }
  }

  //게시글 조회
  Future<void> _fetchDetails() async {
    var response = await http.get(
      Uri.parse('${localhost}/post/${widget.postid}'),
      headers: {'Authorization':'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      print(response.body);
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
    final url = Uri.parse('$localhost/post/${widget.postid}');
    final headers = {'Authorization':'Bearer $accessToken'};
    var response = await http.delete(url, headers: headers);
    if(response.statusCode==401){
      print('Token Required');
    }
    if(response.statusCode == 200){
      print('Successfully Deleted');
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
    var response2 = await http.get(
      Uri.parse('$localhost/comment/${widget.postid!}'),
      headers: {'Authorization' : 'Bearer $accessToken'}
    );
    if(response2.statusCode == 200){
      print(response2.body);
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
    final url = Uri.parse('$localhost/comment/${widget.postid!}');
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
        resizeToAvoidBottomInset: true,
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
                  child: Padding(
                    padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(30)),
                      child: replybar()))
            ]
          )
      );


  }

  Widget appbar(){
    //var data = _detaillist![0];
    var data = _detaillist?.isNotEmpty == true ? _detaillist![0] : null;
    return Row(
      children: [
        const SizedBox(width: 16,),
           GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Image.asset('assets/images/ArrowLeft.png',width: 24,height:24),
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
                    return Column(
                      children: [
                        ListTile(
                          title:const Text("글편집하기",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Spoqa Han Sans Neo",
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),),
                          onTap: (){
                            //여기서 넘어감을 판별할 수 있는 postid를 넘긴다
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                              editingScreen(postid:widget.postid,
                                title:data?.title ??'',
                                content: data?.content ?? '',)),
                            );
                          },
                        ),
                        ListTile(
                            title:const Text("글삭제하기",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Spoqa Han Sans Neo",
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),),
                          onTap: (){
                            _deleteData();
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                            title:const Text("닫기",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Spoqa Han Sans Neo",
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),),
                          onTap: (){
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  });
            },
              child: Image.asset('assets/images/DotsThreeVertical.png',width: 24,height:24)),
        ),


      ],
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
            style: TextStyle(fontFamily: "Spoqa Han Sans Neo",
            fontSize: ScreenUtil().setSp(18),
              fontWeight: FontWeight.bold,
            ),
            ),
            Row(
              children: [
                Text(
                  data.userNickname!,
                  style: const TextStyle(fontFamily: "Spoqa Han Sans Neo",
                    fontSize: 12,
                    color: textColor2,
                  ),
                ),
                const SizedBox(width: 10,),
                Text(data.publishDate!.substring(0,data.publishDate!.indexOf('T')),
                  style: TextStyle(
                    color: textColor2,
                    fontFamily: "Spoqa Han Sans Neo",
                    fontSize: ScreenUtil().setSp(12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              data.content!,
              style: TextStyle(fontFamily: "Spoqa Han Sans Neo",
                fontSize: ScreenUtil().setSp(14),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  '조회 ${data.viewCount!.toString()}',
                  style: TextStyle(fontFamily: "Spoqa Han Sans Neo",
                    fontSize: ScreenUtil().setSp(12),
                    color: textColor2,
                  ),
                ),
                const SizedBox(width: 8),
                Image.asset("assets/images/ChatCircleDots.png", width: ScreenUtil().setWidth(14),height: ScreenUtil().setHeight(14),),
                const SizedBox(width: 4),
                Text(data.commentCount!.toString(),
                  style: TextStyle(
                    color: textColor2,
                    fontFamily: "Spoqa Han Sans Neo",
                    fontSize: ScreenUtil().setSp(12),
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
          var userNickname = reply?.userNickname ?? '';
          var content = reply?.content ?? '';
          var publishdate=reply?.publishDate ?? '';
              return ListTile(
                title: Row(
                  children: [
                    Text(userNickname,
                      style: TextStyle(
                        fontFamily:'Spoqa Han Sans Neo',
                        fontSize: ScreenUtil().setSp(12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 270.w,),
                    Image.asset('assets/images/DotsThreeVerticalgrey.png',width: 24.w,height: 24.h,),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Text(content,
                      style: TextStyle(
                        fontFamily: 'Spoqa Han Sans Neo',
                        fontSize: ScreenUtil().setSp(14),
                      ),),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        GestureDetector(
                            onTap: (){
                              //답글쓰기 창으로
                            },
                            child: Text("답글쓰기",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(12),
                                  fontFamily: 'Spoqa Han Sans Neo',
                                  color: textColor2
                              ),)
                        ),
                        SizedBox(width: 230.w,),
                        Text(publishdate.substring(0,publishdate.indexOf('T')),
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              fontFamily: 'Spoqa Han Sans Neo',
                              color: textColor2
                          ),),

                      ],
                    ),
                    SizedBox(height: 20.h,),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: reply.reply != null ? reply.reply!.length:0,
                      itemBuilder: (BuildContext innerContext, int innerIndex){
                        var rereply = reply.reply != null ? reply.reply![innerIndex]:null;
                        var usernickname = rereply?.userNickname ?? '';
                        var content = rereply?.content ?? '';
                        var publishdate = rereply?.publishDate ?? '';
                        return ListTile(
                          title: Row(
                            children: [
                              Image.asset("assets/images/ArrowElbowDownRight.png", width: 16,height:16),
                              SizedBox(width: 8.w),
                              Text(usernickname,
                                style: TextStyle(
                                  fontFamily: 'Spoqa Han Sans Neo',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 205.w,),
                              Image.asset('assets/images/DotsThreeVerticalgrey.png',width: 24.w,height: 24.h,),
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
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h,),
                              Row(
                                children: [
                                  SizedBox(width: 24.w,),
                                  GestureDetector(
                                      onTap: (){
                                        //답글쓰기 창으로
                                      },
                                      child: Text("답글쓰기",
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(12),
                                            fontFamily: 'Spoqa Han Sans Neo',
                                            color: textColor2
                                        ),)
                                  ),
                                  SizedBox(width: 170.w,),
                                  Text(publishdate.substring(0,publishdate.indexOf('T')),
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(12),
                                        fontFamily: 'Spoqa Han Sans Neo',
                                        color: textColor2
                                    ),),
                                ],
                              )
                            ],
                          ),
                        );
                      },
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
                        onTap: (){
                          //댓글작성 api 호출
                          _sendReply();
                          setState(() {
                            _replycotroller.clear();
                          });
                        },
                        child: Image.asset("assets/images/PaperPlaneRight.png", width: 24,height: 24,),
                      ),

                  ],
                ),
           ),
         );
          
    
  }
}
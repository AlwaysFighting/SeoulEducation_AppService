import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seoul_education_service/community/controllers/editing.dart';
import 'package:seoul_education_service/community/models/detailmodel.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'package:flutter_screenutil/src/screen_util.dart';
import 'package:seoul_education_service/community/constant.dart';


class Detailcontent extends StatefulWidget {
  final int? postid;
  const Detailcontent({Key? key, required this.postid}) : super(key:key);

  @override
  State<Detailcontent> createState() => DetailState();
}
class DetailState extends State<Detailcontent> {
  List<Data>? _detaillist;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  //게시글 조회
  Future<void> _fetchDetails() async {
    var response = await http.get(
      Uri.parse('${localhost}/post/${widget.postid}'),
      headers: {'Authorization':'Bearer ${accessToken}'},
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
      print('${response.statusCode}itswrong');
    }
  }

  //게시글 삭제
  //http://localhost:8080/post/3
  Future<void> _deleteData() async{
    final url = Uri.parse('${localhost}/post/${widget.postid}');
    final headers = {'Authorization':'Bearer ${accessToken}'};
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


  @override
  Widget build(BuildContext context) {
    final postid = widget.postid ?? '';
    return Scaffold(
        body:Column(
          children: [
            SizedBox(height: ScreenUtil().setHeight(60)),
            appbar(),
            detail(),
          ],
        )
    );
  }

  Widget appbar(){
    var data = _detaillist![0];
    return Row(
      children: [
        SizedBox(width: 16,),
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
                          title:Text("글편집하기",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Spoqa Han Sans Neo",
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),),
                          onTap: (){
                            //여기서 넘어감을 판별할 수 있는 postid를 넘긴다
                            //writing.dart에서 처리해야함
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                              editingScreen(postid:widget.postid,title:data.title!,content: data.content!,)),
                            );
                          },
                        ),
                        ListTile(
                            title:Text("글삭제하기",
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
                            title:Text("닫기",
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
      return Center(child:CircularProgressIndicator());
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
                  style: TextStyle(fontFamily: "Spoqa Han Sans Neo",
                    fontSize: 12,
                    color: textColor2,
                  ),
                ),
                SizedBox(width: 10,),
                Text(data.publishDate!.substring(0,data.publishDate!.indexOf('T')),
                  style: TextStyle(
                    color: textColor2,
                    fontFamily: "Spoqa Han Sans Neo",
                    fontSize: ScreenUtil().setSp(12),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              data.content!,
              style: TextStyle(fontFamily: "Spoqa Han Sans Neo",
                fontSize: ScreenUtil().setSp(14),
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
                  ),
                ),
                SizedBox(width: 8),
                Image.asset("assets/images/ChatCircleDots.png", width: ScreenUtil().setWidth(14),height: ScreenUtil().setHeight(14),),
                SizedBox(width: 4),
                //댓글수 추가해야함
              ],
            )
          ],
        ),
      );
    }
  }
}
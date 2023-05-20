import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seoul_education_service/api/course_api.dart';
import 'package:seoul_education_service/mypage/model/writerModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:seoul_education_service/const/colors.dart';
import 'package:seoul_education_service/community/controllers/detailcontent.dart';

class writed extends StatefulWidget{
  const writed({Key? key}):super(key:key);

  @override
  State<writed> createState() => _writedState();
}
class _writedState extends State<writed>{
  List<Model>? _writtenlist = [];


  @override
  void initState(){
    super.initState();
    //ScreenUtil.init(context);
    _loadAccessToken();
    _fetchcontent();
  }

  //accesstoken 호출
  Future<String?> _loadAccessToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> _fetchcontent() async{
    String? accessToken = await _loadAccessToken();
    var response= await http.get(
      Uri.parse('${API_MYPAGE_WRITED}'),
      headers:{'Authorization' : 'Bearer ${accessToken}'},
    );
    if(response.statusCode == 200){
      var jsonResponse = jsonDecode(response.body);
      var lists = Writer.fromJson(jsonResponse);
      setState(() {
        _writtenlist = lists.data;
      });
    }
    else{
      print('${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context)
  {ScreenUtil.init(context, designSize: const Size(390,844));
  return Scaffold(
    body: Column(
      children: [
        SizedBox(height: 60.h,),
        appbar(),
        Expanded(child: content()),
      ],
    ),
  );
  }

  Widget appbar(){
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 56.h,
      child: Row(
        children: [
          SizedBox(width: 16.w,),
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Image.asset('assets/images/Const/ArrowLeft.png',width: 24.w,height: 24.w,),
          ),
          SizedBox(width: 125.w,),
          Text("내가쓴글",
          style: TextStyle(
            fontFamily: 'Spoqa Han Sans Neo',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
          ),
        ],
      ),
    );
  }

  Widget content(){
    if(_writtenlist == null || _writtenlist!.isEmpty){
      return Scaffold(
        body: Center(
          child: Text('아직 작성한 글이 없어요',
          style: TextStyle(
            fontSize: 16.sp,
            fontFamily: 'Spoqa Han Sans Neo',
            color: textColor2,
          ),),
        ),
      );
    }
    else{
      return Container(
        padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
        child: ListView.builder(
            itemCount: _writtenlist!.length,
            itemBuilder: (BuildContext context, int index){
              var list = _writtenlist![index];
              return list.id != null ? GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Detailcontent(postid: list.id!),),
                  );
                },
                child: ListTile(
                  title:Padding(padding: EdgeInsets.only(bottom:10),
                    child: Text(list.title!,
                      style: TextStyle(
                        fontFamily: 'Spoqa Han Sans Neo',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(list.content!,
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: 'Spoqa Han Sans Neo',
                          fontSize: 14.sp,
                        ),),
                      SizedBox(height: 24.h,),
                      Row(
                        children: [
                          Text(list.userNickname!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'Spoqa Han Sans Neo',
                            color: textColor2,
                          ),),
                          SizedBox(width: 10.w,),
                          Text(list.publishDate!.substring(0,list.publishDate!.indexOf('T')),
                          style: TextStyle(
                            color: textColor2,
                            fontFamily: 'Spoqa Han Sans Neo',
                            fontSize: 12.sp
                          ),
                          ),
                          SizedBox(width: 160.w,),
                          Image.asset("assets/images/Const/ChatCircleDots.png", width: 14.w, height: 14.h,),
                          Text(list.commentCount!.toString(),
                          style: TextStyle(
                              color: textColor2,
                              fontFamily: 'Spoqa Han Sans Neo',
                              fontSize: 12.sp
                          ),
                          ),
                          SizedBox(height: 24.h,),
                        ],
                      ),
                      SizedBox(height: 24.h,),
                      SizedBox(
                        height: 1.h,
                        child: Container(
                          color: backgroundColor,
                        ),
                      )
                    ],
                  ),
                ),
              ): Container();
            }),
      );
    }
  }

}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'writing.dart';
import 'searching.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seoul_education_service/community/model/postlist.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'detailcontent.dart';
import 'package:seoul_education_service/api/course_api.dart';
import 'package:seoul_education_service/notification/controllers/alarm_page.dart';


class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key:key);

  @override
  State<CommunityPage> createState() => _CommunityState();
}

class _CommunityState extends State<CommunityPage>{
  List<Data>? _posts = [];
  @override
  void initState(){
    super.initState();
    _fetchPosts();
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390,844));
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: ScreenUtil().setHeight(17),
              child:appbar()),
          Padding(padding: EdgeInsets.only(top:ScreenUtil().setHeight(120)),
            child: content(),),
          Positioned(
              bottom: ScreenUtil().setHeight(40),
              right: ScreenUtil().setWidth(16),
              child: button()),
        ],
      ),
    );
  }

  Widget appbar(){
    return SizedBox(
      height: 56.h,
      child: Row(
        children: [
            SizedBox(width: 16.w,),
            Text(
              '질문게시판',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(18),
                fontWeight: FontWeight.bold,
                fontFamily: "Spoqa Han Sans Neo",
              ),
            ),

          //padding: EdgeInsets.fromLTRB(ScreenUtil().setHeight(310), ScreenUtil().setHeight(16), ScreenUtil().setHeight(56), ScreenUtil().setHeight(16)),
          //SizedBox(width: ScreenUtil().setWidth(211),),
          Padding(
            padding: EdgeInsets.fromLTRB(211.w, 16.h, 16.w, 16.h),
            child: GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Searching()));
              },
              child:Image.asset("assets/images/Const/MagnifyingGlass.png",width: 24.w,height: 24.h,)
            ),
          ),

          //SizedBox(width: 16.w),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 16.h, 16.w, 16.h),
            child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AlarmPage()),
                  );
                },
                child: Image.asset("assets/images/Const/Bell.png",width: 24.w,height: 24.h,)),
          ),
        ],
      ),
    );
  }
  Widget button()
  {
    return FloatingActionButton(
        child:Image.asset('assets/images/Const/writing.png'),
        onPressed: (){
          towritingScreen(context);
        });
  }
  //글쓰기 버튼 누를시 이동
  void towritingScreen(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const writingScreen()));
  }

  Future<void> _fetchPosts() async{
    var response = await http.get(Uri.parse(API_COMMUNITY));
    if(response.statusCode == 200){
      var jsonResponse = jsonDecode(response.body);
      var posts = postlist.fromJson(jsonResponse);
        setState((){
          _posts=posts.data;
        });
    }else{
      print('${response.statusCode}');
    }
  }

  Widget content(){
    if(_posts == null || _posts!.isEmpty){
      return Scaffold(
        body: Center(
          child:Text("아직 작성된 글이 없어요!",
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: 'Spoqa Han Sans Neo',
              color: textColor2,
            ),
          )
        ),
      );
    }
    else{
      //게시글이 있다면
      return Container(
        //padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setHeight(24), ScreenUtil().setWidth(16), ScreenUtil().setHeight(24)),
        child: ListView.builder(
            itemCount: _posts!.length,
            itemBuilder: (BuildContext context, int index){
              var post=_posts![index];
              return post.postId != null ? GestureDetector(
                onTap:(){
                  print("${post.postId}");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Detailcontent(postid:post.postId!)),
                  );
                },
                child: ListTile(
                  //제목
                  title:Padding(
                    padding: const EdgeInsets.only(bottom:10),
                    //padding: const EdgeInsets.all(8.0),
                    child: Text(post.title!,
                      style: TextStyle(
                        fontFamily: "Spoqa Han Sans Neo",
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(16),
                      ),),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //내용
                      Text(post.content!,
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: "Spoqa Han Sans Neo",
                          fontSize: ScreenUtil().setSp(14),
                        ),),
                      const SizedBox(height: 24,),
                      Row(
                        children: [
                          Text(post.userNickname!,
                            style: TextStyle(
                              color: textColor2,
                              fontFamily: "Spoqa Han Sans Neo",
                              fontSize: ScreenUtil().setSp(12),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(post.publishDate!.substring(0,post.publishDate!.indexOf('T')),
                            style: TextStyle(
                              color: textColor2,
                              fontFamily: "Spoqa Han Sans Neo",
                              fontSize: ScreenUtil().setSp(12),
                            ),
                          ),
                          SizedBox(width: 182.w),
                          Image.asset("assets/images/Const/ChatCircleDots.png", width: 14.w,height: 14.h,),
                          SizedBox(width: 4.w),
                          Text(post.commentCount!.toString(),
                            style: TextStyle(
                              color: textColor2,
                              fontFamily: "Spoqa Han Sans Neo",
                              fontSize: ScreenUtil().setSp(12),
                            ),
                          ),
                          const SizedBox(height: 24,),

                        ],
                      ),
                      SizedBox(height:ScreenUtil().setHeight(24)),
                      SizedBox(
                        height: 1.h,
                        child: Container(
                          color: backgroundBtnColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ) : Container();
            }),
      );

    }
  }
}

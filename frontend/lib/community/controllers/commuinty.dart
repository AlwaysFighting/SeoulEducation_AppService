import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'writing.dart';
import 'searching.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seoul_education_service/community/models/postlist.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'detailcontent.dart';
import 'package:seoul_education_service/community/constant.dart';
import 'package:seoul_education_service/community/apis/apiservice.dart';

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
          Padding(padding: EdgeInsets.only(top:ScreenUtil().setHeight(76)),
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
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
              Padding(
                padding: EdgeInsets.only(left:ScreenUtil().setWidth(16)),
                child: Text(
                  '질문게시판',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(18),
                    fontWeight: FontWeight.bold,
                    fontFamily: "Spoqa Han Sans Neo",
                  ),
                ),
              ),
            //padding: EdgeInsets.fromLTRB(ScreenUtil().setHeight(310), ScreenUtil().setHeight(16), ScreenUtil().setHeight(56), ScreenUtil().setHeight(16)),
            SizedBox(width: ScreenUtil().setWidth(211),),
          SizedBox(
            width: ScreenUtil().setWidth(40),
            height:ScreenUtil().setHeight(50),
            child: IconButton(onPressed: (){
              //검색화면으로
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Searching()));
            },
                      icon: Image.asset("assets/images/MagnifyingGlass.png"),
                 iconSize:24,
               ),
          ),

            //padding: EdgeInsets.fromLTRB(ScreenUtil().setHeight(350), ScreenUtil().setHeight(16), ScreenUtil().setHeight(16), ScreenUtil().setHeight(16)),
          SizedBox(width: ScreenUtil().setWidth(0),),
          SizedBox(
            width: ScreenUtil().setWidth(40),
            height:ScreenUtil().setHeight(50),
            child: IconButton(onPressed: (){
              //알림화면으로
            },
                      icon: Image.asset("assets/images/Bell.png"),
                  iconSize:24,
                ),
          ),
        ],
      );
  }
  Widget button()
  {
    return FloatingActionButton(
        child:Image.asset('assets/images/writing.png'),
        onPressed: (){
          towritingScreen(context);
        });
  }
  //글쓰기 버튼 누를시 이동
  void towritingScreen(BuildContext context){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const writingScreen()));
  }

  /*Future<void> _fetchPosts() async{
    var response = await http.get(Uri.parse('$localhost/post'));
    if(response.statusCode == 200){
      var jsonResponse = jsonDecode(response.body);
      var posts = postlist.fromJson(jsonResponse);
        setState((){
          _posts=posts.data;
        });
    }else{
      print('${response.statusCode}');
    }
  }*/
  Future<void> _fetchPosts() async{
    var posts = await ApiService.fetchPosts();
    setState(() {
      _posts=posts;
    });
  }

  Widget content(){
      if(_posts == null || _posts!.isEmpty){
        return const Center(child: CircularProgressIndicator());
      }
      else{
        //게시글이 있다면
        return Container(
          padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setHeight(24), ScreenUtil().setWidth(16), ScreenUtil().setHeight(24)),
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
                              SizedBox(width: 150.w),
                              Image.asset("assets/images/ChatCircleDots.png", width: ScreenUtil().setWidth(14),height: ScreenUtil().setHeight(14),),
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
                        ],
                      ),
                    ),
                  ) : Container();
                }),
        );

      }
  }
  }

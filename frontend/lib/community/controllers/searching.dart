 import 'package:flutter/material.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'package:http/http.dart' as http;
import 'package:seoul_education_service/api/course_api.dart';
import 'dart:convert';
import 'detailcontent.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seoul_education_service/community/model/postlist.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Searching extends StatefulWidget{
  const Searching({Key? key}) : super(key:key);
  @override
  State<Searching> createState() => SearchingState();
}
class SearchingState extends State<Searching> {
  List<Data>? _results = [];
  final TextEditingController _searchingController = TextEditingController();

  @override
  void initState() {
    //ScreenUtil.init(context);
    super.initState();
    _loadAccessToken();
  }

  //accesstoken 호출
  Future<String?> _loadAccessToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> _fetchResult() async{
    String? accessToken = await _loadAccessToken();
    var response= await http.get(
        Uri.parse("$API_COMMUNITY_SEARCH${_searchingController.text}"),
        headers:{'Authorization':'Bearer $accessToken'},
    );
    if(response.statusCode == 200){
      var jsonResponse=jsonDecode(response.body);
      var results =  postlist.fromJson(jsonResponse);
      setState(() {
        _results = results.data;
      });
    }
    else if(response.statusCode == 400){
      print("check query");
    }
    else{
      print("${response.statusCode}Server error");
    }
  }

  @override
  Widget build(BuildContext context)
  {ScreenUtil.init(context, designSize: const Size(390,844));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SizedBox(height: 30.h,),
          searchingbar(),
          Result(),
        ],
      ),
    );
  }

  Widget searchingbar(){
    return Row(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
          child: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child:Image.asset("assets/images/community/ArrowLeft.png",width: 24,height: 24,)
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16),
          child: SizedBox(
            width: 318.w,
            height: 40,
            child: TextFormField(
              controller: _searchingController,
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: GestureDetector(
                  onTap: (){
                    _fetchResult();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left:16),
                    child: Image.asset("assets/images/Const/MagnifyingGlass2.png",width: 20,height: 20,)
                  ),
                ),
                hintText: '찾고자 하는 키워드를 검색해주세요',
                contentPadding: EdgeInsets.fromLTRB(8, 11.5, 0, 11.5),
                hintStyle: TextStyle(
                  color: textColor2,
                  fontFamily: "Spoqa Han Sans Neo",
                  fontSize: 14,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                filled: true,
                fillColor: backgroundBtnColor,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget Result(){
    //없는 검색어를 입력했을때
    if(_searchingController.text.isNotEmpty && (_results == null || _results!.isEmpty)){
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.44,),
            Text("검색 결과가 없습니다!",
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: "Spoqa Han Sans Neo",
                color: textColor2,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
              ),)
          ],
        ),
      );
    }
    //검색어 자체를 입력하지 않았을때
    else if(_searchingController.text.isEmpty){
      return Column(
        children: const [
          Text(""),
        ],
      );
    }
    else{
      return Expanded(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: ListView.builder(
            itemCount: _results!.length,
            itemBuilder: (BuildContext context, int index) {
              var result = _results![index];
              return GestureDetector(
                onTap: () {
                  if (result.postId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Detailcontent(postid: result.postId!),
                      ),
                    );
                  } else {
                    const CircularProgressIndicator();
                  }
                },
                child: ListTile(
                  title: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      result.title!,
                      style: TextStyle(
                        fontFamily: "Spoqa Han Sans Neo",
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.content!,
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: "Spoqa Han Sans Neo",
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: [
                          Text(
                            result.userNickname!,
                            style: TextStyle(
                              color: textColor2,
                              fontFamily: "Spoqa Han Sans Neo",
                              fontSize: 12,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            result.publishDate!.substring(
                                0, result.publishDate!.indexOf('T')),
                            style: TextStyle(
                              color: textColor2,
                              fontFamily: "Spoqa Han Sans Neo",
                              fontSize: 12,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Spacer(),
                          Image.asset(
                            "assets/images/community/ChatCircleDots.png",
                            width: 14,
                            height: 14,
                          ),
                          Text(
                            result.commentCount!.toString(),
                            style: TextStyle(
                              color: textColor2,
                              fontFamily: "Spoqa Han Sans Neo",
                              fontSize: 12,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        height: 1,
                        color: backgroundColor,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );



    }
  }

}

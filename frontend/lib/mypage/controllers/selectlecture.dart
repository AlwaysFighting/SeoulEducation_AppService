import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:seoul_education_service/mypage/model/lectureModel.dart';
import 'package:http/http.dart' as http;
import 'package:seoul_education_service/api/course_api.dart';
import 'dart:convert';
import 'package:seoul_education_service/home/offline/controllers/offline_detail_page.dart';
import 'package:seoul_education_service/home/online/controllers/online_detail_page.dart';

class SelectLecture extends StatefulWidget{
  const SelectLecture({Key? key}) : super(key: key);

  @override
  State<SelectLecture> createState() => _SelectState();
}

class _SelectState extends State<SelectLecture>{
  List<Liked>? _online = [];
  List<Liked>? _offline = [];
  String? courseid;

  @override
  void initState(){
    super.initState();
    //ScreenUtil.init(context);
    _loadAccessToken();
    _fetchLecture_on();
    _fetchLecture_off();
  }


  Future<String?> _loadAccessToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }
  Future<void> _fetchLecture_on() async{
    String? accessToken = await _loadAccessToken();
    final url = Uri.parse('${API_MYPAGE_LIKED}on');
    final headers = {'Authorization' : 'Bearer $accessToken'};
    final response = await http.get(url, headers:headers);
    if(response.statusCode == 200){
      var jsonResponse = json.decode(response.body);
      var online_liked = lectureModel.fromJson(jsonResponse);
      setState(() {
        _online = online_liked.data;
      });

    }
    else if(response.statusCode == 401){
      print("token problem");
    }
    else if(response.statusCode == 403){
      print("invalid user");
    }
    else if(response.statusCode == 400){
      print("invalid type");
    }
    else{
      print("Server error");
    }
  }

  Future<void> _cancelLiked(courseid) async{
    String? accessToken = await _loadAccessToken();
    final url = Uri.parse('${API_MYPAGE_CANCELLIKED}${courseid}');
    final headers = {'Authorization' : 'Bearer $accessToken'};
    final response = await http.post(
      url,headers: headers
    );
    if(response.statusCode == 200){
      print("Successfully Updated");
    }
    else
      {
        print("${response.statusCode}");
      }
  }

  Future<void> _fetchLecture_off() async{
    String? accessToken = await _loadAccessToken();
    final url = Uri.parse('${API_MYPAGE_LIKED}off');
    final headers = {'Authorization' : 'Bearer $accessToken'};
    final response = await http.get(url, headers:headers);
    if(response.statusCode == 200){
      var jsonResponse = jsonDecode(response.body);
      var offline_liked = lectureModel.fromJson(jsonResponse);
      setState(() {
        _offline = offline_liked.data;
      });

    }
    else if(response.statusCode == 401){
      print("token problem");
    }
    else if(response.statusCode == 403){
      print("invalid user");
    }
    else if(response.statusCode == 400){
      print("invalid type");
    }
    else{
      print("Server error");
    }
  }


  @override
  Widget build(BuildContext context){
    ScreenUtil.init(context, designSize: const Size(390,844));
    return Scaffold(
        body: Column(
          children: [
            SizedBox(height: 63.h,),
            appbar(),
            SizedBox(height: 18.h,),
            Expanded(child: tabview())
          ],
        )
    );
  }

  Widget appbar(){
    return Row(
      children: [
        SizedBox(width: 16),
        GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Image.asset("assets/images/Const/ArrowLeft.png",width: 24,height: 24,),
        ),
        SizedBox(width: 125.w,),
        Text("찜한 강의",
          style: TextStyle(
            fontFamily: 'Spoqa Han Sans Neo',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal
          ),
        )
      ],
    );
  }

  Widget tabview(){
    return DefaultTabController(
        length:2 ,
        child: Scaffold(
          body: Column(
            children: [
              TabBar(
                indicatorColor: mainColor,
                labelStyle: TextStyle(
                  fontFamily: 'Spoqa Han Sans Neo',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
                labelColor: Colors.black,
                indicatorWeight: 3,
                tabs: [
                  Tab(
                    text: '온라인',
                  ),
                  Tab(
                    text: '오프라인',
                  )
                ],
              ),
              Expanded(
                  child: TabBarView(
                    children: [
                      _online==null ? Center(
                        child: Text("아직 관심 있는 강의가 없어요!",
                        style: TextStyle(
                          fontFamily: 'Spoqa Han Sans Neo',
                          fontSize: 16,
                          color: textColor2,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                        ),),
                      ) :
                          ListView.builder(
                            key: const PageStorageKey("ONLINE"),
                            itemCount: _online!.length,
                            itemBuilder: (BuildContext context, int index){
                              var online = _online![index];
                              return GestureDetector(
                                onTap: () async{
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => OnlineDetailPage(
                                          courseID:
                                          online.courseId as int
                                      ),
                                    ),
                                  );
                                },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                     Padding(
                                       padding: EdgeInsets.all(16.0),
                                       child: Container(
                                         decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(10),
                                           color: backgroundBtnColor,
                                         ),
                                           padding: EdgeInsets.all(16),
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Row(
                                                 children: [
                                                   Text("#신청가능",
                                                       style: TextStyle(
                                                         fontSize: 14,
                                                         fontFamily: 'Spoqa Han Sans Neo',
                                                         color: mainColor,
                                                         fontWeight: FontWeight.w400,
                                                         fontStyle: FontStyle.normal,
                                                       )),
                                                   online.isFree != null && online.isFree == true ?
                                                       Text("#무료",style: TextStyle(
                                                         fontSize: 14,
                                                         fontFamily: 'Spoqa Han Sans Neo',
                                                         color: mainColor,
                                                         fontWeight: FontWeight.w500,
                                                         fontStyle: FontStyle.normal,
                                                       )
                                                       ) : Text("#유료",style: TextStyle(
                                                     fontSize: 14,
                                                     fontFamily: 'Spoqa Han Sans Neo',
                                                     color: mainColor,
                                                     fontWeight: FontWeight.w500,
                                                     fontStyle: FontStyle.normal,
                                                   )
                                                   ),
                                                   Spacer(),
                                                    GestureDetector(
                                                       onTap: ()async{
                                                         await _cancelLiked(online.courseId);
                                                         _fetchLecture_on();
                                                       },
                                                       child: Image.asset("assets/images/Const/star_fill.png",width: 24,height: 24,),
                                                     ),

                                                 ],
                                               ),
                                               SizedBox(height: 8,),
                                               Text("${online.title}",
                                                 style: TextStyle(
                                                   fontFamily: 'Spoqa Han Sans Neo',
                                                   fontSize: 16,
                                                   fontStyle: FontStyle.normal,
                                                   fontWeight: FontWeight.w500,
                                                 ),),
                                               SizedBox(height: 14,),
                                               Text("신청기간:${online.applyStartDate}~${online.applyEndDate}",
                                                 style: TextStyle(
                                                   fontFamily: 'Spoqa Han Sans Neo',
                                                   fontSize: 14,
                                                   color: textColor2,
                                                   fontStyle: FontStyle.normal,
                                                   fontWeight: FontWeight.w400,
                                                 ),
                                               )
                                             ],
                                           ),
                                       ),
                                     )
                                    ],
                                  ),
                              

                              );
                              }),
                      _offline==null ? Center(
                        child: Text("아직 관심 있는 강의가 없어요!",
                          style: TextStyle(
                            fontFamily: 'Spoqa Han Sans Neo',
                            fontSize: 16,
                            color: textColor2,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                          ),),
                      ) :
                      ListView.builder(
                          key: const PageStorageKey("OFFLINE"),
                          itemCount: _offline!.length,
                          itemBuilder: (BuildContext context, int index){
                            var offline = _offline![index];
                            return GestureDetector(
                              onTap: () async{
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => OfflineDetailPage(
                                        courseID:
                                        offline.courseId as int
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: backgroundBtnColor,
                                      ),
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text("#신청가능  #무료",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Spoqa Han Sans Neo',
                                                    color: mainColor,
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w400,
                                                  )),
                                              Spacer(),
                                              GestureDetector(
                                                onTap: ()async{
                                                  await _cancelLiked(offline.courseId);
                                                  _fetchLecture_off();
                                                },
                                                child: Image.asset("assets/images/Const/star_fill.png",width: 24,height: 24,),
                                              ),

                                            ],
                                          ),
                                          SizedBox(height: 8,),
                                          Text("${offline.title}",
                                            style: TextStyle(
                                              fontFamily: 'Spoqa Han Sans Neo',
                                              fontSize: 16,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w500,
                                            ),),
                                          SizedBox(height: 14,),
                                          Text("신청기간:${offline.applyStartDate}~${offline.applyEndDate}",
                                            style: TextStyle(
                                              fontFamily: 'Spoqa Han Sans Neo',
                                              fontSize: 14,
                                              color: textColor2,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),


                            );
                          })
                    ],
                  ))
            ],
          ),
        ));
  }



}
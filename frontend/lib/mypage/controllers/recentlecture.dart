import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'package:seoul_education_service/home/online/controllers/online_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:seoul_education_service/api/course_api.dart';
import 'package:http/http.dart' as http;

class recentlecture extends StatefulWidget{
  const recentlecture({Key? key}):super(key:key);

  @override
  State<recentlecture> createState() => _recentState();
}
class _recentState extends State<recentlecture> {
  List<Map<String,dynamic>> lectureList=[];
  List<Map<String, dynamic>> offlectureList = [];
  List<Map<String, dynamic>> combinedList = [];


  @override
  void initState() {
    super.initState();
    DataFrommSharedPreferences();
    offDataFrommSharedPreferences();
  }

  Future<void> postStarCourses(int courseID, bool result) async {

    String endPointUrl = CoursesAPI().starCourses(courseID);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    final response = await http.post(
      Uri.parse(endPointUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(<String, bool>{
        'result': result,
      }),
    );

    if (response.statusCode == 200) {
      print("Success");
    } else {
      print(response.body);
    }
  }

  Future<void> DataFrommSharedPreferences() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? lectureListJson = prefs.getStringList('lectureList');
    if(lectureListJson != null){
      setState(() {
        lectureList = lectureListJson
            .map((jsonString) => json.decode(jsonString))
            .toList()
            .cast<Map<String,dynamic>>();
        combinedList.addAll(lectureList);
      });
    }
  }

  Future<void> offDataFrommSharedPreferences() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? offlectureListJson = prefs.getStringList('offlectureList');
    if(offlectureListJson != null){
      setState(() {
        offlectureList = offlectureListJson
            .map((jsonString) => json.decode(jsonString))
            .toList()
            .cast<Map<String,dynamic>>();
        combinedList.addAll(offlectureList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844));
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 60.h,),
          appbar(),
          Column(
            children: [
              //SizedBox(height: 10,),
              Row(
                children: [
                  SizedBox(width: 16,),
                  lectureList.length <=10 ? Text('총 ${lectureList.length}개',
                  style: TextStyle(
                    fontFamily: 'Spoqa Han Sans Neo',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),):Text('총 10개',
                    style: TextStyle(
                      fontFamily: 'Spoqa Han Sans Neo',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),)


                ],
              )
            ],
          ),
          Expanded(child: content()),
        ],
      ),
    );
  }

  Widget appbar() {
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 56.h,
      child: Row(
        children: [
          SizedBox(width: 16.w,),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset('assets/images/Const/ArrowLeft.png', width: 24.w, height: 24.w,),
          ),
          SizedBox(width: 125.w,),
          Text("최근본강의",
            style: TextStyle(
              fontFamily: 'Spoqa Han Sans Neo',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }

Widget content(){
      DateTime today = DateTime.now();
            if(combinedList.isEmpty){
              return Container(
                child: Center(
                  child: Text("아직 본 강의가 없어요!",
                  style: TextStyle(
                    fontFamily: 'Spoqaa Han Sans Neo',
                    fontSize: 16.sp,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    color: textColor2,
                  ),)
                ),
              );
            }
            else{
              return Scaffold(
                body: ListView.builder(
                    itemCount: combinedList.length>=10 ? 10 : combinedList.length,
                    itemBuilder: (BuildContext context, int index){
                      return GestureDetector(
                        onTap: () async{
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => OnlineDetailPage(
                                  courseID:
                                  lectureList[index]['courseID'] as int,
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
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                            )),
                                        SizedBox(width: 10,),
                                        combinedList[index]['isFree'] != null && combinedList[index]['isFree'] == true ?
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
                                        IconButton(
                                          onPressed: () {
                                            bool? isLiked = combinedList[index]['isLiked'];
                                            postStarCourses(combinedList[index]['courseID'] as int, !isLiked!);
                                            setState(() {
                                              if (combinedList[index] != null) {
                                                combinedList[index]['isLiked'] = !(combinedList[index]['isLiked'] ?? false);
                                              }
                                            });
                                          },
                                          icon: combinedList[index]['isLiked'] == false
                                              ? Image.asset(
                                            'assets/images/Const/star_stroke.png',
                                            width: 22,
                                            height: 22,
                                          )
                                              : Image.asset(
                                            'assets/images/Const/star_fill.png',
                                            width: 22,
                                            height: 22,
                                          ),
                                        )
                                      ],
                                    ),
                                    //SizedBox(height: 8,),
                                    Text("${combinedList[index]['title']}",
                                      style: TextStyle(
                                        fontFamily: 'Spoqa Han Sans Neo',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                      ),),
                                    SizedBox(height: 14,),
                                    Text("신청기간:${combinedList[index]['applyStartDate']}~${combinedList[index]['applyEndDate']}",
                                      style: TextStyle(
                                        fontFamily: 'Spoqa Han Sans Neo',
                                        fontSize: 14,
                                        color: textColor2,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
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

              );
            }





    }

}
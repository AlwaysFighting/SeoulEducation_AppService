import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seoul_education_service/const/back_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/course_api.dart';
import '../../../const/colors.dart';

import 'package:http/http.dart' as http;
import '../models/course_list_model.dart';
import 'offline_detail_page.dart';
import 'offline_search_page.dart';

class OfflinePage extends StatefulWidget {
  const OfflinePage({Key? key}) : super(key: key);

  @override
  State<OfflinePage> createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage> {
  //최근본 강의구현 추가코드
  final List<Map<String, dynamic>> offlectureList = [];

  final String imageURL = "assets/images/";

  final titleStyle = const TextStyle(
    color: textColor1,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    fontFamily: "Spoqa Han Sans Neo",
  );

  final subTitleStyle = const TextStyle(
    color: mainColor,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: "Spoqa Han Sans Neo",
  );

  final tagListStyle = const TextStyle(
    color: textColor2,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: "Spoqa Han Sans Neo",
  );

  late Future<CourseList> services;
  String whatOrder = "최신순";
  String whatFilter = "모두";

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

  Future<CourseList> fetchData(String order, String filter) async {
      String endPointUrl = CoursesAPI().coursesFilterList("오프라인", order, filter);
    final Uri url = Uri.parse(endPointUrl);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    final response = await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return CourseList.fromJson(json.decode(response.body));
    } else {
      print(response.body);
      throw Exception("Failed to load Services..");
    }
  }

  bool _isLoading = false;

  Future<void> _handleSearch() async {
    setState(() {
      _isLoading = true;
    });

    _resetState();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _resetState();
  }

  void _resetState() {
    fetchData(whatOrder, whatFilter);
    services = fetchData(whatOrder, whatFilter);
  }

  @override
  Widget build(BuildContext context) {

    DateTime today = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: textColor1,
        elevation: 0,
        leading: const CustomBackButton(),
        title: Text(
          "오프라인강좌",
          style: subTitleStyle.copyWith(
            fontSize: 16.0,
            color: textColor1,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Image.asset(
                '$imageURL/Const/MagnifyingGlass.png',
                width: 24,
                height: 24,
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return const OfflineSearchPage(
                    searchKeyword: '',
                  );
                }));
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder<CourseList>(
        future: services,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("snapshot : $snapshot");
            return Text("${snapshot.error}");
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  mainColor,
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
            child: Scrollbar(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10.0),
                                      ),
                                    ),
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                        height: 240,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              ListTile(
                                                onTap: () {
                                                  setState(() {
                                                    whatOrder = "최신순";
                                                    _handleSearch();
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                leading: Text(
                                                  "최신순",
                                                  style: tagListStyle.copyWith(
                                                    color: whatOrder == "최신순" ? mainColor : null,
                                                  ),
                                                ),
                                                trailing: whatOrder == "최신순"
                                                    ? const Icon(Icons.check_rounded)
                                                    : null,
                                              ),
                                              ListTile(
                                                onTap: () {
                                                  setState(() {
                                                    whatOrder = "관심설정순";
                                                    _handleSearch();
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                leading: Text(
                                                  "관심설정순",
                                                  style: tagListStyle.copyWith(
                                                    color: whatOrder == "관심설정순" ? mainColor : null,
                                                  ),
                                                ),
                                                trailing: whatOrder == "관심설정순"
                                                    ? const Icon(Icons.check_rounded)
                                                    : null,
                                              ),
                                              ListTile(
                                                onTap: () {
                                                  setState(() {
                                                    whatOrder = "마감임박순";
                                                    _handleSearch();
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                leading: Text(
                                                  "마감임박순",
                                                  style: tagListStyle.copyWith(
                                                    color: whatOrder == "마감임박순" ? mainColor : null,
                                                  ),
                                                ),
                                                trailing: whatOrder == "마감임박순"
                                                    ? const Icon(Icons.check_rounded)
                                                    : null,
                                              ),
                                              ListTile(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                title: Center(
                                                  child: Text(
                                                    "닫기",
                                                    style: TextStyle(
                                                      color: whatOrder == "닫기" ? textColor2 : null,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                });
                              },
                              child: Container(
                                height: 37.0,
                                decoration: BoxDecoration(
                                  color: backgroundBtnColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: lineColor,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          whatOrder,
                                          style: subTitleStyle.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: textColor1,
                                          ),
                                        ),
                                        const SizedBox(width: 2.0),
                                        Image.asset(
                                            "assets/images/Courses/CaretDown.png",
                                            width: 20,
                                            height: 20)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10.0),
                                      ),
                                    ),
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                        height: 288,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              ListTile(
                                                onTap: () {
                                                  setState(() {
                                                    whatFilter = "모두";
                                                    _handleSearch();
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                leading: Text(
                                                  "모두",
                                                  style: tagListStyle.copyWith(
                                                    color: whatFilter == "모두" ? mainColor : null,
                                                  ),
                                                ),
                                                trailing: whatFilter == "모두"
                                                    ? const Icon(Icons.check_rounded)
                                                    : null,
                                              ),
                                              ListTile(
                                                onTap: () {
                                                  setState(() {
                                                    whatFilter = "신청예정";
                                                    _handleSearch();
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                leading: Text(
                                                  "신청예정",
                                                  style: tagListStyle.copyWith(
                                                    color: whatFilter == "신청예정" ? mainColor : null,
                                                  ),
                                                ),
                                                trailing: whatFilter == "신청예정"
                                                    ? const Icon(Icons.check_rounded)
                                                    : null,
                                              ),
                                              ListTile(
                                                onTap: () {
                                                  setState(() {
                                                    whatFilter = "신청중";
                                                    _handleSearch();
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                leading: Text(
                                                  "신청중",
                                                  style: tagListStyle.copyWith(
                                                    color: whatFilter == "신청중" ? mainColor : null,
                                                  ),
                                                ),
                                                trailing: whatFilter == "신청중"
                                                    ? const Icon(Icons.check_rounded)
                                                    : null,
                                              ),
                                              ListTile(
                                                onTap: () {
                                                  setState(() {
                                                    whatFilter = "신청마감";
                                                    _handleSearch();
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                leading: Text(
                                                  "신청마감",
                                                  style: tagListStyle.copyWith(
                                                    color: whatFilter == "신청마감" ? mainColor : null,
                                                  ),
                                                ),
                                                trailing: whatFilter == "신청마감"
                                                    ? const Icon(Icons.check_rounded)
                                                    : null,
                                              ),
                                              ListTile(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                title: Center(
                                                  child: Text(
                                                    "닫기",
                                                    style: TextStyle(
                                                      color: whatOrder == "닫기" ? textColor2 : null,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                });
                              },
                              child: Container(
                                height: 37.0,
                                decoration: BoxDecoration(
                                  color: backgroundBtnColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: lineColor,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          whatFilter,
                                          style: subTitleStyle.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: textColor1,
                                          ),
                                        ),
                                        const SizedBox(width: 2.0),
                                        Image.asset(
                                            "assets/images/Courses/CaretDown.png",
                                            width: 20,
                                            height: 20)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10.0),
                                      ),
                                    ),
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                        height: 120,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              ListTile(
                                                leading: Text(
                                                  "시험대비",
                                                  style: tagListStyle.copyWith(
                                                    color: mainColor
                                                  ),
                                                ),
                                                trailing: const Icon(Icons.check_rounded)
                                              ),
                                              ListTile(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                title: Center(
                                                  child: Text(
                                                    "닫기",
                                                    style: TextStyle(
                                                      color: whatOrder == "닫기" ? textColor2 : null,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                });
                              },
                              child: Container(
                                height: 37.0,
                                decoration: BoxDecoration(
                                  color: backgroundBtnColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: lineColor,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "시험대비",
                                          style: subTitleStyle.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: textColor1,
                                          ),
                                        ),
                                        const SizedBox(width: 2.0),
                                        Image.asset(
                                            "assets/images/Courses/CaretDown.png",
                                            width: 20,
                                            height: 20)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      ListView.builder(
                        shrinkWrap: true,
                        cacheExtent: 20,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data?.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: GestureDetector(
                              onTap: () async{
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => OfflineDetailPage(
                                      courseID:
                                          snapshot.data?.data[index].id as int,
                                    ),
                                  ),
                                );

                                //최근본 강좌 구현위해 추가 코드
                                Map<String, dynamic> offlectureInfo = {
                                  'courseID' : snapshot.data?.data[index].id as int,
                                  'title' : snapshot.data?.data[index].title as String,
                                  'isLiked' : snapshot.data?.data[index].isLiked,
                                  'applyStartDate' : snapshot.data?.data[index].applyStartDate,
                                  'applyEndDate' : snapshot.data?.data[index].applyEndDate,
                                  'isFree' : snapshot.data?.data[index].isFree,
                                };
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                List<String> offlectureListJson = prefs.getStringList('lectureList') ?? [];
                                offlectureListJson.add(json.encode(offlectureInfo));
                                await prefs.setStringList('lectureList', offlectureListJson);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: lightBackgroundColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, bottom: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              DateTime.parse(snapshot
                                                  .data
                                                  ?.data[index]
                                                  .applyStartDate
                                              as String)
                                                  .isBefore(
                                                  today) &&
                                                  DateTime.parse(snapshot
                                                      .data
                                                      ?.data[index]
                                                      .applyEndDate
                                                  as String)
                                                      .isAfter(today)
                                                  ? "#신청가능"
                                                  : "#신청불가능",
                                              style: subTitleStyle,
                                            ),
                                            const SizedBox(width: 10),
                                            Text("#시험대비",
                                                style: subTitleStyle),
                                          ],
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              bool? isLiked = snapshot.data?.data[index].isLiked;
                                              if (snapshot.data != null) {
                                                setState(() {
                                                  snapshot.data!.data[index].isLiked = !(snapshot.data!.data[index].isLiked ?? false);
                                                });
                                              }
                                              postStarCourses(snapshot.data?.data[index].id as int, !isLiked!);
                                            });
                                          },
                                          icon: snapshot.data?.data[index].isLiked == false
                                              ? Image.asset(
                                            '$imageURL/Const/star_stroke.png',
                                            width: 22,
                                            height: 22,
                                          )
                                              : Image.asset(
                                            '$imageURL/Const/star_fill.png',
                                            width: 22,
                                            height: 22,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 302,
                                      child: Text(
                                        '${snapshot.data?.data[index].title}',
                                        style: subTitleStyle.copyWith(
                                            color: textColor1, fontSize: 16.0),
                                        softWrap: true,
                                      ),
                                    ),
                                    const SizedBox(height: 14.0),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "신청기간: ${snapshot.data?.data[index].applyStartDate}~${snapshot.data?.data[index].applyEndDate}",
                                          style: subTitleStyle.copyWith(
                                            color: textColor2,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(right: 16.0),
                                          child: Text(
                                              "정원 ${snapshot.data?.data[index].capacity}명",
                                              style: subTitleStyle),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      )
    );
  }
}
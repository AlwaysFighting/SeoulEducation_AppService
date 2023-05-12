import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'package:seoul_education_service/home/online/controllers/online_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../const/api.dart';
import '../../../notification/models/category_button.dart';
import '../../offline/models/course_list_model.dart';

class OnlinePage extends StatefulWidget {
  const OnlinePage({Key? key}) : super(key: key);

  @override
  State<OnlinePage> createState() => _OnlinePageState();
}

class _OnlinePageState extends State<OnlinePage> {

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

  late Future<CourseList> services;

  Future<CourseList> fetchData() async {
    String endPointUrl = CoursesAPI().coursesList("on", "new");
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

  @override
  void initState() {
    super.initState();
    fetchData();
    services = fetchData();
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
        title: Text(
          "온라인강좌",
          style: subTitleStyle.copyWith(
            fontSize: 16.0,
            color: textColor1,
          ),
        ),
        leading: IconButton(
          icon: Image.asset(
            '$imageURL/Const/ArrowLeft.png',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                print("Search");
              },
              child: Image.asset(
                'assets/images/Const/MagnifyingGlass.png',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      ),
      body: _body(services: services, today: today, subTitleStyle: subTitleStyle),
    );
  }
}

class _body extends StatelessWidget {
  const _body({
    super.key,
    required this.services,
    required this.today,
    required this.subTitleStyle,
  });

  final Future<CourseList> services;
  final DateTime today;
  final TextStyle subTitleStyle;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CourseList>(
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
        // 데이터가 있을 때 출력할 위젯
        return Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    children: [
                      NewestCategoryButton(
                        isSelected: false,
                        onPressed: () {
                          print("최신순");
                        },
                        title: '최신순',
                      ),
                      const SizedBox(width: 16.0),
                      NewestCategoryButton(
                        isSelected: false,
                        onPressed: () {
                          print("모집예정");
                        },
                        title: '모집예정',
                      ),
                      const SizedBox(width: 16.0),
                      NewestCategoryButton(
                        isSelected: false,
                        onPressed: () {
                          print("시험대비");
                        },
                        title: '시험대비',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  ListView.builder(
                    shrinkWrap: true,
                    cacheExtent: 10,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data?.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => OnlineDetailPage(
                                courseID:
                                snapshot.data?.data[index].id as int,
                                title: "${snapshot.data?.data[index].title}",
                              ),
                            ),
                          );
                          print(index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: lightBackgroundColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, bottom: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            DateTime.parse(snapshot.data?.data[index].applyStartDate as String).isBefore(today) && DateTime.parse(snapshot.data?.data[index].applyEndDate as String).isAfter(today) ? "#신청가능" : "#신청불가능",
                                            style: subTitleStyle,
                                          ),
                                          const SizedBox(width: 10),
                                          Text( snapshot.data?.data[index].isFree == true ? "#무료" : "#유료" , style: subTitleStyle),
                                          const SizedBox(width: 10),
                                          Text("#직업상담사", style: subTitleStyle),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                        },
                                        icon: Image.asset(
                                          'assets/images/Const/star_stroke.png',
                                          width: 20,
                                          height: 20,
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
                                  Text(
                                    "신청기간: ${snapshot.data?.data[index].applyStartDate}~${snapshot.data?.data[index].applyEndDate}",
                                    style: subTitleStyle.copyWith(
                                      color: textColor2,
                                      fontWeight: FontWeight.w500,
                                    ),
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
    );
  }
}

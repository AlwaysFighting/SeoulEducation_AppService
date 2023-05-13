import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seoul_education_service/home/homepage/models/search_bar.dart';
import 'package:seoul_education_service/home/offline/controllers/offline_page.dart';
import 'package:seoul_education_service/home/online/controllers/online_page.dart';
import 'package:seoul_education_service/home/recommend/controllers/recommend_page.dart';
import 'package:seoul_education_service/notification/controllers/alarm_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../const/api.dart';
import '../../../const/colors.dart';
import '../../offline/models/course_list_model.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Future<CourseList> onlineServices;
  late Future<CourseList> offlineServices;

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

  Future<CourseList> fetchOnlineData() async {
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

  Future<CourseList> fetchOfflineData() async {
    String endPointUrl = CoursesAPI().coursesList("off", "new");
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
    fetchOnlineData();
    onlineServices = fetchOnlineData();
    fetchOfflineData();
    offlineServices = fetchOfflineData();
  }

  @override
  Widget build(BuildContext context) {

    DateTime today = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: _appBar(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "당신의 끝없는\n배움을 응원합니다!",
                style: titleStyle.copyWith(height: 1.7),
              ),
              const SizedBox(height: 20),
              const SearchTextFieldExample(),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  courses_widget(
                    titleStyle: titleStyle,
                    index: 0,
                    image: 'assets/images/Home/onlineIcon.png',
                    title: '온라인강좌',
                  ),
                  courses_widget(
                    titleStyle: titleStyle,
                    index: 1,
                    image: 'assets/images/Home/offlineIcon.png',
                    title: '오프라인강좌',
                  ),
                  courses_widget(
                    titleStyle: titleStyle,
                    index: 2,
                    image: 'assets/images/Home/recommendIcon.png',
                    title: '추천강좌',
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Text("온라인 새로운 강좌", style: titleStyle.copyWith(fontSize: 18.0)),
              const SizedBox(height: 20),
              _onlineBody(services: onlineServices, today: today, subTitleStyle: subTitleStyle),
              Text("오프라인 새로운 강좌", style: titleStyle.copyWith(fontSize: 18.0)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// 온라인 강좌 정보
class _onlineBody extends StatelessWidget {
  const _onlineBody({
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
        return Scrollbar(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ListView.builder(
              shrinkWrap: true,
              cacheExtent: 10,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
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
                                  print(
                                      "${snapshot.data?.data.length}");
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
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _courseListView extends StatelessWidget {
  const _courseListView({
    super.key,
    required this.subTitleStyle,
  });

  final TextStyle subTitleStyle;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: lightBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("#신청가능", style: subTitleStyle),
                          const SizedBox(width: 10),
                          Text("#직업상담사", style: subTitleStyle),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          print("찜 완료!");
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
                      '2023 직업상담사(아이엠에듀) - 필기 - 직업심리학 ',
                      style: subTitleStyle.copyWith(
                          color: textColor1, fontSize: 16.0),
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(height: 14.0),
                  Text(
                    "신청기간: 2023.03.04~2023.12.31",
                    style: subTitleStyle.copyWith(
                        color: textColor2, fontWeight: FontWeight.w500),
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

class courses_widget extends StatelessWidget {
  courses_widget({
    super.key,
    required this.titleStyle,
    required this.index,
    required this.image,
    required this.title,
  });

  final List<Widget> _pageOptions = <Widget>[
    const OnlinePage(),
    const OfflinePage(),
    const RecommendPage(),
  ];

  final TextStyle titleStyle;
  final int index;
  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return _pageOptions[index];
        }));
      },
      child: Column(
        children: [
          Image.asset(
            image,
            width: 98,
            height: 98,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: titleStyle.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}

class _appBar extends StatelessWidget {
  const _appBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: textColor1,
      ),
      title: const Text("LOGO"),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AlarmPage()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/images/Const/Bell.png',
              width: 24,
              height: 24,
            ),
          ),
        ),
      ],
    );
  }
}

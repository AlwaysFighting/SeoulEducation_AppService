import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../const/api.dart';
import '../../../const/back_button.dart';
import '../../../const/colors.dart';

import 'package:http/http.dart' as http;

import '../../offline/models/course_search_model.dart';
import 'online_detail_page.dart';

class OnlineSearchPage extends StatefulWidget {
  const OnlineSearchPage({Key? key}) : super(key: key);

  @override
  State<OnlineSearchPage> createState() => _OnlineSearchPageState();
}

class _OnlineSearchPageState extends State<OnlineSearchPage> {

  final TextEditingController _searchController = TextEditingController();
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

  late Future<SearchCourse?> services;

  Future<SearchCourse?> fetchData(String text) async {
    String endPointUrl = CoursesAPI().searchCourses("on", text);
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
      return SearchCourse?.fromJson(json.decode(response.body));
    } else {
      print(response.body);
      throw Exception("Failed to load Services..");
    }
  }

  bool _isLoading = false;

  void _handleSearch() async {
    setState(() {
      _isLoading = true;
    });

    // API 호출 및 검색 결과 업데이트
    await fetchData(_searchController.text);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OnlineSearchPage()),
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData("라호");
    services = fetchData("라호");
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
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: '찾고자 하는 키워드를 검색해주세요',
            border: InputBorder.none,
          ),
        ),
        leading: const CustomBackButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                _handleSearch();
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
      body: _isLoading ? const Center(child: CircularProgressIndicator()) :
      Body(services: services, today: today, subTitleStyle: subTitleStyle),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    super.key,
    required this.services,
    required this.today,
    required this.subTitleStyle,
  });

  final Future<SearchCourse?> services;
  final DateTime today;
  final TextStyle subTitleStyle;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SearchCourse?>(
      future: services,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        }
        if (!snapshot.hasData || snapshot.data == null ||
            snapshot.data!.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data!.data!.isEmpty) {
          return const Center(
            child: Text('No data'),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    cacheExtent: 10,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data?.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  OnlineDetailPage(
                                    courseID:
                                    snapshot.data?.data?[index].id as int,
                                    title: "${snapshot.data?.data?[index]
                                        .title}",
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
                                            DateTime.parse(
                                                snapshot.data?.data?[index]
                                                    .applyStartDate as String)
                                                .isBefore(today) &&
                                                DateTime.parse(
                                                    snapshot.data?.data?[index]
                                                        .applyEndDate as String)
                                                    .isAfter(today)
                                                ? "#신청가능"
                                                : "#신청불가능",
                                            style: subTitleStyle,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(snapshot.data?.data?[index]
                                              .isFree == true ? "#무료" : "#유료",
                                              style: subTitleStyle),
                                          const SizedBox(width: 10),
                                          Text("#직업상담사", style: subTitleStyle),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {},
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
                                      '${snapshot.data?.data?[index].title}',
                                      style: subTitleStyle.copyWith(
                                          color: textColor1, fontSize: 16.0),
                                      softWrap: true,
                                    ),
                                  ),
                                  const SizedBox(height: 14.0),
                                  Text(
                                    "신청기간: ${snapshot.data?.data?[index]
                                        .applyStartDate}~${snapshot.data
                                        ?.data?[index].applyEndDate}",
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
      }
    );
  }
}
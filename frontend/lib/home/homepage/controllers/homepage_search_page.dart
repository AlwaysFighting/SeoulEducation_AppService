import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seoul_education_service/home/online/controllers/online_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/course_api.dart';
import '../../../const/back_button.dart';
import '../../../const/colors.dart';

import 'package:http/http.dart' as http;

import '../../offline/controllers/offline_detail_page.dart';
import '../../offline/models/course_search_model.dart';

class EntireSearchPage extends StatefulWidget {
  final String searchKeyword;

  const EntireSearchPage({Key? key, required this.searchKeyword})
      : super(key: key);

  @override
  State<EntireSearchPage> createState() => _EntireSearchPageState();
}

class _EntireSearchPageState extends State<EntireSearchPage> {
  final String imageURL = "assets/images/";

  String _searchKeyword = '';

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
    String endPointUrl = CoursesAPI().searchCourses("all", text);
    final Uri url = Uri.parse(endPointUrl);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    final response = await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    try {
      if (response.statusCode == 200) {
        final searchCourse = SearchCourse.fromJson(json.decode(response.body));
        return searchCourse;
      } else if (response.statusCode == 400) {
        return null;
      } else {
        throw Exception("Failed to load Services..");
      }
    } catch (e) {
      return null;
    }
  }

  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchKeyword = widget.searchKeyword;
    _resetState();
  }

  void _resetState() {
    fetchData(_searchKeyword);
    services = fetchData(_searchKeyword);
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
        title: Text("검색결과 '${widget.searchKeyword}'"),
        leading: const CustomBackButton(),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Body(
              services: services, today: today, subTitleStyle: subTitleStyle),
    );
  }
}

class Body extends StatefulWidget {
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
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
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
    } else {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SearchCourse?>(
        future: widget.services,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Container();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.data == null || snapshot.data!.data!.isEmpty) {
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
                            snapshot.data?.data?[index].type ==
                                "off" ? Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => OfflineDetailPage(
                                  courseID:
                                  snapshot.data?.data?[index].id as int,
                                  title:
                                  "${snapshot.data?.data?[index].title}",
                                ),
                              ),
                            ) : Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => OnlineDetailPage(
                                  courseID:
                                  snapshot.data?.data?[index].id as int,
                                  title:
                                  "${snapshot.data?.data?[index].title}",
                                ),
                              ),
                            );
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
                                              DateTime.parse(snapshot
                                                                  .data
                                                                  ?.data?[index]
                                                                  .applyStartDate
                                                              as String)
                                                          .isBefore(
                                                              widget.today) &&
                                                      DateTime.parse(snapshot
                                                                  .data
                                                                  ?.data?[index]
                                                                  .applyEndDate
                                                              as String)
                                                          .isAfter(widget.today)
                                                  ? "#신청가능"
                                                  : "#신청불가능",
                                              style: widget.subTitleStyle,
                                            ),
                                            const SizedBox(width: 10),
                                            snapshot.data?.data?[index]
                                                        .isFree !=
                                                    null
                                                ? Text(
                                                    snapshot.data?.data?[index]
                                                                .isFree ==
                                                            true
                                                        ? "#무료"
                                                        : "#유료",
                                                    style: widget.subTitleStyle)
                                                : Container(),
                                            const SizedBox(width: 10),
                                            Text("#직업상담사",
                                                style: widget.subTitleStyle),
                                          ],
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            bool? isLiked = snapshot
                                                .data?.data?[index].isLiked;
                                            postStarCourses(
                                                snapshot.data?.data?[index]
                                                        .id ??
                                                    0,
                                                !isLiked!);
                                            setState(() {
                                              if (snapshot.data != null) {
                                                snapshot.data!.data?[index]
                                                    .isLiked = !(snapshot.data!
                                                        .data?[index].isLiked ??
                                                    false);
                                              }
                                            });
                                          },
                                          icon: snapshot.data?.data?[index]
                                                      .isLiked ==
                                                  false
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
                                    SizedBox(
                                      width: 302,
                                      child: Text(
                                        '${snapshot.data?.data?[index].title}',
                                        style: widget.subTitleStyle.copyWith(
                                            color: textColor1, fontSize: 16.0),
                                        softWrap: true,
                                      ),
                                    ),
                                    const SizedBox(height: 14.0),
                                    Text(
                                      "신청기간: ${snapshot.data?.data?[index].applyStartDate}~${snapshot.data?.data?[index].applyEndDate}",
                                      style: widget.subTitleStyle.copyWith(
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
        });
  }
}

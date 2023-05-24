import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:seoul_education_service/const/back_button.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'package:seoul_education_service/home/online/controllers/online_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/course_api.dart';
import '../models/category_button.dart';
import '../../offline/models/course_list_model.dart';
import 'online_search_page.dart';

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

  String whatOrder = "최신순";
  String whatFilter = "모두";

  String _selectedItem = '최신순';
  String _selected2Item = '모두';
  String _selected3Item = '시험대비';

  final List<String> _dropdown1Items = ['최신순', '관심설정순', "마감임박순"];
  final List<String> _dropdown2Items = ['모두', '신청예정', '신청중', '신청마감'];
  final List<String> _dropdown3Items = ['시험대비'];

  Future<CourseList> fetchData(String order, String filter) async {
    String endPointUrl =
    CoursesAPI().coursesFilterList("온라인", order, filter);
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
        title: Text(
          "온라인강좌",
          style: subTitleStyle.copyWith(
            fontSize: 16.0,
            color: textColor1,
          ),
        ),
        leading: const CustomBackButton(),
        flexibleSpace: const Padding(
          padding: EdgeInsets.only(left: 16, top: 125),
          child: Tagged(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const OnlineSearchPage(
                        searchKeyword: '',
                      );
                    },
                  ),
                );
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
      body:
      FutureBuilder<CourseList>(
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            height: 37,
                            width: 130,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(18.5)),
                              color: backgroundBtnColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: DropdownButton<String>(
                                value: _selectedItem,
                                elevation: 0,
                                underline: const SizedBox(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedItem = newValue!;
                                    whatOrder = _selectedItem;
                                    _handleSearch();
                                  });
                                },
                                items: _dropdown1Items.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Center(child: Text(value)),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Container(
                            height: 37,
                            width: 131,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(18.5)),
                              color: backgroundBtnColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: DropdownButton<String>(
                                underline: const SizedBox(),
                                value: _selected2Item,
                                elevation: 0,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selected2Item = newValue!;
                                    whatFilter = _selected2Item;
                                    _handleSearch();
                                  });
                                },
                                items: _dropdown2Items.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Center(child: Text(value)),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Container(
                            height: 37,
                            width: 131,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(18.5)),
                              color: backgroundBtnColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: DropdownButton<String>(
                                value: _selected3Item,
                                elevation: 0,
                                underline: const SizedBox(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selected3Item = newValue!;
                                  });
                                },
                                items: _dropdown3Items.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Center(child: Text(value)),
                                  );
                                }).toList(),
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
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => OnlineDetailPage(
                                  courseID:
                                  snapshot.data?.data[index].id as int
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
                                            bool? isLiked = snapshot.data?.data[index].isLiked;
                                            postStarCourses(snapshot.data?.data[index].id as int, !isLiked!);
                                            setState(() {
                                              if (snapshot.data != null) {
                                                snapshot.data!.data[index].isLiked = !(snapshot.data!.data[index].isLiked ?? false);
                                              }
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
      ),
    );
  }
}

class _body extends StatefulWidget {
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
  State<_body> createState() => _bodyState();
}

class _bodyState extends State<_body> {

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

    const String imageURL = "assets/images";

    return FutureBuilder<CourseList>(
      future: widget.services,
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // CategorySelection1(),
                        // SizedBox(width: 10.0),
                        // CategorySelection2(),
                        // SizedBox(width: 10.0),
                        // CategorySelection3(),
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
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => OnlineDetailPage(
                                courseID:
                                snapshot.data?.data[index].id as int,
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
                                            DateTime.parse(snapshot.data?.data[index].applyStartDate as String).isBefore(widget.today) && DateTime.parse(snapshot.data?.data[index].applyEndDate as String).isAfter(widget.today) ? "#신청가능" : "#신청불가능",
                                            style: widget.subTitleStyle,
                                          ),
                                          const SizedBox(width: 10),
                                          Text( snapshot.data?.data[index].isFree == true ? "#무료" : "#유료" , style: widget.subTitleStyle),
                                          const SizedBox(width: 10),
                                          Text("#직업상담사", style: widget.subTitleStyle),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          bool? isLiked = snapshot.data?.data[index].isLiked;
                                          postStarCourses(snapshot.data?.data[index].id ?? 0, !isLiked!);
                                          setState(() {
                                            if (snapshot.data != null) {
                                              snapshot.data!.data[index].isLiked = !(snapshot.data!.data[index].isLiked ?? false);
                                            }
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
                                      style: widget.subTitleStyle.copyWith(
                                          color: textColor1, fontSize: 16.0),
                                      softWrap: true,
                                    ),
                                  ),
                                  const SizedBox(height: 14.0),
                                  Text(
                                    "신청기간: ${snapshot.data?.data[index].applyStartDate}~${snapshot.data?.data[index].applyEndDate}",
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
      },
    );
  }
}

class Tagged extends StatelessWidget {
  const Tagged({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
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
    );
  }
}

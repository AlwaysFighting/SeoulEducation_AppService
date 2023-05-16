import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../const/api.dart';
import '../../../const/back_button.dart';
import '../../../const/colors.dart';
import 'package:http/http.dart' as http;

import '../models/course_detail_model.dart';
import '../models/kakao_map.dart';

class OfflineDetailPage extends StatefulWidget {
  final int courseID;
  final String title;

  const OfflineDetailPage({
    Key? key,
    required this.courseID,
    required this.title,
  }) : super(key: key);

  @override
  State<OfflineDetailPage> createState() => _OfflineDetailPageState();
}

class _OfflineDetailPageState extends State<OfflineDetailPage> {

  final String imageURL = "assets/images";

  final titleStyle = const TextStyle(
    color: textColor1,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: "Spoqa Han Sans Neo",
  );

  final textStyle = const TextStyle(
    color: textColor1,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: "Spoqa Han Sans Neo",
  );

  late Future<CourseDetail> services;

  Future<CourseDetail> fetchData() async {
    String endPointUrl = CoursesAPI().detailCourse(widget.courseID);
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
      return CourseDetail.fromJson(json.decode(response.body));
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
    print(widget.courseID);
  }

  @override
  Widget build(BuildContext context) {

    DateTime today = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(context, '오프라인강좌'),
      body: _Body(services: services, widget: widget, titleStyle: titleStyle, today: today, imageURL: imageURL, textStyle: textStyle),
    );
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
    } else {
      print(response.body);
    }
  }

  PreferredSize customAppBar(BuildContext context, String title) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: FutureBuilder<CourseDetail>(
        future: services,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("snapshot : $snapshot");
            return AppBar(
              title: const Text("오프라인강좌"),
              backgroundColor: Colors.white,
              foregroundColor: textColor1,
              automaticallyImplyLeading: false,
              elevation: 0,
              leading: const CustomBackButton(),
            );
          }
          return AppBar(
            backgroundColor: Colors.white,
            foregroundColor: textColor1,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Text(
              title,
              style: titleStyle,
            ),
            leading: const CustomBackButton(),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  onPressed: () {
                    bool? isLiked = snapshot.data?.data.isLiked;
                    postStarCourses(snapshot.data?.data.courseId ?? 0, !isLiked!);
                    setState(() {
                      if (snapshot.data != null) {
                        snapshot.data!.data.isLiked = !(snapshot.data!.data.isLiked ?? false);
                      }
                    });
                  },
                  icon: snapshot.data?.data.isLiked == false
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }

}

class _Body extends StatelessWidget {
  const _Body({
    super.key,
    required this.services,
    required this.widget,
    required this.titleStyle,
    required this.today,
    required this.imageURL,
    required this.textStyle,
  });

  final Future<CourseDetail> services;
  final OfflineDetailPage widget;
  final TextStyle titleStyle;
  final DateTime today;
  final String imageURL;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CourseDetail>(
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: titleStyle.copyWith(fontSize: 18.0),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            HashTag(
                              titleStyle: titleStyle,
                              title: DateTime.parse(snapshot.data?.data
                                              .applyStartDate as String)
                                          .isBefore(today) &&
                                      DateTime.parse(snapshot
                                              .data?.data.applyEndDate as String)
                                          .isAfter(today)
                                  ? "신청가능"
                                  : "신청불가능",
                            ),
                            const SizedBox(width: 10.0),
                            HashTag(
                              titleStyle: titleStyle,
                              title: '시험대비',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  const Divider(),
                  const SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "날짜정보",
                          style: titleStyle.copyWith(fontSize: 16.0),
                        ),
                        const SizedBox(height: 16.0),
                        CalendarInfo(
                          imageURL: '$imageURL/Const/Calendar.png',
                          textStyle: textStyle,
                          title: '신청기간',
                          duration:
                              '${snapshot.data?.data.applyStartDate}~${snapshot.data?.data.applyEndDate}',
                        ),
                        const SizedBox(height: 19.0),
                        CalendarInfo(
                          imageURL: '$imageURL/Const/PlayCircle.png',
                          textStyle: textStyle,
                          title: '강의기간',
                          duration:
                              '${snapshot.data?.data.startDate}~${snapshot.data?.data.endDate}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  const Divider(),
                  const SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "정원정보",
                          style: titleStyle.copyWith(fontSize: 16.0),
                        ),
                        const SizedBox(height: 16.0),
                        CapacityInfo(
                          imageURL: imageURL,
                          titleStyle: titleStyle,
                          text: "${snapshot.data?.data.capacity}",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  snapshot.data?.data.deptName != ""
                      ? const Divider()
                      : Container(),
                  const SizedBox(height: 30.0),
                  snapshot.data?.data.deptName != ""
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "위치정보 안내",
                              style: titleStyle.copyWith(fontSize: 16.0),
                            ),
                            const SizedBox(height: 16.0),
                            LocationInfo(
                              imageURL: imageURL,
                              textStyle: textStyle,
                              text: "${snapshot.data?.data.deptName}",
                              alertLocation: '${snapshot.data?.data.deptAddr}',
                              alertCall: '${snapshot.data?.data.deptTel}',
                            ),
                            const SizedBox(height: 20.0),
                            KakaoMapView(
                              deptLat: snapshot.data?.data.deptLat as double,
                              deptLng: snapshot.data?.data.deptLng as double,
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
        ),
              const Padding(
                padding: EdgeInsets.only(bottom: 40.0),
                child: RegisterButton(),
              ),
            ],
          );
      },
    );
  }
}

void copyToClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
}

class RegisterButton extends StatelessWidget {

  const RegisterButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 56,
          width: 358,
          child: ElevatedButton(
            onPressed: () {
              print("Register");
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.0),
                ),
                backgroundColor: mainColor),
            child: const Text(
              '강좌신청하기',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 위치 정보
class LocationInfo extends StatelessWidget {
  const LocationInfo({
    super.key,
    required this.imageURL,
    required this.textStyle,
    required this.text,
    required this.alertLocation,
    required this.alertCall,
  });

  final String imageURL;
  final TextStyle textStyle;
  final String text;
  final String alertLocation;
  final String alertCall;

  final snackBar = const SnackBar(
    content: Text('복사되었습니다!', style: TextStyle(color: textColor1),),
    duration: Duration(seconds: 1),
    backgroundColor: lightBackgroundColor,
    elevation: 1,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              '$imageURL/Const/MapPin.png',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 8.0),
            Text(
              text,
              style: textStyle,
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Alert(
                    alertLocation: alertLocation,
                    textStyle: textStyle,
                    snackBar: snackBar,
                    alertCall: alertCall);
              },
            );
          },
          child: Text(
            "위치정보보기",
            style: textStyle.copyWith(
              color: mainColor,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

class Alert extends StatelessWidget {
  const Alert({
    super.key,
    required this.alertLocation,
    required this.textStyle,
    required this.snackBar,
    required this.alertCall,
  });

  final String alertLocation;
  final TextStyle textStyle;
  final SnackBar snackBar;
  final String alertCall;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: const Center(
        child: Text(
          '위치정보 안내',
          style: TextStyle(
            color: textColor1,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      content: SizedBox(
        height: 70,
        width: 326,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/images/Const/MapPinLine.png",
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      alertLocation,
                      style: textStyle,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    copyToClipboard(alertLocation);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: Image.asset(
                    "assets/images/Const/CopySimple.png",
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Image.asset(
                  "assets/images/Const/PhoneCall.png",
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () {
                    print(alertCall);
                  },
                  child: Text(
                    alertCall,
                    style: textStyle,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Center(
            child: SizedBox(
              height: 48,
              width: 280,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: mainColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0)),
                ),
                child: Text(
                  '확인',
                  style:
                      textStyle.copyWith(color: Colors.white, fontSize: 16.0),
                ),
                onPressed: () {
                  // 확인 버튼 눌렀을 때 할 작업
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 정원 정보
class CapacityInfo extends StatelessWidget {
  const CapacityInfo({
    super.key,
    required this.imageURL,
    required this.titleStyle,
    required this.text,
  });

  final String imageURL;
  final String text;
  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          '$imageURL/Const/UserCirclePlus.png',
          width: 24,
          height: 24,
        ),
        const SizedBox(width: 8.0),
        Text(
          "$text명",
          style: titleStyle.copyWith(fontSize: 14.0),
        ),
      ],
    );
  }
}

// 날짜 정보
class CalendarInfo extends StatelessWidget {
  const CalendarInfo({
    super.key,
    required this.imageURL,
    required this.textStyle,
    required this.title,
    required this.duration,
  });

  final String imageURL;
  final TextStyle textStyle;
  final String title;
  final String duration;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          imageURL,
          width: 24,
          height: 24,
        ),
        const SizedBox(width: 8.0),
        Text(
          title,
          style: textStyle.copyWith(color: textColor2),
        ),
        const SizedBox(width: 16.0),
        Text(
          duration,
          style: textStyle,
        ),
      ],
    );
  }
}

// 구분선
class Divider extends StatelessWidget {
  const Divider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.0,
      width: MediaQuery.of(context).size.width,
      color: lightBackgroundColor,
    );
  }
}

// 해시태그
class HashTag extends StatelessWidget {
  const HashTag({
    super.key,
    required this.titleStyle,
    required this.title,
  });

  final TextStyle titleStyle;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: BoxDecoration(
            color: lightBackgroundColor,
            borderRadius: BorderRadius.circular(19.5),
            border: Border.all(
              color: mainColor,
              width: 1,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                title,
                style: titleStyle.copyWith(fontSize: 14.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

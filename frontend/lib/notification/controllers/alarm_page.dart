import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../const/colors.dart';
import '../../api/course_api.dart';
import '../models/alarm_api.dart';

import 'package:http/http.dart' as http;

import '../models/alarm_model.dart';

import 'dart:async';

class AlarmPage extends StatefulWidget {
  AlarmPage({Key? key}) : super(key: key);

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {

  DateTime now = DateTime.now();

  final subTitleStyle = const TextStyle(
    color: textColor1,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: "Spoqa Han Sans Neo",
  );

  late Future<Alarm?> services;

  Future<Alarm?> fetchData() async {
    String endPointUrl = AlarmAPI().alarmList();
    final Uri url = Uri.parse(endPointUrl);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    final response = await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    final jsonResponse = json.decode(response.body);
    final data = jsonResponse['data'];

    if (response.statusCode == 200 && data != null) {
      return Alarm.fromJson(json.decode(response.body));
    } else if (data == null) {
      print(json.decode(response.body));
      return null;
    } else {
      print(response.body);
      throw Exception("Failed to load Services..");
    }
  }

  String formatTimeDifference(String dateTimeString) {
    DateTime currentTime = DateTime.now();
    DateTime givenTime = DateTime.parse(dateTimeString);

    Duration difference = currentTime.difference(givenTime);

    if (difference.inDays == 0) {
      int hoursDifference = difference.inHours;
      if (hoursDifference >= 1) {
        return "$hoursDifference시간 전";
      } else {
        int minutesDifference = difference.inMinutes;
        return "$minutesDifference분 전";
      }
    } else {
      String formattedDate = DateFormat("M월 d일").format(givenTime);
      return formattedDate;
    }
  }

  @override
  void initState() {
    super.initState();
    LocalNotification.initialize();
    LocalNotification.requestPermission();
    services = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const BackButton()),
        title: Text(
          "알림",
          style: subTitleStyle.copyWith(fontSize: 16.0),
        ),
        backgroundColor: Colors.white,
        foregroundColor: textColor2,
        elevation: 0,
      ),
      body: FutureBuilder<Alarm?>(
        future: services,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("아직 알림이 없어요!"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.data == null || snapshot.data!.data!.isEmpty) {
            return const Center(
              child: Text('아직 알림이 없어요!'),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
            child: ListView.builder(
              itemCount: snapshot.data?.data.length ?? 0,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Row(
                    children: [
                      if (snapshot.data?.data[index].category == "new") ...[
                        Image.asset("assets/images/Alarm/alarm_new.png",
                            width: 40, height: 40),
                      ] else if (snapshot.data?.data[index].category ==
                          "last") ...[
                        Image.asset("assets/images/Alarm/alarm_finish.png",
                            width: 40, height: 40),
                      ] else ...[
                        Image.asset("assets/images/Alarm/alarm_chat.png",
                            width: 40, height: 40),
                      ],
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (snapshot.data?.data[index].category == "new") ...[
                            Text("새로운 강좌", style: subTitleStyle),
                          ] else if (snapshot.data?.data[index].category ==
                              "last") ...[
                            Text("마감 알림", style: subTitleStyle),
                          ] else if (snapshot.data?.data[index].category ==
                              "reply") ...[
                            Text("대댓글 알림", style: subTitleStyle),
                          ] else ...[
                            Text("댓글 알림", style: subTitleStyle),
                          ],
                          const SizedBox(height: 8.0),
                          if (snapshot.data?.data[index].category == "new") ...[
                            Text("새로운 강좌가 들어왔어요! 확인해보세요",
                                style: subTitleStyle.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0)),
                          ] else if (snapshot.data?.data[index].category ==
                              "last") ...[
                            Text("스크랩한 강좌의 신청기간이 3일 남았어요",
                                style: subTitleStyle.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0)),
                          ] else if (snapshot.data?.data[index].category ==
                              "reply") ...[
                            Text("작성하신 댓글에 대댓글이 달렸어요.", style: subTitleStyle.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0)),
                          ] else ...[
                            Text("작성하신 게시글에 댓글이 달렸어요",
                                style: subTitleStyle.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0)),
                          ],
                          const SizedBox(height: 8.0),
                          Text(
                            formatTimeDifference("${snapshot.data?.data[index].publishDate}"),
                            style: subTitleStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0,
                              color: textColor2,
                            ),
                          ),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     LocalNotification.sampleNotification("아니요 그건..");
                          //     print("LocalNotification");
                          //   },
                          //   child: const Text("Local Notification"),
                          // ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

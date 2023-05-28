import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../const/colors.dart';
import '../../api/course_api.dart';
import '../../community/controllers/detailcontent.dart';
import '../../const/back_button.dart';
import '../../home/offline/controllers/offline_detail_page.dart';
import '../../home/online/controllers/online_detail_page.dart';
import '../models/alarm.dart';

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
  int userid = 0;

  final subTitleStyle = const TextStyle(
    color: textColor1,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: "Spoqa Han Sans Neo",
  );

  late Stream<Alarm?> services;


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

  @override
  void dispose() {
    super.dispose();
  }

  void updateData(int index) async {
    String endPointUrl = AlarmAPI().alarmRead(index);
    final Uri url = Uri.parse(endPointUrl);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    try {
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        fetchData();
      } else {
        print('Failed to update data: ${response.body}');
      }
    } catch (error) {
      print('Error updating data: $error');
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
    ConnectSocket().lastAlarm();
    services = fetchData().asStream();
    _refreshData();
  }

  Future<void> _refreshData() async {
    services = fetchData().asStream();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text(
          "알림",
          style: subTitleStyle.copyWith(fontSize: 16.0),
        ),
        backgroundColor: Colors.white,
        foregroundColor: textColor2,
        elevation: 0,
      ),
      body: StreamBuilder<Alarm?>(
        stream: services,
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
          if (snapshot.data!.data!.isEmpty) {
            return const Center(
              child: Text('아직 알림이 없어요!'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data?.data.length ?? 0,
            itemBuilder: (context, index) {

              List<ValueNotifier<bool>> isCheckedList = List.generate(
                  snapshot.data?.data.length ?? 0,
                  (index) => ValueNotifier(snapshot.data?.data[index].isChecked as bool));

              return GestureDetector(
                onTap: () {
                  setState(() {
                    isCheckedList[index].value = true;
                  });
                  _refreshData();
                  updateData(snapshot.data?.data[index].notifyId ?? 0);
                  if (snapshot.data?.data[index].category == "last") {
                    snapshot.data?.data?[index].type ==
                        "off" ? Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OfflineDetailPage(
                          courseID:
                          snapshot.data?.data?[index].courseId as int,
                        ),
                      ),
                    ) : Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OnlineDetailPage(
                          courseID:
                          snapshot.data?.data?[index].courseId as int,
                        ),
                      ),
                    );
                  } else if (snapshot.data?.data[index].category == "comment"){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (BuildContext context) {
                      return Detailcontent(postid: snapshot.data?.data[index].postId as int,);
                    }));
                  } else if (snapshot.data?.data[index].category == "reply") {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (BuildContext context) {
                      return Detailcontent(postid: snapshot.data?.data[index].postId as int,);
                    }));
                  }
                },
                child: ValueListenableBuilder<bool>(
                  valueListenable: isCheckedList[index],
                  builder: (context, value, child) {
                    return Container(
                      color: value
                          ? Colors.white
                          : lightBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 20.0, bottom: 24.0),
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
                                if (snapshot.data?.data[index].category ==
                                    "new") ...[
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
                                if (snapshot.data?.data[index].category ==
                                    "new") ...[
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
                                  Text("작성하신 댓글에 대댓글이 달렸어요.",
                                      style: subTitleStyle.copyWith(
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
                                  formatTimeDifference(
                                      "${snapshot.data?.data[index].publishDate}"),
                                  style: subTitleStyle.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                    color: textColor2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              );
            },
          );
        },
      ),
    );
  }
}

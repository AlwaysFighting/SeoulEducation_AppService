import 'dart:convert';

import 'package:flutter/material.dart';
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
      print(json.decode(response.body));
      return Alarm.fromJson(json.decode(response.body));
    } else if (data == null) {
      return null;
    } else {
      print(response.body);
      throw Exception("Failed to load Services..");
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/images/Const/ArrowLeft.png',
                width: 24,
                height: 24,
              ),
            ),
          ),
          title: Text("알림", style: subTitleStyle.copyWith(fontSize: 16.0),),
          backgroundColor: Colors.white,
          foregroundColor: textColor2,
          elevation: 0,
        ),
        body: renderBuilder());
  }

  Widget renderBuilder() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
      child: WitchAlarm(
        subTitleStyle: subTitleStyle,
        now: now,
        alarmImage: 'assets/images/Alarm/alarm_chat.png',
        title: '새로운 강좌',
        subTitle: '새로운 강좌가 들어왔어요! 확인해보세요',
      ),
    );
  }
}

class WitchAlarm extends StatelessWidget {
  const WitchAlarm({
    super.key,
    required this.subTitleStyle,
    required this.now,
    required this.alarmImage,
    required this.title,
    required this.subTitle,
  });

  final TextStyle subTitleStyle;
  final DateTime now;
  final String alarmImage;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Row(
            children: [
              Image.asset(
                alarmImage,
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: subTitleStyle,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    subTitle,
                    style: subTitleStyle.copyWith(
                        fontWeight: FontWeight.w400, fontSize: 14.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "${now.month}월 ${now.day}일",
                    style: subTitleStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                      color: textColor2,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        LocalNotification.sampleNotification("아니요 그건..");
                        print("LocalNotification");
                      },
                      child: const Text("Local Notification")),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

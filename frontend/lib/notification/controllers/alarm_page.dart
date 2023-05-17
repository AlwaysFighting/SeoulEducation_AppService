import 'package:flutter/material.dart';
import '../../../const/colors.dart';

class AlarmPage extends StatelessWidget {
  AlarmPage({Key? key}) : super(key: key);

  DateTime now = DateTime.now();

  final subTitleStyle = const TextStyle(
    color: textColor1,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: "Spoqa Han Sans Neo",
  );

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
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

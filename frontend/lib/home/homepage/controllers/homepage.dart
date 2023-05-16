import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:seoul_education_service/home/homepage/models/search_bar.dart';
import 'package:seoul_education_service/home/offline/controllers/offline_page.dart';
import 'package:seoul_education_service/home/online/controllers/online_page.dart';
import 'package:seoul_education_service/home/recommend/controllers/recommend_page.dart';
import 'package:seoul_education_service/notification/controllers/alarm_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../const/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppHeader(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 30.0, bottom: 30.0),
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
              _body(),
              const SizedBox(height: 40),
              Text("여기, 주목!", style: titleStyle.copyWith(fontSize: 18.0)),
              const SizedBox(height: 14),
              const Banner(),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("공지사항", style: titleStyle.copyWith(fontSize: 18.0)),
                  TextButton(
                    onPressed: () {
                      print("공지사항");
                    },
                    child: Text("전체보기",
                        style: subTitleStyle.copyWith(color: textColor1)),
                  )
                ],
              ),
              const SizedBox(height: 16.0),
              Column(
                children: [
                  NoticeInfo(
                    titleStyle: titleStyle,
                    subTitleStyle: subTitleStyle,
                    text: '[서울특별시남부여성발전센터] 클라우드 기반 AI 융합 iOS 개발자 과정 교육생 모집',
                    date: '2023.05.15',
                  ),
                  const SizedBox(height: 16.0),
                  NoticeInfo(
                    titleStyle: titleStyle,
                    subTitleStyle: subTitleStyle,
                    text: '여성가족부지원 직업교육훈련 [멀티사무원 양성과정] 교육생 모집',
                    date: '2023.05.09',
                  ),
                  const SizedBox(height: 16.0),
                  NoticeInfo(
                    titleStyle: titleStyle,
                    subTitleStyle: subTitleStyle,
                    text: '[서울시 시민참여예산] 서울시가 2024년 시행하기 원하는 사업을 제안해 주세요.',
                    date: '2023.04.26',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _body() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CoursesWidget(
          titleStyle: titleStyle,
          index: 0,
          image: 'assets/images/Home/onlineIcon.png',
          title: '온라인강좌',
        ),
        CoursesWidget(
          titleStyle: titleStyle,
          index: 1,
          image: 'assets/images/Home/offlineIcon.png',
          title: '오프라인강좌',
        ),
        CoursesWidget(
          titleStyle: titleStyle,
          index: 2,
          image: 'assets/images/Home/recommendIcon.png',
          title: '추천강좌',
        ),
      ],
    );
  }
}

class Banner extends StatelessWidget {

  const Banner({super.key});

  final String imageURL = "assets/images/";

  @override
  Widget build(BuildContext context) {

    List<String> list = [
      '$imageURL/Home/banner.png',
      '$imageURL/Home/banner.png',
      '$imageURL/Home/banner.png'
    ];

    Future<void> _launchUrl(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        height: 126,
        viewportFraction: 1.0,
        scrollDirection: Axis.horizontal,
        aspectRatio: 0.9,
        initialPage: 1,
        autoPlayCurve: Curves.fastOutSlowIn,
      ),
      items: list.asMap().entries.map((entry) {
        int index = entry.key + 1;
        String item = entry.value;
        return GestureDetector(
          onTap: () {
            _launchUrl("https://data.seoul.go.kr/#");
          },
          child: SizedBox(
            height: 126,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRect(
                  child: Stack(
                    children: [
                      Image.asset(
                        item,
                        width: 358,
                        height: 126,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(50, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            '$index/${list.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class NoticeInfo extends StatelessWidget {
  const NoticeInfo({
    super.key,
    required this.titleStyle,
    required this.subTitleStyle,
    required this.text,
    required this.date,
  });

  final TextStyle titleStyle;
  final TextStyle subTitleStyle;
  final String text;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 260,
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: titleStyle.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 16.0,
            ),
          ),
        ),
        Text(
          date,
          style: subTitleStyle.copyWith(
              fontWeight: FontWeight.w400, color: textColor2),
        ),
      ],
    );
  }
}

class CoursesWidget extends StatelessWidget {
  CoursesWidget({
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

class AppHeader extends StatelessWidget {
  const AppHeader({
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
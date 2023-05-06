import 'package:flutter/material.dart';
import 'package:seoul_education_service/home/homepage/models/search_bar.dart';
import 'package:seoul_education_service/home/offline/controllers/offline_page.dart';
import 'package:seoul_education_service/home/online/controllers/online_page.dart';
import 'package:seoul_education_service/home/recommend/controllers/recommend_page.dart';

import '../../../const/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  final titleStyle = const TextStyle(
    color: textColor1,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    fontFamily: "Spoqa Han Sans Neo",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: _appBar(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "당신의 끝없는\n배움을 응원합니다!",
                style: titleStyle,
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
              const SizedBox(height: 40),
              Text("오프라인 새로운 강좌", style: titleStyle.copyWith(fontSize: 18.0)),
            ],
          ),
        ),
      ),
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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.asset(
            'assets/images/Const/Bell.png',
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }
}

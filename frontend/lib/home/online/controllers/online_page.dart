import 'package:flutter/material.dart';
import 'package:seoul_education_service/const/colors.dart';

import '../../../notification/models/category_button.dart';

class OnlinePage extends StatefulWidget {
  const OnlinePage({Key? key}) : super(key: key);

  @override
  State<OnlinePage> createState() => _OnlinePageState();
}

class _OnlinePageState extends State<OnlinePage> {
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

  late bool _isSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: textColor2,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                children: [
                  NewestCategoryButton(
                    isSelected: false,
                    onPressed: () {
                      print("최신순");
                    }, title: '최신순',
                  ),
                  const SizedBox(width: 16.0),
                  NewestCategoryButton(
                    isSelected: false,
                    onPressed: () {
                      print("모집예정");
                    }, title: '모집예정',
                  ),
                  const SizedBox(width: 16.0),
                  NewestCategoryButton(
                    isSelected: false,
                    onPressed: () {
                      print("시험대비");
                    }, title: '시험대비',
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              _courseListView(
                subTitleStyle: subTitleStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _courseListView extends StatelessWidget {
  const _courseListView({
    super.key,
    required this.subTitleStyle,
  });

  final TextStyle subTitleStyle;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: lightBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("#신청가능", style: subTitleStyle),
                          const SizedBox(width: 10),
                          Text("#직업상담사", style: subTitleStyle),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          print("찜 완료!");
                        },
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
                      '2023 직업상담사(아이엠에듀) - 필기 - 직업심리학 ',
                      style: subTitleStyle.copyWith(
                          color: textColor1, fontSize: 16.0),
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(height: 14.0),
                  Text(
                    "신청기간: 2023.03.04~2023.12.31",
                    style: subTitleStyle.copyWith(
                        color: textColor2, fontWeight: FontWeight.w500),
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

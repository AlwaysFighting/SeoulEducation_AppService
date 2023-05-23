import 'package:flutter/material.dart';

import '../../../const/back_button.dart';
import '../../../const/colors.dart';

class NoticeDetailPage extends StatelessWidget {
  const NoticeDetailPage({Key? key, required this.title}) : super(key: key);
  final String title;

  final titleStyle = const TextStyle(
    color: textColor1,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: "Spoqa Han Sans Neo",
  );

  final subTitleStyle = const TextStyle(
    color: textColor2,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: "Spoqa Han Sans Neo",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text(title),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: textColor1,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('[이벤트] 재능 기부도 하고 상품도 받고!? 시민 참여 영상 제작 이벤트', style: titleStyle,),
            subtitle: Text('2023.05.22', style: subTitleStyle,),
            trailing: Image.asset(
              'assets/images/Courses/CaretDown.png',
              width: 24,
              height: 24,
            ),
          ),
          const Divider(height: 15),
          ListTile(
            title: Text('[서평포] 시민제작 강의개설 방법', style: titleStyle,),
            subtitle: Text('2023.05.22', style: subTitleStyle,),
            trailing: Image.asset(
              'assets/images/Courses/CaretDown.png',
              width: 24,
              height: 24,
            ),
          ),
          const Divider(height: 15),
          ListTile(
            title: Text('[서울과학기술대학교] 제 3회 명사특강 진행', style: titleStyle,),
            subtitle: Text('2023.05.22', style: subTitleStyle,),
            trailing: Image.asset(
              'assets/images/Courses/CaretDown.png',
              width: 24,
              height: 24,
            ),
          ),
          const Divider(height: 15),
          ListTile(
            title: Text('[서울특별시남부여성발전센터] 클라우드 기반 AI 융합 iOS 개발자 과정 교육생 모집', style: titleStyle,),
            subtitle: Text('2023.05.15', style: subTitleStyle,),
            trailing: Image.asset(
              'assets/images/Courses/CaretDown.png',
              width: 24,
              height: 24,
            ),
          ),
          const Divider(height: 15),
          ListTile(
            title: Text('여성가족부지원 직업교육훈련 [멀티사무원 양성과정] 교육생 모집', style: titleStyle,),
            subtitle: Text('2023.05.09', style: subTitleStyle,),
            trailing: Image.asset(
              'assets/images/Courses/CaretDown.png',
              width: 24,
              height: 24,
            ),
          ),
          const Divider(height: 15),
          ListTile(
            title: Text('[서울시 시민참여예산] 서울시가 2024년 시행하기 원하는 사업을 제안해 주세요.', style: titleStyle,),
            subtitle: Text('2023.05.26', style: subTitleStyle,),
            trailing: Image.asset(
              'assets/images/Courses/CaretDown.png',
              width: 24,
              height: 24,
            ),
          ),
          const Divider(height: 15),
          ListTile(
            title: Text('[서울과학기술대학교] 제 2회 명사특강 진행', style: titleStyle,),
            subtitle: Text('2023.04.26', style: subTitleStyle,),
            trailing: Image.asset(
              'assets/images/Courses/CaretDown.png',
              width: 24,
              height: 24,
            ),
          ),
          const Divider(height: 15),
          ListTile(
            title: Text('[자치구 공인중개사 연수교육] 전과정 정상 수강 안내', style: titleStyle,),
            subtitle: Text('2023.04.18', style: subTitleStyle,),
            trailing: Image.asset(
              'assets/images/Courses/CaretDown.png',
              width: 24,
              height: 24,
            ),
          ),
          const Divider(height: 15),
          ListTile(
            title: Text('ST 평생교육 명사 특강 [시대를 알아야 미래가 보인다]', style: titleStyle,),
            subtitle: Text('2023.04.04', style: subTitleStyle,),
            trailing: Image.asset(
              'assets/images/Courses/CaretDown.png',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
    );
  }
}

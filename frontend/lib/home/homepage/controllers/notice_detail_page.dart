import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  launchURLChannel(String whatURL) async {
    String url = whatURL;
    if (await canLaunch(url)) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      const SnackBar(
        content: Text(
          '네트워크를 확인해주세요!',
          style: TextStyle(color: textColor1),
        ),
        duration: Duration(seconds: 1),
        backgroundColor: lightBackgroundColor,
        elevation: 1,
      );
    }
  }

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
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text('[이벤트] 재능 기부도 하고 상품도 받고!? 시민 참여 영상 제작 이벤트', style: titleStyle,),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('2023.05.22', style: subTitleStyle,),
              ),
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    launchURLChannel("https://sll.seoul.go.kr/lms/front/event/doJoinListEvent.do?event_no=84");
                  },
                  child: Image.asset(
                    'assets/images/Notice/notice1.png',
                    width: 300,
                    height: 300,
                  ),
                )
              ],
            ),
          ),
          const Divider(height: 15),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text('[서평포] 시민제작 강의개설 방법', style: titleStyle,),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('2023.05.22', style: subTitleStyle,),
              ),
              children: <Widget>[
                Image.asset(
                  'assets/images/Notice/notice2.png',
                  width: 300,
                  height: 500,
                )
              ],
            ),
          ),
          const Divider(height: 15),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text('[서울과학기술대학교] 제 3회 명사특강 진행', style: titleStyle,),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('2023.05.22', style: subTitleStyle,),
              ),
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("<시대를 알아야 미래가 보인다> ST 평생교육 명사 특강 !", overflow: TextOverflow.clip,),
                    SizedBox(height: 5.0),
                    Text("- 일 시 : 5.22(월), 14:00~16:00", overflow: TextOverflow.clip,),
                    Text("- 강 사 : (주)에이팀벤처스 고 산 대표이사", overflow: TextOverflow.clip,),
                    Text("- 대 상 : 서울과학기술대학교 재학생, 지역주민 등", overflow: TextOverflow.clip,),
                    Text("- 장 소 : 서울과학기술대학교 테크노큐브동 12층 큐브홀", overflow: TextOverflow.clip,),
                    SizedBox(height: 5.0),
                    Text("자세한 사항은 포스터 확인 바랍니다.\n많은 참여 바랍니다 :)\n감사합니다.", overflow: TextOverflow.clip,),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 15),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text('[서울특별시남부여성발전센터] 클라우드 기반 AI 융합 iOS 개발자 과정 교육생 모집', style: titleStyle,),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('2023.05.15', style: subTitleStyle,),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("안녕하세요☺️"),
                      const Text("서울특별시남부여성발전센터에서 '클라우드 기반 AI 융합 iOS 개발자' 과정 교육생 모집을 한다고 합니다.", overflow: TextOverflow.clip,),
                      const Text("아래 내용 확인하시어 많은 신청 바랍니다. ", overflow: TextOverflow.ellipsis,),
                      const Text("감사합니다.\n", overflow: TextOverflow.ellipsis,),
                      const SizedBox(height: 5.0),
                      const Text("※ 과 정 명  : 클라우드 기반 AI융합 iOS개발자", overflow: TextOverflow.clip,),
                      const Text("※ 교육기간 : 5.30~9.14(1일 6시간, 총 420시간)", overflow: TextOverflow.clip,),
                      const Text("※ 교육대상 : 정보통신 분야 전공 및 자격 소지한 서울시 청년여성 ", overflow: TextOverflow.clip,),
                      const Text("※ 교육내용 : SWIFT, Django, DevOps, Azure Cloud, 프로젝트 실습\n", overflow: TextOverflow.clip,),
                      const SizedBox(height: 5.0),
                      const Text("자세한 사항은 포스터 확인 바랍니다.\n많은 참여 바랍니다 :)\n감사합니다.", overflow: TextOverflow.clip,),
                      Center(
                        child: Image.asset(
                          'assets/images/Notice/notice4.png',
                          width: 300,
                          height: 500,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 15),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text('여성가족부지원 직업교육훈련 [멀티사무원 양성과정] 교육생 모집', style: titleStyle,),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('2023.05.09', style: subTitleStyle,),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("◉교육내용: 경리, 회계, 고객관리 등 실무업무를 다각적으로 처리할 수 있는 실무형 인재 양성 과정"),
                      const Text("◉교육기간: 2023.7.3.(월) ~ 9.22.(금) 월~금/ 14:00~18:00", overflow: TextOverflow.clip,),
                      const Text("◉교육대상: 멀티사무원 (경리 및 사무직종) 관련분야로 취업을 희망하는 여성", overflow: TextOverflow.ellipsis,),
                      const Text("◉교육내용: FAT1급 시험대비 및 세무•회계 실무, ITQ자격증 대비 및 실무교육 등", overflow: TextOverflow.clip,),
                      const Text("◉교육생 특전: 교재비지원, TQ 자격증 응시료 및 FAT1급 자격증 응시료 지원", overflow: TextOverflow.clip,),
                      const Text("◉ 문의 : 02-2607-8791 (내선2번/ 담당자: 김은희)", overflow: TextOverflow.clip,),
                      Center(
                        child: Image.asset(
                          'assets/images/Notice/notice5.png',
                          width: 300,
                          height: 500,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 15),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text('[서울시 시민참여예산] 서울시가 2024년 시행하기 원하는 사업을 제안해 주세요.', style: titleStyle,),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('2023.05.26', style: subTitleStyle,),
              ),
              children: const <Widget>[
                Text("", overflow: TextOverflow.clip,),
              ],
            ),
          ),
          const Divider(height: 15),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text('[서울과학기술대학교] 제 2회 명사특강 진행', style: titleStyle,),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('2023.05.26', style: subTitleStyle,),
              ),
              children: const <Widget>[
                Text("", overflow: TextOverflow.clip,),
              ],
            ),
          ),
          const Divider(height: 15),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text('[자치구 공인중개사 연수교육] 전과정 정상 수강 안내', style: titleStyle,),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('2023.05.26', style: subTitleStyle,),
              ),
              children: const <Widget>[
                Text("", overflow: TextOverflow.clip,),
              ],
            ),
          ),
          const Divider(height: 15),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text('ST 평생교육 명사 특강 [시대를 알아야 미래가 보인다]', style: titleStyle,),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('2023.05.26', style: subTitleStyle,),
              ),
              children: const <Widget>[
                Text("", overflow: TextOverflow.clip,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

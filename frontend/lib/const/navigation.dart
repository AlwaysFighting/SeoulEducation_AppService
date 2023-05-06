import 'package:flutter/material.dart';
import 'package:seoul_education_service/community/controllers/commuinty.dart';
import '../home/homepage/views/homepage.dart';
import '../mypage/mypage.dart';
import 'colors.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int index = 0;

  // 현재 페이지를 나타낼 index
  int currentIndex = 0;

// 이동할 페이지 Widget
  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const CommunityPage(),
    const MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.elementAt(currentIndex),
      ),
      bottomNavigationBar: _bottomNavigation(),
    );
  }

  BottomNavigationBar _bottomNavigation() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      unselectedItemColor: textColor2,
      selectedLabelStyle: const TextStyle(color: mainColor),
      selectedFontSize: 12,
      unselectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          currentIndex = index;
        });
      },
      currentIndex: currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset(
              'assets/images/BottomNavBarItem/house_grey.png',
              width: 24,
              height: 24,
            ),
          ),
          activeIcon: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset(
              'assets/images/BottomNavBarItem/House.png',
              width: 24,
              height: 24,
            ),
          ),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset(
              'assets/images/BottomNavBarItem/chats_grey.png',
              width: 24,
              height: 24,
            ),
          ),
          activeIcon: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset(
              'assets/images/BottomNavBarItem/Chats.png',
              width: 24,
              height: 24,
            ),
          ),
          label: '질문게시판',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset(
              'assets/images/BottomNavBarItem/user_grey.png',
              width: 24,
              height: 24,
            ),
          ),
          activeIcon: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset(
              'assets/images/BottomNavBarItem/User.png',
              width: 24,
              height: 24,
            ),
          ),
          label: '마이페이지',
        ),
      ],
    );
  }
}

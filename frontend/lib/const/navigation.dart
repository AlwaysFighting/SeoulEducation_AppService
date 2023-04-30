import 'package:flutter/material.dart';
import 'package:seoul_education_service/community/controllers/commuinty.dart';
import '../home/homepage/views/homepage.dart';
import '../mypage/mypage.dart';

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
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(color: Colors.black),
      selectedItemColor: Colors.black,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          currentIndex = index;
        });
      },
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(
          label: "홈",
          icon: Icon(Icons.home_outlined),
        ),
        BottomNavigationBarItem(
          label: "게시판",
          icon: Icon(Icons.chat_outlined),
        ),
        BottomNavigationBarItem(
          label: "마이페이지",
          icon: Icon(Icons.person_outline),
        ),
      ],
    );
  }
}

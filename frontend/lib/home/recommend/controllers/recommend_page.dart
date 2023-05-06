import 'package:flutter/material.dart';

import '../../../const/colors.dart';

class RecommendPage extends StatelessWidget {
  const RecommendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: textColor2,
        elevation: 0,
      ),
      body: const Center(
        child: Text("RecommendPage"),
      ),
    );
  }
}

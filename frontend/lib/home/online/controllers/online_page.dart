import 'package:flutter/material.dart';
import 'package:seoul_education_service/const/colors.dart';

class OnlinePage extends StatelessWidget {
  const OnlinePage({Key? key}) : super(key: key);

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
        child: Text("OnlinePage"),
      ),
    );
  }
}

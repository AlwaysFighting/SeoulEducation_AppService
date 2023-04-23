import 'package:flutter/material.dart';
import 'package:seoul_education_service/const/colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final textStyle = const TextStyle(
    color: textColor1,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    fontFamily: "Spoqa Han Sans Neo",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_sharp),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          foregroundColor: textColor1,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          clipBehavior: Clip.none,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("회원가입", style: textStyle),
              ],
            ),
          ),
        ));
  }
}

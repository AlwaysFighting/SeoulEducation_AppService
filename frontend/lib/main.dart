import 'package:flutter/material.dart';
import 'package:seoul_education_service/logins/login/views/login_page.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Spoqa Han Sans Neo'),
      home: const LoginPage(),
    ),
  );
}

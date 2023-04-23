import 'package:flutter/material.dart';
import 'const/navigation.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Spoqa Han Sans Neo'),
      home: const Navigation(),
    ),
  );
}

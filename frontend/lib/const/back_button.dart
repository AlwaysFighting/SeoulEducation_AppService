import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
  });

  final String imageURL = "assets/images";

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset(
        '$imageURL/Const/ArrowLeft.png',
        width: 24,
        height: 24,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}

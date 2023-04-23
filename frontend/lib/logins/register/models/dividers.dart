import 'package:flutter/material.dart';
import '../../../const/colors.dart';

class Dividers extends StatelessWidget {
  const Dividers({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -1),
            blurRadius: 1,
          ),
        ],
      ),
      child: const Divider(
        height: 10,
        thickness: 10,
        color: lightBackgroundColor,
      ),
    );
  }
}
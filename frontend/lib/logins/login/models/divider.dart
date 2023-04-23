import 'package:flutter/material.dart';
import '../../../const/colors.dart';

class ORDivider extends StatelessWidget {
  const ORDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Expanded(
          child: DividerLine(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF737373),
            ),
          ),
        ),
        Expanded(
          child: DividerLine(),
        ),
      ],
    );
  }
}

class DividerLine extends StatelessWidget {
  const DividerLine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: 100,
      color: backgroundColor,
    );
  }
}

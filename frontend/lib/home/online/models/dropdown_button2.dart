import 'package:flutter/material.dart';

import '../../../const/colors.dart';

class CategorySelection2 extends StatefulWidget {

  final bool isSelected;

  const CategorySelection2({super.key, required this.isSelected});

  @override
  _CategorySelection2State createState() => _CategorySelection2State();
}

class _CategorySelection2State extends State<CategorySelection2> {
  late bool _isSelected;
  String _selectedCategory = '모집예정';

  @override
  void initState() {
    _isSelected = widget.isSelected;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CategorySelection2 oldWidget) {
    if (widget.isSelected != oldWidget.isSelected) {
      _isSelected = widget.isSelected;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.5),
          border: Border.all(color: lineColor),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedCategory,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue!;
                _isSelected = !_isSelected;
              });
            },
            icon: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Image.asset(
                "assets/images/Courses/CaretDown.png",
                width: 16,
                height: 16,
              ),
            ),
            items: <String>[
              '모집예정',
              '신청가능',
              "신청완료"
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}


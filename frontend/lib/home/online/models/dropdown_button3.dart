import 'package:flutter/material.dart';

import '../../../const/colors.dart';

class CategorySelection3 extends StatefulWidget {

  final bool isSelected;

  const CategorySelection3({super.key, required this.isSelected});

  @override
  _CategorySelection3State createState() => _CategorySelection3State();
}

class _CategorySelection3State extends State<CategorySelection3> {
  late bool _isSelected;
  String _selectedCategory = '시험대비';

  @override
  void initState() {
    _isSelected = widget.isSelected;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CategorySelection3 oldWidget) {
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
              '시험대비',
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


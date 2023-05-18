import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:seoul_education_service/const/colors.dart';

class CategorySelection1 extends StatefulWidget {
  const CategorySelection1({super.key});

  @override
  State<CategorySelection1> createState() => _CategorySelection1State();
}

class _CategorySelection1State extends State<CategorySelection1> {

  final List<String> list1items = ['최신순', '관심설정순', "마감설정순"];

  String? selectedBtn1Value;
  Color lineColors = lineColor;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.5),
          border: Border.all(color: lineColors),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            iconStyleData: IconStyleData(
              icon: Image.asset(
                "assets/images/Courses/CaretDown.png",
                width: 16,
                height: 16,
              ),
            ),
            hint: const Text(
              '최신순',
              style: TextStyle(
                fontSize: 14,
                color: textColor1,
                fontWeight: FontWeight.w400,
              ),
            ),
            items: list1items
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                          color: textColor1,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ))
                .toList(),
            value: selectedBtn1Value,
            onChanged: (value) {
              setState(() {
                selectedBtn1Value = value as String;
              });
            },
            buttonStyleData: const ButtonStyleData(
              height: 40,
              width: 81,
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              width: MediaQuery.of(context).size.width,
              padding: null,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              elevation: 1,
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all(6),
                thumbVisibility: MaterialStateProperty.all(true),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:seoul_education_service/const/colors.dart';

class CategorySelection2 extends StatefulWidget {
  const CategorySelection2({super.key});

  @override
  State<CategorySelection2> createState() => _CategorySelection2State();
}

class _CategorySelection2State extends State<CategorySelection2> {
  final List<String> list2items = ['신청예정', '신청가능', '신청완료'];

  String? selectedBtn2Value;
  Color lineColors = lineColor;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            '모집예정',
            style: TextStyle(
              fontSize: 14,
              color: textColor1,
              fontWeight: FontWeight.w400,
            ),
          ),
          items: list2items
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
          value: selectedBtn2Value,
          onChanged: (value) {
            setState(() {
              selectedBtn2Value = value as String;
            });
          },
          buttonStyleData: const ButtonStyleData(
            height: 40,
            width: 73,
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
    );
  }
}
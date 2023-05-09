import 'package:flutter/material.dart';
import '../../const/colors.dart';

class NewestCategoryButton extends StatefulWidget {
  final bool isSelected;
  final VoidCallback onPressed;
  final String title;

  const NewestCategoryButton({
    Key? key,
    required this.isSelected,
    required this.onPressed,
    required this.title,
  }) : super(key: key);

  @override
  _NewestCategoryButtonState createState() => _NewestCategoryButtonState();
}

class _NewestCategoryButtonState extends State<NewestCategoryButton> {
  late bool _isSelected;

  @override
  void initState() {
    _isSelected = widget.isSelected;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NewestCategoryButton oldWidget) {
    if (widget.isSelected != oldWidget.isSelected) {
      _isSelected = widget.isSelected;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _isSelected = !_isSelected;
            });
            widget.onPressed();
          },
          icon: _isSelected
              ? Image.asset(
            "assets/images/Courses/CaretUp.png",
            width: 16,
            height: 16,
          )
              : Image.asset(
            "assets/images/Courses/CaretDown.png",
            width: 16,
            height: 16,
          ),
          label: Text(
            widget.title,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: _isSelected ? FontWeight.w500 : FontWeight.w400,
              color: _isSelected ? Colors.white : textColor1,
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: _isSelected ? mainColor : const Color(0xFFF6F6F6),
            onPrimary: _isSelected ? Colors.white : textColor1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.5),
              side: _isSelected
                  ? const BorderSide(color: Colors.white)
                  : const BorderSide(color: Color(0xFFDBDBDB)),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
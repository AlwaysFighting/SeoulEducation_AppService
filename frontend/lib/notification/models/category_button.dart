import 'package:flutter/material.dart';

import '../../const/colors.dart';

class NewestCategoryButton extends StatefulWidget {
  final bool isSelected;
  final VoidCallback onPressed;

  const NewestCategoryButton({
    Key? key,
    required this.isSelected,
    required this.onPressed,
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
    final buttonStyle = _isSelected
        ? ElevatedButton.styleFrom(
            primary: mainColor,
            onPrimary: Colors.white,
            maximumSize: const Size(77, 37),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.5),
            ),
            elevation: 0,
          )
        : ElevatedButton.styleFrom(
            primary: const Color(0xFFF6F6F6),
            onPrimary: textColor1,
            maximumSize: const Size(77, 37),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.5),
              side: const BorderSide(color: Color(0xFFDBDBDB)),
            ),
            elevation: 0,
          );

    return ElevatedButton(
      style: buttonStyle,
      onPressed: () {
        widget.onPressed();
        setState(() {
          _isSelected = !_isSelected;
        });
      },
      child: _isSelected
          ? Stack(
              alignment: Alignment.center,
              children: [
                const Text(
                  '최신순',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isSelected = !_isSelected;
                    });
                  },
                  icon: Image.asset(
                    "assets/images/Courses/CaretUp.png",
                    width: 16,
                    height: 16,
                  ),
                )
              ],
            )
          : Stack(
              alignment: Alignment.center,
              children: [
                const Text(
                  '최신순',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: textColor1,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isSelected = !_isSelected;
                    });
                  },
                  icon: Image.asset(
                    "assets/images/Courses/CaretDown.png",
                    width: 16,
                    height: 16,
                  ),
                ),
              ],
            ),
    );
  }
}

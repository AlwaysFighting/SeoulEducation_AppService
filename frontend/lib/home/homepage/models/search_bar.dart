import 'package:flutter/cupertino.dart';
import 'package:seoul_education_service/const/colors.dart';

class SearchTextFieldExample extends StatefulWidget {
  const SearchTextFieldExample({Key? key}) : super(key: key);

  @override
  State<SearchTextFieldExample> createState() => _SearchTextFieldExampleState();
}

class _SearchTextFieldExampleState extends State<SearchTextFieldExample> {
  late final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _focusNode.unfocus();
        print("GG");
      },
      child: SizedBox(
        height: 48.0,
        width: 358.0,
        child: CupertinoSearchTextField(
          focusNode: _focusNode,
          decoration: BoxDecoration(
            color: backgroundBtnColor,
            border: Border.all(
              color: mainColor,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
          prefixIcon: Image.asset(
            'assets/images/Const/MagnifyingGlass.png',
            width: 20,
            height: 20,
          ),
          placeholder: "찾고자 하는 강좌를 검색해주세요.",
          onChanged: (String value) {
            print(value);
          },
          onSubmitted: (String value) {
            print(value);
          },
        ),
      ),
    );
  }
}

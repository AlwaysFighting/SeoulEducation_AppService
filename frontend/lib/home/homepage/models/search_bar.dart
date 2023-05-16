import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'package:seoul_education_service/home/homepage/controllers/homepage_search_page.dart';

class SearchTextFieldExample extends StatefulWidget {
  const SearchTextFieldExample({Key? key}) : super(key: key);

  @override
  State<SearchTextFieldExample> createState() => _SearchTextFieldExampleState();
}

class _SearchTextFieldExampleState extends State<SearchTextFieldExample> {
  late final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  String searchText = "";

  void _onSearch() {
    String keyword = _textEditingController.text;
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          return EntireSearchPage(searchKeyword: keyword);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _focusNode.unfocus();
      },
      child: SizedBox(
        height: 48.0,
        width: 358.0,
        child: CupertinoSearchTextField(
          controller: _textEditingController,
          focusNode: _focusNode,
          decoration: BoxDecoration(
            color: backgroundBtnColor,
            border: Border.all(
              color: mainColor,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
          prefixIcon: GestureDetector(
            onTap: _onSearch,
            child: Image.asset(
              'assets/images/Const/MagnifyingGlass.png',
              width: 20,
              height: 20,
            ),
          ),
          placeholder: "찾고자 하는 강좌를 검색해주세요.",
          onChanged: (String value) {
            setState(() {
              searchText = value;
            });
          },
          onSubmitted: (String value) {
            setState(() {
              searchText = value;
            });
          },
        ),
      ),
    );
  }
}

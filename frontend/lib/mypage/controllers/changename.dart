import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seoul_education_service/const/colors.dart';
import 'changeprivate.dart';

class changename extends StatefulWidget{
  const changename({Key? key}):super(key:key);

  @override
  State<changename> createState() => _changename();
}
class _changename extends State<changename> {
  bool _showSuffixicon = false;
  TextEditingController _textcontroller = TextEditingController();
  @override
  void initState() {
    super.initState();
    ScreenUtil.init(context);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844));
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 44.h,),
          appbar(),
          SizedBox(height: 20.h,),
          content(),
          SizedBox(height: 563.h,),
          success(),

        ],
      ),
    );
  }

  Widget appbar() {
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 56.h,
      child: Row(
        children: [
          SizedBox(width: 16.w,),
          GestureDetector(
            onTap: () {
              backDialog();
            },
            child: Image.asset(
              'assets/images/ArrowLeft.png', width: 24.w, height: 24.w,),
          ),
          SizedBox(width: 109.w,),
          Text("이름 수정",
            style: TextStyle(
              fontFamily: 'Spoqa Han Sans Neo',
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  Widget content(){
    return SizedBox(
        //height: 48.h,
        width: 358.w,
        child: Align(
          alignment: Alignment.centerLeft,
          child:Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 12.w,),
                  Text("이름",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Spoqa Han Sans Neo',
                    ),),
                ],
              ),
              SizedBox(height: 10.h,),
              SizedBox(
                width: 358.w,
                height: 48.h,
                child: TextFormField(
                  controller: _textcontroller,
                  onChanged: (value){
                    setState(() {
                      _showSuffixicon = value.isNotEmpty;
                    });
                  },
                  style: TextStyle(
                    fontFamily: 'Spoqa Han Sans Neo',
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    suffixIcon: Visibility(
                      visible: _showSuffixicon,
                      child:GestureDetector(
                          onTap: (){
                            //팝업창
                          },
                          child:SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: Image.asset("assets/images/XCircle.png"))
                      ),
                    ),
                    border: InputBorder.none,
                    hintText: "usernickname",
                    hintStyle: TextStyle(
                      fontFamily: 'Spoqa Han Sans Neo',
                      fontSize: ScreenUtil().setSp(14),
                      color: textColor2,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(16.w, 16.h, 0, 15.h
                              ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: mainColor),
                      borderRadius: BorderRadius.all(Radius.circular(24)),

                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      borderSide: BorderSide(color:mainColor),
                    ),
                    filled: true,
                    fillColor: backgroundBtnColor,
                  ),
                ),
              ),
            ],
          )

        ),
      );
  }
  Widget success(){
    return GestureDetector(
      onTap: (){
        _textcontroller.text.isNotEmpty ? Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => changeprivate(),
          ),
        ) : print("이름이 입력되지 않음");
      },
      child: Container(
        height: 80.h,
        color: mainColor,
        child: Center(
          child: Text("확인",
          style: TextStyle(
            fontFamily: 'Spoqa Han Sans Neo',
            fontSize: 16.sp,
            color: Colors.white,
          ),),
        ),
      ),
    );
  }
  void backDialog(){
    showDialog(context: context, 
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
            ),
            title: Column(
              children: <Widget>[
                Text("뒤로가기",
                style: TextStyle(
                  fontSize: 17.sp,
                  fontFamily: 'Spoqa Han Sans Neo',
                ),),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("변경사항이 저장되지 않습니다.\n그래도 나가시겠습니까?",
                style: TextStyle(
                  fontFamily: 'Spoqa Han Sans Neo',
                  fontSize: 13.sp,
                  color: textColor2,
                ),

                )
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                  },
                      child: const Text("아니요",
                        style: TextStyle(
                          fontFamily: 'Spoqa Han Sans Neo',
                          color: mainColor,
                        ),
                      )),
                  TextButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => changeprivate(),
                      ),
                    );
                  },
                      child: const Text("예",
                        style: TextStyle(
                          fontFamily: 'Spoqa Han Sans Neo',
                          color: mainColor,
                        ),
                      )),
                ],
              )
            ],
          );
        });
  }
}
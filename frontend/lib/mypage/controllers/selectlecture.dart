import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seoul_education_service/const/colors.dart';
class SelectLecture extends StatefulWidget{
  const SelectLecture({Key? key}) : super(key: key);

  @override
  State<SelectLecture> createState() => _SelectState();
}

class _SelectState extends State<SelectLecture> with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 2, vsync: this,);
  }

  @override
  Widget build(BuildContext context){
    ScreenUtil.init(context, designSize: const Size(390,844));
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 63.h,),
          appbar(),
          SizedBox(height: 18.h,),
          //content(),
        ],
      )
    );
  }

  Widget appbar(){
    return Row(
      children: [
        SizedBox(width: 16.w,),
        GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
        child: Image.asset("assets/images/ArrowLeft.png",width: 24.w,height: 24.h,),
        ),
        SizedBox(width: 125.w,),
        Text("찜한 강의",
        style: TextStyle(
          fontFamily: 'Spoqa Han Sans Neo',
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        )
      ],
    );
  }

  Widget content(){
    return Column(
      children: [
        Container(
          child: TabBar(
            tabs: [
              Container(
                height: 48.h,
                alignment: Alignment.center,
                child: Text(
                  "온라인",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    fontFamily: 'Spoqa Han Sans Neo',
                  ),
                ),
              ),
              Container(
                height: 48.h,
                alignment: Alignment.center,
                child: Text(
                  "오프라인",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    fontFamily: 'Spoqa Han Sans Neo',
                  ),
                ),
              )
            ],
            indicatorWeight: 4.0,
            indicator: ShapeDecoration(
              shape: UnderlineInputBorder(
                borderSide: BorderSide(color:mainColor)
              )
            ),
            controller: _tabController,
          ),
        ),
        /*Expanded(child:

        )*/
      ],
    );
  }


}
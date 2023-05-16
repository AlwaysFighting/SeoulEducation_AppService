import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class writed extends StatefulWidget{
  const writed({Key? key}):super(key:key);

  @override
  State<writed> createState() => _writedState();
}
class _writedState extends State<writed>{

  @override
  void initState(){
    super.initState();
    ScreenUtil.init(context);
  }

  @override
  Widget build(BuildContext context)
  {ScreenUtil.init(context, designSize: const Size(390,844));
  return Scaffold(
    body: Column(
      children: [
        SizedBox(height: 60.h,),
        appbar(),
      ],
    ),
  );
  }

  Widget appbar(){
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 56.h,
      child: Row(
        children: [
          SizedBox(width: 16.w,),
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Image.asset('assets/images/ArrowLeft.png',width: 24.w,height: 24.w,),
          ),
          SizedBox(width: 125.w,),
          Text("내가쓴글",
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

  /*Widget content(){
    return Container(
      child:
    );
  }*/
}
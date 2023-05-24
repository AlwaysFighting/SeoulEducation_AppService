import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:seoul_education_service/const/colors.dart';

class recentlecture extends StatefulWidget{
  final List<Map<String,dynamic>> lectureList;
  const recentlecture({Key? key, required this.lectureList}):super(key:key);

  @override
  State<recentlecture> createState() => _recentState();
}
class _recentState extends State<recentlecture> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children: [

        ],
      ),
    );
  }


  /*@override
  void initState() {
    super.initState();
    //ScreenUtil.init(context);
    setData();
    countSharedPreferencesData('title').then((count){
      setState(() {
        listcount = count;
      });
    });
  }
  
  void setData() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    try{
      *//*title = pref.getString('title');
      applystartday = pref.getString('startday');
      applyendday = pref.getString('endday');*//*
      List<String>? storedTitles= pref.getStringList('title');
      List<String>? storedStartDays= pref.getStringList('startday');
      List<String>? storedEndDays= pref.getStringList('endday');
      if (storedTitles != null && storedStartDays != null && storedEndDays != null) {
        setState(() {
          title = storedTitles;
          applystartday = storedStartDays;
          applyendday = storedEndDays;
        });
      }
    }catch(e){
      print("error");
    }
  }

  Future<int> countSharedPreferencesData(String dataKey) async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final keys = pref.getKeys();
    int count = 0;
    for(String key in keys)
      {
        String? value = pref.getString(key);
        if(value == dataKey){
          count++;
        }
      }
    return count;
  }
  

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844));
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 60.h,),
          appbar(),
          Expanded(child: content()),
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
              Navigator.pop(context);
            },
            child: Image.asset('assets/images/Const/ArrowLeft.png', width: 24.w, height: 24.w,),
          ),
          SizedBox(width: 125.w,),
          Text("최근본강의",
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
    return Scaffold(
      body: title.isEmpty ? Center(
        child: Text("아직없음"),
      ) : ListView.builder(
          itemCount: listcount,
          itemBuilder: (BuildContext context, int index){
            return GestureDetector(
              onTap: () {
                //세부강좌설명으로
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: lightBackgroundColor,
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("#신청가능  #무료",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: 'Spoqa Han Sans Neo',
                                    color: mainColor,
                                  )),
                              Spacer(),
                              GestureDetector(
                                onTap: ()async{
                                  //스크랩 기능으로
                                },
                                child: Image.asset("assets/images/Const/star_fill.png",width: 24,height: 24,),
                              ),

                            ],
                          ),
                          SizedBox(height: 8,),
                          Text("${title}",
                            style: TextStyle(
                              fontFamily: 'Spoqa Han Sans Neo',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),),
                          SizedBox(height: 14,),
                          Text("신청기간:${applystartday}~${applyendday}",
                            style: TextStyle(
                              fontFamily: 'Spoqa Han Sans Neo',
                              fontSize: 14.sp,
                              color: textColor2,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),


            );
            }),

    );
  }
*/
}
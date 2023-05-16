import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'const/navigation.dart';

/*void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Spoqa Han Sans Neo'),
      home: const Navigation(),
    ),
  );
}*/
void main(){
  runApp(const myapp());
}
class myapp extends StatelessWidget{
  const myapp({Key? key}) : super(key:key);
  @override
  Widget build(BuildContext context){
    return ScreenUtilInit(
      designSize: const Size(390,844),
        builder: (context, child){
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Navigation(),
            ),
          );
        });
  }
}

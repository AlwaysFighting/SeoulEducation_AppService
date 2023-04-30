import 'package:flutter/material.dart';
import 'package:seoul_education_service/logins/login/views/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return const LoginPage();
                }));
            // Obtain shared preferences.
            final SharedPreferences prefs = await SharedPreferences.getInstance();

            await prefs.remove('email');
            await prefs.remove('password');
          },
          child: Text("Logout"),
        ),
      ),
    );
  }
}

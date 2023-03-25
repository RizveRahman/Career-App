import 'package:career_app/jobs/jobs_screen.dart';
import 'package:career_app/loginpage/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserState extends StatelessWidget {
  const UserState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
      if(userSnapshot.data == null) {
        print('user is not logged in yet');
        return const LoginScreen();
      } else if(userSnapshot.hasData) {
        return const JobsScreen();
      } else if(userSnapshot.hasError) {
        return const Scaffold(
          body: Center(
            child: Text('An error has been occurred. Try again')),
          );
      }
      else if(userSnapshot.connectionState == ConnectionState.waiting) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),

          )
        );
      }
      return const Scaffold(
        body: Center(
          child: Text('Something went wrong'),
        ),
      );
    },);
  }
}

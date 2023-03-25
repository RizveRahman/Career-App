import 'package:career_app/Profile/profile_screen.dart';
import 'package:career_app/jobs/jobs_screen.dart';
import 'package:career_app/jobs/uploade_jobs.dart';
import 'package:career_app/search_company/search_company.dart';
import 'package:career_app/user_state.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarApp extends StatelessWidget {
  int indexNumber = 0;

  BottomNavigationBarApp({required this.indexNumber});
  
  void _logout(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Padding(padding: EdgeInsets.all(8),
            child: Icon(
              Icons.logout,
              color: Colors.white,
                size: 36,
            ),),

            Padding(padding: EdgeInsets.all(8),
              child: Text('Sign Out', style: TextStyle(
                color: Colors.white, fontSize: 28
              ),),),

          ],
        ),
        content: Text(
          'Do you want to Log Out?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.canPop(context) ? Navigator.pop(context) : null;
          }, child: Text('No', style: TextStyle(
            color: Colors.green, fontSize: 18
          ),)),
          TextButton(onPressed: (){
            _auth.signOut();
            Navigator.canPop(context) ? Navigator.pop(context) : null;
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => UserState()));

          }, child: Text('Yes', style: TextStyle(
              color: Colors.red, fontSize: 18
          ),))
        ],
      );
    });
  } // LogOut Function with button
  

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      animationDuration: Duration(
        milliseconds: 300,
      ),
      color: Colors.deepOrange.shade400,
      backgroundColor: Colors.blueAccent,
      buttonBackgroundColor: Colors.deepOrange.shade300,
      height: 50,
      index: indexNumber,
      items: const [
        Icon(
          Icons.list,
          size: 19,
          color: Colors.black,
        ),
        Icon(
          Icons.search,
          size: 19,
          color: Colors.black,
        ),
        Icon(
          Icons.add,
          size: 19,
          color: Colors.black,
        ),
        Icon(
          Icons.person,
          size: 19,
          color: Colors.black,
        ),

      ],

      onTap: (index) {
        {
          if (index == 0) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => JobsScreen()));
          } else if (index == 1) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => AllworkersScreen()));
          } else if (index == 2) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => UploadeJobes()));
          } else if (index == 3) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => Profile()));
          }
        }
      },
    );
  }
}

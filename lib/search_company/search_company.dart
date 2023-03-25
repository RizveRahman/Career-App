import 'package:flutter/material.dart';

import '../widgets/bottom_nav_bar.dart';

class AllworkersScreen extends StatefulWidget {
  const AllworkersScreen({Key? key}) : super(key: key);

  @override
  State<AllworkersScreen> createState() => _AllworkersScreenState();
}

class _AllworkersScreenState extends State<AllworkersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBarApp(indexNumber: 1),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Search'),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple.shade300, Colors.blueAccent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.2, 0.9],
                )),
          ),
        ),
      );
  }
}

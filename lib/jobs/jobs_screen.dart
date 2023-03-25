import 'package:career_app/search_company/search_job.dart';
import 'package:career_app/user_state.dart';
import 'package:career_app/widgets/bottom_nav_bar.dart';
import 'package:career_app/widgets/job_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../persistent/persistent.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({Key? key}) : super(key: key);

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String? jobCategoryFilter;

  _showTastCategoriesDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Text(
              'Job Category',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Persistent.jobCategoryList.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        jobCategoryFilter = Persistent.jobCategoryList[index];
                      });
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                      print(
                          'jobCategoryList[index], ${Persistent
                              .jobCategoryList[index]}');
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_right_outlined,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            Persistent.jobCategoryList[index],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
              TextButton(
                onPressed: () {
                  setState(() {
                    jobCategoryFilter = null;
                  });
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                  'Cancle Filter',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade300, Colors.blueAccent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.2, 0.9],
          )),
      child: Scaffold(
          bottomNavigationBar: BottomNavigationBarApp(indexNumber: 0),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple.shade300, Colors.blueAccent],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [0.2, 0.9],
                  )),
            ),
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(
                Icons.filter_list_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                _showTastCategoriesDialog(size: size);
              },
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreen()));
                  },
                  icon: const Icon(Icons.search_outlined))
            ],
          ),
          // body: StreamBuilder<QuerySnapshot<Map<Stream, dynamic>>>(
          //   stream: FirebaseFirestore.instance
          //       .collection('jobs')
          //       .where('jobCategory', isEqualTo: jobCategoryFilter)
          //       .where('recruitment', isEqualTo: true)
          //       .orderBy('createdAt', descending: false).snapshots(),
          //   builder: (context, AsyncSnapshot snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return const Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     }
          //     else if (snapshot.connectionState == ConnectionState.active) {
          //       if (snapshot.data?.docs.isEmpty == true) {
          //         return ListView.builder(
          //             itemCount: snapshot.data?.docs.lenght,
          //             itemBuilder: (BuildContext context, int index) {
          //               return JobWidget(
          //                   jobTitle: snapshot.data?.docs.length,
          //                   // jobDescription: jobDescription,
          //                   // jobId: jobId,
          //                   // uploadedBy: uploadedBy,
          //                   // userImage: userImage,
          //                   // name: name,
          //                   // recruitment: recruitment,
          //                   // email: email,
          //                   // location: location)
          //
          //         );
          //       }
          //     }
          //   },
          // )),
      ));
  }
}

// appBar: AppBar(
// title: Text('jobs Screen'),
// ),
// body: ElevatedButton(
// onPressed: () {
// auth.signOut();
// Navigator.canPop(context) ? Navigator.pop(context) : null;
// Navigator.pushReplacement(
// context, MaterialPageRoute(builder: (_) => UserState()));
// },
// child: Text('Logout'),
// ),

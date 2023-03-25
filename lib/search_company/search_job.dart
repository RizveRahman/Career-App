import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade300, Colors.blueAccent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Search Job Screen'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade300, Colors.blueAccent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.2, 0.9],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// import '../model/category.dart';
// import 'constants.dart';
// import 'details_screen.dart';
//
// // void main() => runApp(MyApp());
// //
// // class MyApp extends StatelessWidget {
// //   // This widget is the root of your application.
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: 'Course App',
// //       theme: ThemeData(),
// //       home: HomeScreen(),
// //     );
// //   }
// // }
//
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.only(left: 20, top: 50, right: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 SvgPicture.asset("assets/icons/menu.svg"),
//                 Image.asset("assets/images/user.png"),
//               ],
//             ),
//             SizedBox(height: 30),
//             Text("Hey Alex,", style: kHeadingextStyle),
//             Text("Find a course you want to learn", style: kSubheadingextStyle),
//             Container(
//               margin: EdgeInsets.symmetric(vertical: 30),
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//               height: 60,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Color(0xFFF5F5F7),
//                 borderRadius: BorderRadius.circular(40),
//               ),
//               child: Row(
//                 children: <Widget>[
//                   SvgPicture.asset("assets/icons/search.svg"),
//                   SizedBox(width: 16),
//                   Text(
//                     "Search for anything",
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Color(0xFFA0A5BD),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text("Category", style: kTitleTextStyle),
//                 Text(
//                   "See All",
//                   style: kSubtitleTextSyule.copyWith(color: kBlueColor),
//                 ),
//               ],
//             ),
//             SizedBox(height: 30),
//             Expanded(
//               child: StaggeredGridView.countBuilder(
//                 padding: EdgeInsets.all(0),
//                 crossAxisCount: 2,
//                 //itemCount: categories.length,
//                 crossAxisSpacing: 20,
//                 mainAxisSpacing: 20,
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => DetailsScreen(),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       padding: EdgeInsets.all(20),
//                       height: index.isEven ? 200 : 240,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         image: DecorationImage(
//                           image: AssetImage(categories[index].image),
//                           fit: BoxFit.fill,
//                         ),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(
//                             categories[index].name,
//                             style: kTitleTextStyle,
//                           ),
//                           Text(
//                             '${categories[index].numOfCourses} Courses',
//                             style: TextStyle(
//                               color: kTextColor.withOpacity(.5),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//                 staggeredTileBuilder: (index) => StaggeredTile.fit(1),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

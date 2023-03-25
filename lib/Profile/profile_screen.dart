import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../user_state.dart';
import '../widgets/bottom_nav_bar.dart';


class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Profile> {

  final user = FirebaseAuth.instance.currentUser!;
  void logOut() async{
    FirebaseAuth.instance.signOut();

    showDialog(context: context, builder: (context){
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
    Navigator.pop(context);
  } //LogOut Function

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
    return Scaffold(
      bottomNavigationBar: BottomNavigationBarApp(indexNumber: 3),
      backgroundColor: Colors.white.withOpacity(.94),
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            // user card

            Center(
              child: Text('Email: ${user.email!}',style: TextStyle(
                color: Colors.black
              ),),
            ),
            SizedBox(height: 10,),
            SettingsGroup(
              items: [
                SettingsItem(
                  onTap: () {},
                  icons: CupertinoIcons.pencil_outline,
                  iconStyle: IconStyle(),
                  title: 'Edit Profile',
                  subtitle: "Make changes",
                ),
                // SettingsItem(
                //   onTap: () {},
                //   icons: Icons.fingerprint,
                //   iconStyle: IconStyle(
                //     iconsColor: Colors.white,
                //     withBackground: true,
                //     backgroundColor: Colors.red,
                //   ),
                //   title: 'Privacy',
                //   subtitle: "Lock Ziar'App to improve your privacy",
                // ),
                SettingsItem(
                  onTap: () {},
                  icons: Icons.dark_mode_rounded,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.red,
                  ),
                  title: 'Dark mode',
                  subtitle: "Automatic",
                  trailing: Switch.adaptive(
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            SettingsGroup(
              items: [
                SettingsItem(
                  onTap: () {},
                  icons: Icons.info_rounded,
                  iconStyle: IconStyle(
                    backgroundColor: Colors.purple,
                  ),
                  title: 'About',
                  subtitle: "Learn more about Career App",
                ),
              ],
            ),
            // You can add a settings title
            SettingsGroup(
              settingsGroupTitle: "Account",
              items: [
                SettingsItem(
                  onTap: () {
                    setState(() {
                      _logout(context);
                    });
                  },
                  icons: Icons.exit_to_app_rounded,
                  title: "Sign Out",
                ),
                // SettingsItem(
                //   onTap: () {},
                //   icons: CupertinoIcons.repeat,
                //   title: "Change email",
                // ),
                SettingsItem(
                  onTap: () {},
                  icons: CupertinoIcons.delete_solid,
                  title: "Delete account",
                  titleStyle: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
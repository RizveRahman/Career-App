import 'package:cached_network_image/cached_network_image.dart';
import 'package:career_app/loginpage/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants/text_string.dart';
import '../services/global_var.dart';

class ForgetPassScreen extends StatefulWidget {


  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> with TickerProviderStateMixin{

  late Animation<double> _animation;
  late AnimationController _animationController;

  final FirebaseAuth _auth = FirebaseAuth.instance;


  final TextEditingController _forgetPassController = TextEditingController(text: '');

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   _animationController = AnimationController(vsync: this,
  //       duration: const Duration(seconds: 20));
  //   _animation =
  //   CurvedAnimation(parent: _animationController, curve: Curves.linear)
  //     ..addListener(() {
  //       setState(() {
  //
  //       });
  //     })
  //     ..addStatusListener((animationStatus) {
  //       if (animationStatus == AnimationStatus.completed) {
  //         _animationController.reset();
  //         _animationController.forward();
  //       }
  //     });
  //   _animationController.forward();
  //   super.initState();
  // }


  void _forgetPassSubmitForm() async {
    try{
      await _auth.sendPasswordResetEmail(email: _forgetPassController.text);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    } catch(error) {
      Fluttertoast.showToast(msg: error.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: loginUrlImage,
            placeholder: (context, url) =>
                Image.asset(
                  'assets/images/wallpaper.jpg',
                  fit: BoxFit.fill,
                ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            //alignment: FractionalOffset(_animation.value, 0),
          ),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              SizedBox(
                height: size.height * 0.1,
              ),
              const Text(
                'Forget password',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Signatra',
                  fontSize: 55,
                ),
              ),
              const SizedBox(height: 20,),
              const Text(
                'Email address',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: _forgetPassController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                  )
                ),
              ),

              const SizedBox(height: 20,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: (){
                  _forgetPassSubmitForm();
                },
                    child: Text(rResetPass.toUpperCase(),
                      style: TextStyle(
                          fontStyle: FontStyle.italic
                      ),
                    )),
              ),

            ],
          ),)
        ],
      ),
    );
  }
}

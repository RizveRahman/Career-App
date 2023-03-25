import 'package:cached_network_image/cached_network_image.dart';
import 'package:career_app/services/global_method.dart';
import 'package:career_app/services/global_var.dart';
import 'package:career_app/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/image_strings.dart';
import '../constants/sizes.dart';
import '../constants/text_string.dart';
import '../forget_pass_screen/forget_pass.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  final FocusNode _passFocusNode = FocusNode();
  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailTextController = TextEditingController(
      text: '');
  final TextEditingController _passTextController = TextEditingController(
      text: '');
  bool _obsText = true;
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _animationController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }


  @override
  void initState() {
    _animationController = AnimationController(vsync: this,
        duration: const Duration(seconds: 20));
    _animation =
    CurvedAnimation(parent: _animationController, curve: Curves.linear)
      ..addListener(() {
        setState(() {

        });
      })
      ..addStatusListener((animationStatus) {
        if (animationStatus == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
        }
      });
    _animationController.forward();
    super.initState();
  }

  void _submitFormLogin() async {
    final isValid = _loginFormKey.currentState!.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.signInWithEmailAndPassword(
            email: _emailTextController.text.trim().toUpperCase(),
            password: _passTextController.text.trim());
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
        print('error occurred $error');
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            Container(
              color: Colors.black54,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
                child: ListView(
                  children: [
                    Padding(padding: const EdgeInsets.only(left: 80, right: 80),
                      child: Image.asset('assets/images/login.png'),),
                    const SizedBox(height: 15,),
                    Form(
                      key: _loginFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () =>
                                FocusScope.of(context)
                                    .requestFocus(_passFocusNode),
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailTextController,
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Please enter a valid Email address';
                              }
                              else {
                                return null;
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),),

                            ),
                          ),

                          TextFormField(
                            textInputAction: TextInputAction.next,
                            focusNode: _passFocusNode,
                            keyboardType: TextInputType.visiblePassword,
                            controller: _passTextController,
                            obscureText: !_obsText,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 7) {
                                return 'Please enter a validated password';
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obsText = !_obsText;
                                  });
                                },
                                child: Icon(
                                  _obsText ? Icons.visibility : Icons
                                      .visibility_off, color: Colors.white,
                                ),
                              ),
                              hintText: 'Password',
                              hintStyle: const TextStyle(color: Colors.white),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),),
                            ),
                          ),

                          const SizedBox(height: 15,),

                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                        builder: (context) => ForgetPassScreen())
                                );
                              },
                              child: const Text('Forget Password?', style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontStyle: FontStyle.italic,
                              ),),
                            ),

                          ),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(onPressed: _submitFormLogin,
                                child: Text(rLogin.toUpperCase())),
                          ),

                          const SizedBox(height: 20,),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                            },
                            child: const Text.rich(TextSpan(
                                text: rDontHaveAccount,
                                style: TextStyle(color: Colors.white),
                                children: [
                                  TextSpan(
                                      text: rSignUp,
                                      style: TextStyle(color: Colors.blue))
                                ])),
                          ),

                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Text("OR"),
                          // SizedBox(
                          //   width: double.infinity,
                          //   child: OutlinedButton.icon(
                          //       icon: Image(
                          //         image: AssetImage(googleLogo),
                          //         width: 20,
                          //       ),
                          //       onPressed: () {},
                          //       label: Text(rSignInGoogle)),
                          // ),
                          // SizedBox(
                          //   height: rFormHeight - 20,
                          // ),

                      //   ],
                      // ),

                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),

    );
  }
}

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:career_app/loginpage/login_screen.dart';
import 'package:career_app/services/global_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/text_string.dart';
import '../services/global_var.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  final TextEditingController _fullNameController =
      TextEditingController(text: '');
  final TextEditingController _emailTextController =
      TextEditingController(text: '');
  final TextEditingController _passTextController =
      TextEditingController(text: '');
  final TextEditingController _phoneTextController =
      TextEditingController(text: '');
  final TextEditingController _locationTextController =
      TextEditingController(text: '');

  final _signupFormKey = GlobalKey<FormState>();
  File? imageFile;

  bool _obsText = true;
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _phoneNoFocusNode = FocusNode();
  final FocusNode _positionFocusNode = FocusNode();
  String? imageUrl;

  // @override
  // void initState() {
  //   _animationController =
  //       AnimationController(vsync: this, duration: const Duration(seconds: 20));
  //   _animation =
  //       CurvedAnimation(parent: _animationController, curve: Curves.linear)
  //         ..addListener(() {
  //           setState(() {});
  //         })
  //         ..addStatusListener((animationStatus) {
  //           if (animationStatus == AnimationStatus.completed) {
  //             _animationController.reset();
  //             _animationController.forward();
  //           }
  //         });
  //   _animationController.forward();
  //   super.initState();
  // }

  @override
  void dispose() {
    _animationController.dispose();
    _fullNameController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _phoneTextController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _phoneNoFocusNode.dispose();
    _positionFocusNode.dispose();
    super.dispose();
  }

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Please choose an option'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _getFromCamera();
                  },
                  child: Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.camera,
                            color: Colors.purple,
                          )),
                      Text(
                        'Camera',
                        style: TextStyle(color: Colors.purple),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    _getFromGallery();
                  },
                  child: Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.image,
                            color: Colors.purple,
                          )),
                      Text(
                        'Gallery',
                        style: TextStyle(color: Colors.purple),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _getFromCamera() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImg(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImg(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImg(filePath) async {
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);

    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  void _submitFormSignUp() async {
    final isValid = _signupFormKey.currentState!.validate();
    if (isValid) {
      if (imageFile == null) {
        GlobalMethod.showErrorDialog(
            error: 'Please pick an image', ctx: context);
        return;
      }
      setState(() {
        _isLoading = true;
      });

      try {
        await _auth.createUserWithEmailAndPassword(
            email: _emailTextController.text.trim().toLowerCase(),
            password: _passTextController.text.trim());
        final User? user = _auth.currentUser;
        final _uid = user!.uid;
        final ref = FirebaseStorage.instance
            .ref()
            .child('UserImages')
            .child('$_uid.jpg');//uid + '.jpg'
        await ref.putFile(imageFile!);
        imageUrl = await ref.getDownloadURL();
        FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'id': _uid,
          'name': _fullNameController.text,
          'email': _emailTextController.text,
          'userImage': imageUrl,
          'phoneNumber': _phoneTextController.text,
          'location': _locationTextController.text,
          'createdAt': Timestamp.now(),
        });
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: signupUrlImage,
            placeholder: (context, url) => Image.asset(
              'assets/images/wallpaper.jpg',
              fit: BoxFit.fill,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
            //alignment: FractionalOffset(_animation.value, 0),
          ),
          Container(
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
              child: ListView(
                children: [
                  Form(
                    key: _signupFormKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showImageDialog();
                          },
                          child: Container(
                            width: size.width * 0.24,
                            height: size.width * 0.24,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    width: 1, color: Colors.cyanAccent)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: imageFile == null
                                  ? const Icon(
                                      Icons.camera_enhance_sharp,
                                      color: Colors.cyan,
                                      size: 30,
                                    )
                                  : Image.file(
                                      imageFile!,
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_emailFocusNode),
                          keyboardType: TextInputType.name,
                          controller: _fullNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'This Field is missing';
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Name',
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_passFocusNode),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailTextController,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Please enter a valid Email address';
                            } else {
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
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_phoneNoFocusNode),
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
                                _obsText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                            ),
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.white),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_positionFocusNode),
                          keyboardType: TextInputType.phone,
                          controller: _phoneTextController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Phone Number is missing';
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Phone Number',
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_positionFocusNode),
                          keyboardType: TextInputType.text,
                          controller: _locationTextController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'This Field id missing';
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Address',
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        _isLoading
                            ? Center(
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () {
                                      _submitFormSignUp();
                                    },
                                    child: Text(rSignUp.toUpperCase())),
                              ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Text.rich(TextSpan(
                              text: rAlreadyHaveAccount,
                              style: TextStyle(color: Colors.white),
                              children: const [
                                TextSpan(
                                    text: rLogin,
                                    style: TextStyle(color: Colors.blue))
                              ])),
                        ),
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

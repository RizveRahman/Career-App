import 'package:career_app/persistent/persistent.dart';
import 'package:career_app/services/global_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import '../services/global_var.dart';
import '../widgets/bottom_nav_bar.dart';

class UploadeJobes extends StatefulWidget {

  @override
  State<UploadeJobes> createState() => _UploadeJobesState();
}

class _UploadeJobesState extends State<UploadeJobes> {

 final TextEditingController _jobCategoryController = TextEditingController(
    text: 'Select Job Category'
  );
 final TextEditingController _jobTitleController = TextEditingController();
 final TextEditingController _jobDeadlineController = TextEditingController( text: 'Job Deadline Date');
 final TextEditingController _jobDescriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  DateTime? picked;
  Timestamp? deadLineDateStamp;

  Widget _textTitles({required String lebel}){
    return Padding(padding: const EdgeInsets.all(5),
    child: Text(
      lebel,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    );
  }

  Widget _textFormFields({
    required String valueKey,
    required TextEditingController controller,
    required bool enabled,
    required Function fct,
    required int maxLenght,
}){
    return Padding(padding: const EdgeInsets.all(5),
    child: InkWell(
      onTap: (){
        fct();
      },
      child: TextFormField(
        validator: (value){
          if(value!.isEmpty){
            return 'Value is missing';
        }
        return null;
        },
        controller: controller,
        enabled: enabled,
        key: ValueKey(valueKey),
        style: const TextStyle(
    color: Colors.white,
      ),
        maxLines: valueKey == 'JobDescription' ? 2 : 1,
        maxLength: maxLenght,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.black54,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),

          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red),

          ),
        ),
    ),
    )
    );
  }


  _showTastCategoriesDialog({required Size size}) {
    showDialog(context: context, builder: (ctx) {
      return AlertDialog(
        backgroundColor: Colors.black54,
        title: Text(
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
                onTap: (){
                  setState(() {
                    _jobCategoryController.text = Persistent.jobCategoryList[index];
                  });
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.arrow_right_outlined,color: Colors.grey,),
                    Padding(padding: EdgeInsets.all(8),
                    child: Text(
                      Persistent.jobCategoryList[index],
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),)
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () {
            Navigator.canPop(context) ? Navigator.pop(context) : null;
          }, child: Text('Cancle', style: TextStyle(
            color: Colors.white,
            fontSize: 16
          ),))
        ],
      );
    }
    );
  }

  void _pickDateDialog() async {
    picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(
          Duration(days: 0),
        ), lastDate: DateTime(2100),
    );
    if(picked!= null){
      setState(() {
        _jobDeadlineController.text = '${picked!.year} - ${picked!.month} - ${picked!.day}';
        deadLineDateStamp = Timestamp.fromMicrosecondsSinceEpoch(
          picked!.microsecondsSinceEpoch
        );
      });
    }
  }
  void _uploadeTask() async {
    final jobIb = Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final _uid = user!.uid;
    final isValid = _formKey.currentState!.validate();

    if(isValid) {
      if(_jobDeadlineController.text == 'Choose job Deadline date' || _jobCategoryController.text == 'Choose job category'){
        GlobalMethod.showErrorDialog(error: 'Please pick everything', ctx: context);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try{
        await FirebaseFirestore.instance.collection('jobs').doc(jobIb).set({
          'jobId' : jobIb,
          'uploadedBy' : _uid,
          'email' : user.email,
          'jobTitle' : _jobTitleController.text,
          'jobDescription' : _jobDescriptionController.text,
          'deadLineDate' : _jobDeadlineController.text,
          'deadLineDateTimeStamp' : deadLineDateStamp,
          'jobCategory' : _jobCategoryController.text,
          'jobComments' : [],
          'recruitment' : true,
          'createdAt' : Timestamp.now(),
          'name' : name,
          'userImage' : userImage,
          'location' : location,
          'applicants' : 0,
        });
        await Fluttertoast.showToast(
          msg: 'The tast has been uploaded',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.grey,
          fontSize: 18.0,
        );
        _jobTitleController.clear();
        _jobDescriptionController.clear();
        setState(() {
          _jobCategoryController.text = 'Choose job category';
          _jobDeadlineController.text = 'Choose job Deadline date';
        });
      } catch(error) {
        {
          setState(() {
            _isLoading = false;
          });
          GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
        }
      }
      finally{
        setState(() {
          _isLoading = false;
        });
      }
    }
    else{
      print('It\'s not valid');
    }
  }


 @override
  void dispose() {
    super.dispose();
    _jobDeadlineController.dispose();
    _jobCategoryController.dispose();
    _jobTitleController.dispose();
    _jobDescriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade300, Colors.blueAccent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: const [0.2, 0.9],
          )),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarApp(indexNumber: 2),
        backgroundColor: Colors.transparent,
        // appBar: AppBar(
        //   title: const Text('Uploade Jobs Now '),
        //   centerTitle: true,
        //   flexibleSpace: Container(
        //     decoration: BoxDecoration(
        //         gradient: LinearGradient(
        //           colors: [Colors.deepPurple.shade300, Colors.blueAccent],
        //           begin: Alignment.centerLeft,
        //           end: Alignment.centerRight,
        //           stops: const [0.2, 0.9],
        //         )),
        //   ),
        // ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Card(
              color: Colors.white10,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8,),
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          'Please fill all fields',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            //fontFamily: 'Signatra'
                            fontFamily: 'San Francisco'
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5,),
                    const Divider(
                      thickness: 1,
                    ),
                    Padding(padding: const EdgeInsets.all(5),

                    // job Posting Form ----------------------///
                    child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _textTitles(lebel: 'Job Category :'),
                            _textFormFields(
                                valueKey: 'JobCategory',
                                controller: _jobCategoryController,
                                enabled: false,
                                fct: (){
                                  _showTastCategoriesDialog(size: size);
                                },
                                maxLenght: 100,
                            ),
                            _textTitles(lebel: 'Job Title'),
                            _textFormFields(valueKey: 'JobTitle',
                                controller: _jobTitleController,
                                enabled: true,
                                fct: (){},
                                maxLenght: 100),
                            _textTitles(lebel: 'Job Description :'),
                            _textFormFields(valueKey: 'JobDescription',
                                controller: _jobDescriptionController,
                                enabled: true,
                                fct: (){},
                                maxLenght: 100),
                            _textTitles(lebel: 'Job Deadline Date :'),
                            _textFormFields(valueKey: 'Deadline',
                                controller: _jobDeadlineController,
                                enabled: false,
                                fct: (){
                              _pickDateDialog();
                                },
                                maxLenght: 100),
                          ],
                        )),
                    ),

                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: _isLoading
                            ?
                        const CircularProgressIndicator()
                            :
                        MaterialButton(onPressed: (){
                          _uploadeTask();
                        },
                        color: Colors.black,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Post Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                                SizedBox(width: 6,),
                                Icon(
                                  Icons.upload_file,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        )
                        ),
                      ),


                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

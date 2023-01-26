import 'dart:io';
import 'package:charusatsocial/AuthenticationScreen/Auth.dart';
import 'package:charusatsocial/AuthenticationScreen/components/common/custom_form_button.dart';
import 'package:charusatsocial/AuthenticationScreen/components/common/custom_input_field.dart';
import 'package:charusatsocial/AuthenticationScreen/components/common/page_header.dart';
import 'package:charusatsocial/AuthenticationScreen/components/common/page_heading.dart';
import 'package:charusatsocial/AuthenticationScreen/components/login_page.dart';
import 'package:charusatsocial/Model/UserModel.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

const khintstyle = TextStyle(color: Colors.white, fontFamily: 'reggae', fontSize: 19, fontWeight: FontWeight.w300);

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController Department = TextEditingController();
  TextEditingController PhoneNumber = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  checkFields() {
    final form = _formkey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  String? validateEmail(String value) {
    final regex = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  bool _obscureText = true;
  File? _profileImage;
  final _signupFormKey = GlobalKey<FormState>();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future createaccount(String email, password, username, age, phoneNumber) async {
    final result = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    if (result.user != null) {
      await saveuser(UserModel(
        phoneNumber: phoneNumber,
        username: username,
        password: password,
        age: age,
        id: result.user!.uid,
        email: email,
        bio: "",
        followers: {},
        following: {},
        photoUrl: '',
      ));
      return true;
    }
  }

  Future saveuser(UserModel user) async {
    usercollection.doc(user.id).set(user.toMap());
    return true;
  }

  Future _pickProfileImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;

      final imageTemporary = File(image.path);
      setState(() => _profileImage = imageTemporary);
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEEF1F3),
        body: SingleChildScrollView(
          child: Form(
            key: _signupFormKey,
            child: Column(
              children: [
                const PageHeader(),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20),),
                  ),
                  child: Column(
                    children: [
                      const PageHeading(title: 'Sign-up',),
                      SizedBox(
                        width: 130,
                        height: 130,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: _pickProfileImage,
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade400,
                                      border: Border.all(color: Colors.white, width: 3),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_sharp,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16,),
                      CustomInputField(
                          value: (values) {
                            username.text = values!;
                          },
                          labelText: 'Name',
                          hintText: 'Your name',
                          isDense: true,
                          validator: (textValue) {
                            if(textValue == null || textValue.isEmpty) {
                              return 'Name field is required!';
                            }
                            return null;
                          }
                      ),
                      const SizedBox(height: 16,),
                      CustomInputField(
                        value: (values) {
                          age.text = values!;
                        },
                          labelText: 'Age',
                          hintText: 'Your Age',
                          isDense: true,
                          validator: (textValue) {
                            if(textValue == null || textValue.isEmpty) {
                              return 'Age field is required!';
                            }
                            return null;
                          }
                      ),
                      const SizedBox(height: 16,),
                      CustomInputField(
                        value: (values) {
                          Department.text = values!;
                        },
                          labelText: 'Department',
                          hintText: 'Your Department (DEPSTAR, CSPIT, PDPIAS)',
                          isDense: true,
                          validator: (textValue) {
                            if(textValue == null || textValue.isEmpty) {
                              return 'Department is required!';
                            }
                            return null;
                          }
                      ),
                      CustomInputField(
                        value: (values){
                          email.text = values!;
                        },
                          labelText: 'Email',
                          hintText: 'Your email id',
                          isDense: true,

                          validator: (textValue) {
                            if(textValue == null || textValue.isEmpty) {
                              return 'Email is required!';
                            }

                            return null;
                          }
                      ),
                      const SizedBox(height: 16,),
                      CustomInputField(
                        value: (values){
                          PhoneNumber.text = values!;
                        },
                          labelText: 'Contact no.',
                          hintText: 'Your contact number',
                          isDense: true,
                          validator: (textValue) {
                            if(textValue == null || textValue.isEmpty) {
                              return 'Contact number is required!';
                            }
                            return null;
                          },
                      ),
                      const SizedBox(height: 16,),
                      CustomInputField(
                        value: (values) {
                          password.text = values!;
                        },
                        labelText: 'Password',
                        hintText: 'Your password',
                        isDense: true,
                        obscureText: true,
                        validator: (textValue) {
                          if(textValue == null || textValue.isEmpty) {
                            return 'Password is required!';
                          }
                          return null;
                        },
                        suffixIcon: true,
                      ),
                      const SizedBox(height: 22,),
                      CustomFormButton(innerText: 'Signup', onPressed: ()=> createaccount(email.text, password.text, username.text, age.text, PhoneNumber.text)),
                      const SizedBox(height: 18,),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Already have an account ? ', style: TextStyle(fontSize: 13, color: Color(0xff939393), fontWeight: FontWeight.bold),),
                            GestureDetector(
                              onTap: () => {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()))
                              },
                              child: const Text('Log-in', style: TextStyle(fontSize: 15, color: Color(0xff748288), fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


final kboxdecoration = BoxDecoration(
  color: Color(0xFF383838),
  borderRadius: BorderRadius.circular(20),
  boxShadow: [
    BoxShadow(
      offset: Offset(0, 4),
      color: Colors.white,
      blurRadius: 2.0,
    ),
  ],
);
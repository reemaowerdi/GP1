import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read_me_a_story/book_home.dart';
import 'package:read_me_a_story/home.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var signUPFormKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  String errorMessage = '';

  bool isRegisteringIn = false;

  @override
  void initState() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = Get.size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffB64F3D),
    body: Container(
    decoration: const BoxDecoration(
    image: DecorationImage(
    image: AssetImage("assets/images/home101.jpeg"),
    fit: BoxFit.cover,
    ),
    ),
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.1,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.white,
                        size: 35,
                      ),
                      onPressed: () async {
                        Get.back();
                      }, //not working yet
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Form(
                key: signUPFormKey,
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 50,
                    left: 30,
                    right: 30,
                  ),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xfffff8ee),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: ListView(
                    children: [
                      const Text(
                        "Hello,",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        "Please register to continue",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please provide a name';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text(
                            'Name',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please provide an email';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please provide password';
                          } else {
                            return null;
                          }
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                          label: Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please provide confrim password';
                          } else if (value != passwordController.text) {
                            return 'Passwords do not match';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text(
                            'Confirm Password',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isRegisteringIn = true;
                          });
                          try {
                            if (signUPFormKey.currentState!.validate()) {
                              final userCredentials = await FirebaseAuth
                                  .instance
                                  .createUserWithEmailAndPassword(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );

                              if (userCredentials.user != null) {
                                await userCredentials.user!.updateDisplayName(
                                  nameController.text.trim(),
                                );
                              }

                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => Home(),
                              ));
                            }
                          } catch (e) {
                            setState(() {
                              errorMessage = e.toString();
                            });
                          }
                          setState(() {
                            isRegisteringIn = false;
                          });
                        },
                        child: isRegisteringIn
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              )
                            : Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              100,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        errorMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 16,
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Already have an account! Plesae Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              // color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ),
    );
  }
}

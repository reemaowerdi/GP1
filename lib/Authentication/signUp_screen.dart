import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:read_me_a_story/book_home.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var signUPFormKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  String errorMessage = '';

  bool isRegisteringIn = false;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/home111.PNG"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 30,
                right: 30,
                top: 70,
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_left_rounded,
                      color: Color.fromARGB(255, 252, 251, 251),
                      size: 35,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Spacer(),
                ],
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Hello,",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        "Please register to continue",
                        style: TextStyle(
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(
                        height: 32,
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
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => BooksHome(),
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
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 32,
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
    );
  }
}

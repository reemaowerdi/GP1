import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:read_me_a_story/Authentication/signIn_screen.dart';
import 'package:read_me_a_story/book_home.dart';
import 'package:read_me_a_story/home.dart';

class BooksSplash extends StatelessWidget {
  const BooksSplash({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: size.width * 0.45,
            height: double.infinity,
            color: Color(0xFFFFF8EE),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: size.height * .2,
                  child: Image.asset('assets/images/logo.png'),
                ),
                const Text(
                  "Read\nme\na Story",
                  style: TextStyle(
                    height: 1.5,
                    letterSpacing: 2,
                    color: Color(0xffc44536),
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(

            width: size.width * 0.55,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/home101.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
            // backgroundColor: const Color(0xFFFFC009),
          ),
        ],
      ),
      floatingActionButton: Container(
        //next button
        margin: EdgeInsets.all(16),
        height: 50,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color(0xfffff8ee),
        ),
        child: IconButton(
          //next button
          icon: const Icon(
            Icons.navigate_next,
            color: Color(0xffc44536),
            size: 30,
          ),
          onPressed: () => Navigator.push(
            // to navigate
            context,
            MaterialPageRoute(
              builder: (context) => StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    return snapshot.hasData ? Home() : SignInScreen();
                  }),
            ),
          ),
        ),
      ),
    );
  }
}

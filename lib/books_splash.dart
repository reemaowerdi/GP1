import 'package:flutter/material.dart';
import 'package:read_me_a_story/book_home.dart';

class BooksSplash extends StatelessWidget {
  const BooksSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //background of first page
        alignment: Alignment.centerRight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/firstpage.JPG",
            ),
            fit: BoxFit.cover, //to fit the page
          ),
        ),
        child: Container(
          //alignment of text in first page
          padding: const EdgeInsets.only(
            left: 160,
          ),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color(0xffc44536), //the rectangle
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "read\nme\na Story",
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
      ),
      floatingActionButton: Container(
        //next button
        margin: EdgeInsets.all(40),
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
                builder: (context) => BooksHome(),
              )),
        ),
      ),
    );
  }
}

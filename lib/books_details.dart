import 'package:flutter/material.dart';
import 'package:read_me_a_story/book_read.dart';

import 'book_model.dart';

class BooksDetails extends StatelessWidget {
  final Book book;

  const BooksDetails({super.key, required this.book}); //page of book cover
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffff8ee),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            SafeArea(
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      //book details page layout
                      padding: EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 20,
                      ),
                      child: Row(
                        //alighnment of buttons
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            //back arrow on book details
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 35,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          IconButton(
                            //fav button
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.black,
                              size: 35,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 30,
                      ),
                      height: MediaQuery.of(context).size.height *
                          0.30, //size of cover
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Stack(
                        children: [
                          Container(
                            //dec of book cover
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 25,
                                  offset: Offset(8, 8),
                                  spreadRadius: 3,
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 25,
                                  offset: Offset(-8, -8),
                                  spreadRadius: 3,
                                )
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                "assets/images/booksphoto.webp",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Container(
                            // dec of book cover
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.3),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      //book title
                      book.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      //the rec
                      margin: EdgeInsets.all(24),
                      height: 8,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Color(0xffc44536),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    Expanded(
                      //story under cover book
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(
                            top: 10,
                            left: 40,
                            right: 20,
                          ),
                          child: Text(
                            book.content, //to retrieve story
                            style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 1.5,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              //position of read, listen buttons
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                    colors: [
                      Color(0xfffff8ee).withOpacity(0.1),
                      Colors.white.withOpacity(0.3),
                      Color(0xfffff8ee).withOpacity(0.7),
                      Color(0xfffff8ee).withOpacity(0.8),
                      Color(0xfffff8ee),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Row(
                    //at the middle
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        //listen and read button shape
                        width: 150,
                        height: 60,
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color(0xffc44536),
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.push(
                            //to navigate and read content
                            context,
                            MaterialPageRoute(
                              builder: (context) => BooksRead(
                                book: book,
                              ),
                            ),
                          ),
                          child: Text(
                            "READ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 150,
                        height: 60,
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color(0xffc44536),
                        ),
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "LISTEN",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 28,
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

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:read_me_a_story/books_profile.dart';
import 'book_model.dart';
import 'books_details.dart';

class BooksHome extends StatelessWidget {
  BooksHome({super.key});

  final sections = [
    "Brave",
    "Friendship",
    "Respect",
    "Honesty",
    "Patience",
  ];

  @override
  Widget build(BuildContext context) {
    //morals list page
    return Scaffold(
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
              //back button display
              padding: EdgeInsets.only(
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
                      Navigator.of(context).pop(); // to navigate
                    },
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 35,
                    ),
                    onPressed: () {}, //not working yet
                  ),
                ],
              ),
            ),
            Expanded(
              //box that has the morals
              child: Container(
                padding: EdgeInsets.only(
                  top: 50,
                  left: 30,
                  right: 30,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xfffff8ee),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello,",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Fahda",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      //the rectangle
                      margin: EdgeInsets.only(
                        top: 15,
                      ),
                      width: 100,
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color(0xffc44536),
                      ),
                    ),
                    Expanded(
                      //morals
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          //to fit grid layouts
                          crossAxisCount: 2,
                          childAspectRatio: 2,
                        ),
                        itemCount: sections.length, //grid
                        itemBuilder: (context, index) => Card(
                          elevation: 0,
                          color: Color.fromARGB(255, 235, 222, 204),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          child: InkWell(
                            //to go to the books list

                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BookSection(scetion: sections[index]),
                                ),
                              );
                            },

                            child: Center(
                              child: Text(
                                sections[index],
                                style: TextStyle(
                                  //text of morals in grid
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BookSection extends StatelessWidget {
  final String scetion;
  const BookSection({super.key, required this.scetion});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            //layout in book section
            padding: const EdgeInsets.only(
              top: 75,
              right: 30,
            ),
            child: Row(
              children: [
                IconButton(
                  // back button, books list
                  icon: Icon(
                    Icons.keyboard_arrow_left_rounded,
                    color: Color.fromARGB(255, 1, 1, 1),
                    size: 35,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Text(
                  scetion, //moral name
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            //to add the book from firebase to list of books
            child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('books')
                  .where(
                    'moral',
                    isEqualTo: scetion,
                  )
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                return snapshot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator.adaptive())
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          mainAxisExtent: 340,
                        ),
                        padding: EdgeInsets.all(8),
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          final Book book = Book.fromMap(
                              snapshot.data?.docs[index].data()
                                  as Map<String, dynamic>);
                          return BookCover(book: book);
                        });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BookCover extends StatelessWidget {
  final Book book;
  const BookCover({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => BooksDetails(
            //to add the content in books details page
            book: book,
          ),
        ),
      ),
      child: Column(
        //books list
        children: [
          SizedBox(
            child: Card(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/booksphoto.webp', //on books list
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Padding(
            //books title
            padding: const EdgeInsets.all(8),
            child: Text(
              book.title,
              maxLines: 3,
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

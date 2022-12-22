import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:read_me_a_story/book_home.dart';
import 'package:read_me_a_story/book_model.dart';

class FavouratesScreen extends StatelessWidget {
  const FavouratesScreen({Key? key}) : super(key: key);

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
                    Navigator.of(context).pop(); //ws context?
                  },
                ),
                Text(
                  'Favourite Books', //moral name
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            //to add the book from firebase to list of books, right?
            child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('books')
                  .where(
                    'favouritesByIds',
                    arrayContains: FirebaseAuth.instance.currentUser!.uid,
                  )
                  .get(),
              builder: (BuildContext context, //ws context?
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                //wist 214-229
                return snapshot.connectionState ==
                        ConnectionState.waiting //if the connection is waiting
                    ? Center(
                        child: CircularProgressIndicator
                            .adaptive()) // waiting circle
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          mainAxisExtent: 340,
                        ),
                        padding: EdgeInsets.all(8),
                        itemCount: snapshot.data?.docs.length, //list of docs
                        itemBuilder: (context, index) {
                          final Book book = Book.fromMap(//u
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

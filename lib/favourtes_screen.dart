import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:read_me_a_story/book_home.dart';
import 'package:read_me_a_story/book_model.dart';
import 'package:read_me_a_story/main.dart';

class FavouratesScreen extends StatefulWidget {
  const FavouratesScreen({Key? key}) : super(key: key);

  @override
  State<FavouratesScreen> createState() => _FavouratesScreenState();
}

class _FavouratesScreenState extends State<FavouratesScreen> {
  @override
  Widget build(BuildContext context) {
    List<String> onlineFavouritesBooks = [];
    final String localStorageIdIdentifier =
        FirebaseAuth.instance.currentUser?.uid ?? 'favourites';
    var favourites = prefs.getStringList(
      localStorageIdIdentifier,
    );
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            //layout in book section
            padding: const EdgeInsets.only(
              top: 75,
              right: 8,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Favourites', //moral name
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: Icon(Icons.replay_outlined)),
                SizedBox(
                  width: 8,
                ),
                TextButton.icon(
                  onPressed: () {
                    prefs.setStringList(
                      localStorageIdIdentifier,
                      onlineFavouritesBooks,
                    );
                  },
                  icon: Icon(Icons.download),
                  label: Text(
                    'Save Offline',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            //to add the book from firebase to list of books, right?
            child: FutureBuilder(
              future: Connectivity().checkConnectivity(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return snapshot.connectionState == ConnectionState.waiting
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : (snapshot.data == ConnectivityResult.none)
                        ? favourites != null
                            ? GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  mainAxisExtent: 340,
                                ),
                                padding: EdgeInsets.all(8),
                                itemCount: favourites.length, //list of docs
                                itemBuilder: (context, index) {
                                  final Book book =
                                      Book.fromJson(favourites[index]);

                                  return BookCover(book: book);
                                },
                              )
                            : Container(
                                child: Center(
                                    child: Text(
                                  'No books found',
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                )),
                              )
                        : FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('books')
                                .where(
                                  'favouritesByIds',
                                  arrayContains:
                                      FirebaseAuth.instance.currentUser!.uid,
                                )
                                .get(),
                            builder: (BuildContext context, //ws context?
                                AsyncSnapshot<
                                        QuerySnapshot<Map<String, dynamic>>>
                                    snapshot) {
                              //wist 214-229
                              return snapshot.connectionState ==
                                      ConnectionState
                                          .waiting //if the connection is waiting
                                  ? Center(
                                      child: CircularProgressIndicator
                                          .adaptive()) // waiting circle
                                  : GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 200,
                                        mainAxisExtent: 340,
                                      ),
                                      padding: EdgeInsets.all(8),
                                      itemCount: snapshot
                                          .data?.docs.length, //list of docs
                                      itemBuilder: (context, index) {
                                        final Book book = Book.fromMap(
                                          //u
                                          snapshot.data?.docs[index].data()
                                              as Map<String, dynamic>,
                                        ).copyWith(
                                          id: snapshot.data?.docs[index].id,
                                        );

                                        onlineFavouritesBooks
                                            .add(book.toJson());

                                        return BookCover(book: book);
                                      });
                            },
                          );
              },
            ),
          ),
        ],
      ),
    );
  }
}

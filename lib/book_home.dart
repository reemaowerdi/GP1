import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:read_me_a_story/book_read.dart';
import 'package:read_me_a_story/books_splash.dart';
import 'package:read_me_a_story/home_controller.dart';

import 'book_model.dart';

class BooksHome extends StatefulWidget {
  BooksHome({super.key});

  @override
  State<BooksHome> createState() => _BooksHomeState();
}

class _BooksHomeState extends State<BooksHome> {
  final sections = [
    "Brave",
    "Friendship",
    "Respect",
    "Honesty",
    "Patience",
  ];

  final Size size = Get.size;

  final HomeController _bookReadController = Get.put(HomeController());

  @override
  void initState() {
    _bookReadController.getBookMarks();
    super.initState();
  }

  List<Book> bookMarks = [];

  @override
  Widget build(BuildContext context) {
    // final String bookStorageIdentifier =
    //     '${FirebaseAuth.instance.currentUser?.uid}bookMark';
    // var bookMarksJson = prefs.getStringList(
    //   bookStorageIdentifier,
    // );
    //
    // for (var element in bookMarksJson ?? []) {
    //   bookMarks.add(Book.fromJson(element));
    // }

    return Obx(() {
      bookMarks = _bookReadController.bookMarks.value;
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        RawMaterialButton(
                          onPressed: () {},
                          elevation: 2.0,
                          fillColor: Colors.white,
                          child: Icon(
                            Icons.refresh_outlined,
                            color: Colors.orange,
                            size: 35,
                          ),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                          // onPressed: () async {
                          //   setState(() {});
                          // }, //not working yet
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        RawMaterialButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Get.offAll(() => BooksSplash());
                          }, //not working yet
                          elevation: 2.0,
                          fillColor: Colors.white,
                          child: Icon(
                            Icons.logout,
                            color: Colors.orange,
                            size: 35,
                          ),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                          // onPressed: () async {
                          //   await FirebaseAuth.instance.signOut();
                          //   Get.offAll(() => BooksSplash());
                          // }, //not working yet
                        ),
                      ],
                    ),
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
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello,",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            FirebaseAuth.instance.currentUser?.displayName ??
                                'Reader',
                            style: TextStyle(
                              fontSize: 36,
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
                              color: Color(0xFFBDD5C8),
                            ),
                          ),
                          if (bookMarks != null && bookMarks.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  "Continue Reading,",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                SizedBox(
                                  height: 340,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: bookMarks.length,
                                    itemBuilder: (context, index) {
                                      final Book book = bookMarks[index];
                                      return SizedBox(
                                        width: 200,
                                        child: BookCover(book: book),
                                      );
                                    },
                                  ),
                                ),
                                Text(
                                  "Morals",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  //the rectangle
                                  margin: EdgeInsets.only(
                                    top: 15,
                                    bottom: 15,
                                  ),
                                  width: 100,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Color(0xFFBDD5C8),
                                  ),
                                ),
                              ],
                            ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              //to fit grid layouts
                              crossAxisCount: 3,
                              childAspectRatio: 2,
                            ),
                            itemCount: sections.length,
                            //grid
                            itemBuilder: (context, index) => Card(
                              elevation: 18,
                              shadowColor: Colors.orange[200],
                              color: (index == 0)
                                  ? Color(0xFFD8D9CF)
                                  : (index) == 1
                                      ? Color(0xFFFFD4B2)
                                      : (index) == 2
                                          ? Color(0xFFCEEDC7)
                                          : (index) == 3
                                              ? Color(0xFFFFF6BD)
                                              : Color(0xFFE3DFFD),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  70,
                                ),
                              ),
                              child: InkWell(
                                //to go to the books list

                                onTap: () {
                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen:
                                        BookSection(scetion: sections[index]),
                                    withNavBar: true,
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino,
                                  );
                                },

                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 8,
                                  ),
                                  child: Center(
                                    child: Text(
                                      sections[index],
                                      style: TextStyle(
                                        //text of morals in grid
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 32,
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
    });
  }
}

class BookSection extends StatelessWidget {
  final String scetion;

  const BookSection({super.key, required this.scetion}); //wist, scetion=moral?
  @override
  Widget build(BuildContext context) {
    //wist, buildcontext?
    return Scaffold(
      body: FutureBuilder(
          future: Connectivity().checkConnectivity(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : (snapshot.data == ConnectivityResult.none)
                    ? const Center(
                        child: Text(
                          'Please connect to your internet',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      )
                    : Column(
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
                            //to add the book from firebase to list of books, right?
                            child: FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection('books')
                                  .where(
                                    'moral',
                                    isEqualTo: scetion,
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

                                          return BookCover(book: book);
                                        });
                              },
                            ),
                          ),
                        ],
                      );
          }),
    );
  }
}

class BookCover extends StatelessWidget {
  //wist
  final Book book; // books fetched from firebase, one book at atime
  const BookCover({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //context=story?
    return InkWell(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: BooksRead(
            //to add the content in books details page
            book: book,
          ),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Column(
        //books list
        children: [
          SizedBox(
            height: 250,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: book.picture,
                  placeholder: (context, url) => ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            //books title
            padding: const EdgeInsets.all(8), //wist
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

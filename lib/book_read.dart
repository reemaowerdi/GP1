import 'package:flutter/material.dart';
import 'package:read_me_a_story/book_model.dart';

class BooksRead extends StatelessWidget {
  final Book book;
  const BooksRead({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listWithWords = book.content.split(' '); // to split story

    final contentList =
        listWithWords.chunked(100).toList(); //to specify separation
    return Scaffold(
      backgroundColor: Color(0xfffff8ee), //background for read story
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
                      //organizing story content
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween, //organize buttons
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back, //arrow back button
                              color: Colors.black,
                              size: 35,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          IconButton(
                            //fav button
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.black,
                              size: 35,
                            ),
                            onPressed: () {}, //not working yet
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: PageView.builder(
                      //to navigate in story
                      itemCount: contentList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            // decoration of text
                            contentList[index].join(' '),
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 1.5,
                              height: 1.5,
                            ),
                          ),
                        );
                      },
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension IterableExtensions<E> on Iterable<E> {
  Iterable<List<E>> chunked(int chunkSize) sync* {
    if (length <= 0) {
      yield [];
      return;
    }
    int skip = 0;
    while (skip < length) {
      final chunk = this.skip(skip).take(chunkSize);
      yield chunk.toList(growable: false);
      skip += chunkSize;
      if (chunk.length < chunkSize) return;
    }
  }
}

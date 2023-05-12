import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:read_me_a_story/book_model.dart';
import 'package:read_me_a_story/main.dart';

import 'home_controller.dart';

class BookReadController extends GetxController {
  BookReadController({
    required this.book,
  });

  final Book book;

//Variables
  final String localStorageIdIdentifier =
      FirebaseAuth.instance.currentUser?.uid ?? 'favourites';
  final String bookStorageIdentifier =
      '${FirebaseAuth.instance.currentUser?.uid}bookMark';
  final Size size = Get.size;
  late PageController pageController;
  late List<String> bookMarksJson;
  List<String> bookMarkIdsList = [];
  List<Book> bookMarkedBooks = [];
  late List<String> favouritesJson;
  List<String> favouriteIdsList = [];
  var isFavourite = false.obs;
  var isBookMarked = false.obs;
  var indexOfBookPage = 0.obs;

  late List<String> bookWords;
  List<String> spokenWords = [];
  List<String> bookPages = [];

  final FlutterTts tts = FlutterTts();
  var isFemaleVoiceSelected = false.obs;
  var isMaleVoiceSelected = false.obs;
  var isPlaying = false.obs;
  var isChosenVoice = false.obs;

  var prgressValue = 0.0.obs;
  var currentIndex = 0;
  List<String> storyWords = [];

  var detectWords = [];

  //Methods
  void bookMarkPage(HomeController homeController, id) async {
    bookMarksJson = homeController.jsonStrings;
    bool marked = homeController.checkMarked(id);

    int index = indexOfBookPage.value;

    if (marked) {
      homeController.bookMarks.value
          .removeWhere((element) => element.id == book.id);
      bookMarksJson.clear();
      for (var element in homeController.bookMarks.value) {
        bookMarksJson.add(element.toJson());
      }
      FirebaseFirestore.instance
          .collection("bookmarks")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({"Stories": bookMarksJson});
      // prefs.setStringList(
      //   bookStorageIdentifier,
      //   bookMarksJson,
      // );
    } else {
      String bookMarkInStringForm = book
          .copyWith(
            bookMarkedPage: indexOfBookPage.value,

          )
          .toJson();


      bookMarksJson.add(bookMarkInStringForm);

      FirebaseFirestore.instance
          .collection("bookmarks")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({"Stories": bookMarksJson});

      // prefs.setStringList(
      //   bookStorageIdentifier,
      //   bookMarksJson,
      // );
    }
    isBookMarked.toggle();
  }

  void toggleFavourite() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    String favouriteBookInStringForm = book.toJson();
    try {
      if (isFavourite.value) {
        favouritesJson.remove(favouriteBookInStringForm);
        prefs.setStringList(localStorageIdIdentifier, favouritesJson);
        FirebaseFirestore.instance.collection('books').doc(book.id).update({
          'favouritesByIds': FieldValue.arrayRemove(
            [uid],
          ),
        });
      } else {
        favouritesJson.add(favouriteBookInStringForm);
        prefs.setStringList(localStorageIdIdentifier, favouritesJson);
        FirebaseFirestore.instance.collection('books').doc(book.id).update({
          'favouritesByIds': FieldValue.arrayUnion(
            [uid],
          ),
        });
      }

      await prefs.reload();

      isFavourite.toggle();
    } catch (e) {
      throw e;
    }
  }

  Future<void> playVoice(BuildContext context) async {
    if (!isMaleVoiceSelected.value && !isFemaleVoiceSelected.value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select voice first',
          ),
        ),
      );
      return;
    }

    isPlaying.toggle();

    for (var j = 0; j < indexOfBookPage.value; j++) {
      List<String> words = bookPages[j].split(' ');
      spokenWords.addAll(words);
    }

    // playerStory(0);

    for (var i = indexOfBookPage.value; i < bookPages.length; i++) {
      var bookPage = bookPages[i];

      var list = bookPage.split(" ");

      int wordIndex = findWordIndex(
          list, detectWords.isEmpty ? "abcdedfg" : detectWords.last);
      int index = wordIndex == -1 ? 0 : wordIndex;
      bookPage = list.sublist(index).join(" ");

      if (isPlaying.value) {
        pageController.jumpToPage(i);

        tts.setProgressHandler((text, start, end, word) {
          spokenWords.add(word);
          detectWords.add(word);
          prgressValue.value = (spokenWords.length) / (bookWords.length);
        });
        await tts.speak(bookPage);
        await tts.awaitSpeakCompletion(true);
        if (i == (bookPages.length - 1)) {
          await tts.stop();
          isPlaying.value = false;
          prgressValue.value = 1;
          spokenWords.clear();
        }
      } else {
        // spokenWords.clear();
        await tts.stop();
        pageController.jumpToPage(indexOfBookPage.value);
      }
    }
  }

  Future<void> selectFemaleVoice(BuildContext context) async {
    if (isPlaying.value) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please Pause audio first')));
      return;
    }

    await tts.setVoice(
      {
        'locale': 'en-AU',
        'name': 'Karen',
      },
    );

    isFemaleVoiceSelected.value = true;
    isMaleVoiceSelected.value = false;
  }

  Future<void> selectMaleVoice(BuildContext context) async {
    if (isPlaying.value) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please Pause audio first')));
      return;
    }

    await tts.setVoice(
      {
        'locale': 'en-GB',
        'name': 'Daniel',
      },
    );

    isFemaleVoiceSelected.value = false;
    isMaleVoiceSelected.value = true;
  }

  @override
  void onInit() {
    //Spliting
    int wordSplitCount = size.width > 150 ? 150 : 150;

    String bookContent = book.content;
    bookWords = bookContent.split(' ');

    List<List<String>> bookWordsSplitIn100 =
        bookWords.chunked(wordSplitCount).toList();

    bookWordsSplitIn100 = bookWordsSplitIn100;

    for (var element in bookWordsSplitIn100) {
      bookPages.add(element.join(' '));
    }

    for (var i = 0; i < bookPages.length - 1; i++) {
      List<String> linesOfCurrentPage = bookPages[i].split('.');
      String lastLineOfCurrentPage = linesOfCurrentPage.last;
      List<String> correctCurrentList = linesOfCurrentPage..removeLast();
      bookPages[i] = '${correctCurrentList.join('.')}.';
      bookPages[i + 1] = '$lastLineOfCurrentPage ${bookPages[i + 1]}';
    }

    bookMarksJson = prefs.getStringList(bookStorageIdentifier) ?? [];
    for (var element in bookMarksJson) {
      bookMarkIdsList.add(Book.fromJson(element).id);
      bookMarkedBooks.add(Book.fromJson(element));
    }

    print(bookMarkIdsList);

    isBookMarked.value = bookMarkIdsList.contains(book.id);

    if (isBookMarked.value) {
      final Book bookData = bookMarkedBooks.singleWhere(
        (element) => element.id == book.id,
      );
      indexOfBookPage.value = bookData.bookMarkedPage ?? 0;
    }
    favouritesJson = prefs.getStringList(localStorageIdIdentifier) ?? [];
    for (var element in favouritesJson) {
      favouriteIdsList.add(Book.fromJson(element).id);
    }
    isFavourite.value = favouriteIdsList.contains(book.id);

    pageController = PageController(
      initialPage: indexOfBookPage.value,
    );

    super.onInit();
  }

  @override
  void dispose() {
    pageController.dispose();

    super.dispose();
  }

  void playerStory(int i) async {
    // for (var i = indexOfBookPage.value; i < bookPages.length; i++) {
    final bookPage = bookPages[i];
    storyWords = bookPage.split(' ');
    await tts.setLanguage("en-US");
    await tts.setVolume(1.0);
    await tts.setSpeechRate(0.5);
    await tts.setPitch(1.0);

    if (isPlaying.value) {
      pageController.jumpToPage(i);

      tts.setProgressHandler((text, start, end, word) {
        spokenWords.add(word);
        detectWords.add(word);
        prgressValue.value = (spokenWords.length) / (bookWords.length);
      });

      int wordIndex = findWordIndex(storyWords, detectWords.last);
      int index = wordIndex == -1 ? 0 : wordIndex;
      String story = storyWords.sublist(index).join(" ");

      await tts.speak(story);
      // await tts.speak(bookPage.substring(wordIndex, bookPage.length));
      await tts.awaitSpeakCompletion(true);
      if (i == (bookPages.length - 1)) {
        await tts.stop();
        isPlaying.value = false;
        prgressValue.value = 1;
        spokenWords.clear();
      }
    } else {
      spokenWords.clear();
      await tts.stop();
      pageController.jumpToPage(indexOfBookPage.value);
    }
    // }
  }

  int findWordIndex(tokens, String targetWord) {
    for (int i = 0; i < tokens.length; i++) {
      if (tokens[i].contains(targetWord)) {
        return i;
      }
    }
    return -1; // Return -1 if the word is not found
  }
}

extension IterableExtensions<E> on Iterable<E> {
  // for splitting
  //wist
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

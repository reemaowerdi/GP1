import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'book_model.dart';

class HomeController extends GetxController {
  var bookMarks = <Book>[].obs;
  var jsonStrings = <String>[].obs;

  var isBookMarked = false.obs;

  void getBookMarks() {
    FirebaseFirestore.instance
        .collection("bookmarks")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .listen((event) {
      bookMarks.clear();
      jsonStrings.clear();
      List<Book> bookss = [];
      print("");
      if (event.data()!['Stories'].isNotEmpty) {
        for (int index = 0; index < event.data()!['Stories'].length; index++) {
          var data = event.data()!['Stories'][index];
          jsonStrings.add(data);
          Book book = Book.fromJson(data);
          bookss.add(book);
        }
      }
      bookMarks.value = bookss;
    });
  }

  bool checkMarked(String id) {
    for (int index = 0; index < bookMarks.length; index++) {
      Book model = bookMarks.value[index];
      if (model.id == id) {
        return true;
      }
    }
    return false;
  }
}

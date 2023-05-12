import 'dart:convert';

import 'package:flutter/foundation.dart';

class Book {
  final String id;
  final String title;
  final String moral;
  final String picture;
  final String content; // story book.content
  List<String> favouritesByIds;
  int? bookMarkedPage;

  Book({
    required this.id,
    required this.title,
    required this.moral,
    required this.picture,
    required this.content,
    required this.favouritesByIds,
    this.bookMarkedPage,
  });

  Book copyWith({
    String? id,
    String? title,
    String? moral,
    String? picture,
    String? content,
    List<String>? favouritesByIds,
    int? bookMarkedPage,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      moral: moral ?? this.moral,
      picture: picture ?? this.picture,
      content: content ?? this.content,
      favouritesByIds: favouritesByIds ?? this.favouritesByIds,
      bookMarkedPage: bookMarkedPage ?? this.bookMarkedPage,
    );
  }

  // Map<String, dynamic> toMap() { //send data from app
  //   return {
  //     'title': title,
  //     'moral': moral,
  //     'imageStr': imageStr,
  //     'content': content,
  //   };
  // }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      moral: map['moral'] ?? '',
      picture: map['picture'] ?? '',
      content: map['content'] ?? '',
      favouritesByIds: List<String>.from(map['favouritesByIds'] ?? []),
      bookMarkedPage: map['bookMarkedPage']?.toInt(),
    );
  }

//   String toJson() => json.encode(toMap());

//   factory Book.fromJson(String source) => Book.fromMap(json.decode(source));

//   @override
//   String toString() {
//     return 'Book(title: $title, moral: $moral, imageStr: $imageStr, content: $content)';
//   }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'moral': moral,
      'picture': picture,
      'content': content,
      'favouritesByIds': favouritesByIds,
      'bookMarkedPage': bookMarkedPage,
    };
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) => Book.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Book(id: $id, title: $title, moral: $moral, picture: $picture, content: $content, favouritesByIds: $favouritesByIds, bookMarkedPage: $bookMarkedPage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Book &&
        other.id == id &&
        other.title == title &&
        other.moral == moral &&
        other.picture == picture &&
        other.content == content &&
        listEquals(other.favouritesByIds, favouritesByIds) &&
        other.bookMarkedPage == bookMarkedPage;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        moral.hashCode ^
        picture.hashCode ^
        content.hashCode ^
        favouritesByIds.hashCode ^
        bookMarkedPage.hashCode;
  }
}

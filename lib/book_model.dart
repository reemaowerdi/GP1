import 'dart:convert'; //wist

import 'package:flutter/foundation.dart';

class Book {
  final String id;
  final String title;
  final String moral;
  final String imageStr;
  final String content; // story book.content
  List<String> favouritesByIds;
  Book({
    required this.id,
    required this.title,
    required this.moral,
    required this.imageStr,
    required this.content,
    required this.favouritesByIds,
  });

  Book copyWith({
    String? id,
    String? title,
    String? moral,
    String? imageStr,
    String? content,
    List<String>? favouritesByIds,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      moral: moral ?? this.moral,
      imageStr: imageStr ?? this.imageStr,
      content: content ?? this.content,
      favouritesByIds: favouritesByIds ?? this.favouritesByIds,
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
      imageStr: map['imageStr'] ?? '',
      content: map['content'] ?? '',
      favouritesByIds: List<String>.from(map['favouritesByIds'] ?? []),
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
      'imageStr': imageStr,
      'content': content,
      'favouritesByIds': favouritesByIds,
    };
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) => Book.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Book(id: $id, title: $title, moral: $moral, imageStr: $imageStr, content: $content, favouritesByIds: $favouritesByIds)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Book &&
        other.id == id &&
        other.title == title &&
        other.moral == moral &&
        other.imageStr == imageStr &&
        other.content == content &&
        listEquals(other.favouritesByIds, favouritesByIds);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        moral.hashCode ^
        imageStr.hashCode ^
        content.hashCode ^
        favouritesByIds.hashCode;
  }
}

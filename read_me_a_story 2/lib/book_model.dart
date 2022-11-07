import 'dart:convert';

class Book {
  final String title;
  final String moral;
  final String imageStr;
  final String content;
  Book({
    required this.title,
    required this.moral,
    required this.imageStr,
    required this.content,
  });

  Book copyWith({
    String? title,
    String? moral,
    String? imageStr,
    String? content,
  }) {
    return Book(
      title: title ?? this.title,
      moral: moral ?? this.moral,
      imageStr: imageStr ?? this.imageStr,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'moral': moral,
      'imageStr': imageStr,
      'content': content,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      title: map['title'] ?? '',
      moral: map['moral'] ?? '',
      imageStr: map['imageStr'] ?? '',
      content: map['content'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) => Book.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Book(title: $title, moral: $moral, imageStr: $imageStr, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Book &&
        other.title == title &&
        other.moral == moral &&
        other.imageStr == imageStr &&
        other.content == content;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        moral.hashCode ^
        imageStr.hashCode ^
        content.hashCode;
  }
}

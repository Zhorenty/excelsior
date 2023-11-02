import 'package:flutter/foundation.dart';

@immutable
final class ArticleModel {
  const ArticleModel({
    required this.id,
    required this.title,
    required this.body,
  });

  final int id;

  final String title;

  final String body;

  factory ArticleModel.fromJson(Map<String, dynamic> json) => ArticleModel(
        id: json['id'],
        title: json['title'],
        body: json['body'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
      };
}

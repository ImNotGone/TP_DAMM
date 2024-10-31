import 'package:json_annotation/json_annotation.dart';

part 'news.g.dart';

@JsonSerializable(createToJson: false)
class News {
  String imageUrl;
  String title;
  String paper;
  String subtitle;
  String content;
  DateTime creationDate;

  News({
    required this.imageUrl,
    required this.title,
    required this.paper,
    required this.subtitle,
    required this.content,
    required this.creationDate,
  });

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);

  // Map<String, dynamic> toJson() => _$NewsToJson(this);
}
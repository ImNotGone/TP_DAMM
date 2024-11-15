// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

News _$NewsFromJson(Map<String, dynamic> json) => News(
      uid: json['uid'] as String,
      imageUrl: json['imageUrl'] as String,
      title: json['title'] as String,
      paper: json['paper'] as String,
      subtitle: json['subtitle'] as String,
      content: json['content'] as String,
      creationDate: DateTime.parse(json['creationDate'] as String),
    );

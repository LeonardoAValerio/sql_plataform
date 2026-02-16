import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:sql_plataform/models/character.dart';

@Entity()
class Chapter {
  int id = 0;

  @Unique()
  int refId;

  String name;
  String backgroundImgPath;
  String iconImgPath;
  int color;
  List<String> defaultDialogs;

  final character = ToOne<Character>();

  Chapter({
    required this.refId,
    required this.name,
    required this.backgroundImgPath,
    required this.iconImgPath,
    required this.defaultDialogs,
    required this.color,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    final dialogsFromJson = json["defaultDialogs"] as List<dynamic>;
    final defaultDialogs = dialogsFromJson.map((e) => "$e").toList();

    return Chapter(
      refId: json['refId'], 
      name: json['name'], 
      backgroundImgPath: json['backgroundImgPath'], 
      iconImgPath: json['iconImgPath'],
      defaultDialogs: defaultDialogs,
      color: int.parse("0xFF${json['color']}")
    );
  }

  @override
  String toString() {
    return "Chapter{refId: $refId, name: $name, backgroundImgPath: $backgroundImgPath, iconImgPath: $iconImgPath, defaultDialogs: $defaultDialogs}";
  }
}
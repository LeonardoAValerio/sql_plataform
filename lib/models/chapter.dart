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
  List<String> defaultDialogs;

  final character = ToOne<Character>();

  Chapter({
    required this.refId,
    required this.name,
    required this.backgroundImgPath,
    required this.iconImgPath,
    required this.defaultDialogs,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    final dialogsFromJson = json["defaultDialogs"] as List<dynamic>;
    final defaultDialogs = dialogsFromJson.map((e) => "$e").toList();

    return Chapter(
      refId: json['refId'], 
      name: json['name'], 
      backgroundImgPath: json['backgroundImgPath'], 
      iconImgPath: json['iconImgPath'],
      defaultDialogs: defaultDialogs
    );
  }

  @override
  String toString() {
    return "Chapter{refId: $refId, name: $name, backgroundImgPath: $backgroundImgPath, iconImgPath: $iconImgPath, defaultDialogs: $defaultDialogs}";
  }
}
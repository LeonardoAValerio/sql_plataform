import 'package:objectbox/objectbox.dart';
import 'package:sql_plataform/data/models/character.dart';

@Entity()
class Chapter {
  int id = 0;
  String name;
  String backgroundImgPath;
  String iconImgPath;
  List<String> defaultDialogs;

  final character = ToOne<Character>();

  Chapter({
    required this.name,
    required this.backgroundImgPath,
    required this.iconImgPath,
    required this.defaultDialogs,
  });
}
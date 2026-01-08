import 'package:objectbox/objectbox.dart';
import 'package:sql_plataform/data/models/character.dart';

@Entity()
class Dialog {
  int id = 0;
  List<String> texts;

  final character = ToOne<Character>();

  Dialog({required this.texts});
}
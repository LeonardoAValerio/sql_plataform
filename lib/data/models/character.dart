import 'package:objectbox/objectbox.dart';

@Entity()
class Character {
  int id = 0;
  String name;
  String pathImg;

  Character({required this.name, required this.pathImg});
}
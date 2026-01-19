import 'package:objectbox/objectbox.dart';

@Entity()
class Character {
  int id = 0;

  @Unique()
  int refId;

  String name;
  String pathImg;

  Character({required this.refId, required this.name, required this.pathImg});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      refId: json['refId'], 
      name: json['name'], 
      pathImg: json['pathImg']
    );
  }

  @override
  String toString() {
    return "Character{refId: $refId, name: $name, pathImg: $pathImg}";
  }
}
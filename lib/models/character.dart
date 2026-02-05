import 'package:objectbox/objectbox.dart';

@Entity()
class Character {
  int id = 0;

  @Unique()
  int refId;

  String name;
  String? defaultImg;
  String speakingImg;

  Character({required this.refId, required this.name, this.defaultImg, required this.speakingImg});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      refId: json['refId'], 
      name: json['name'], 
      defaultImg: json['defaultImg'],
      speakingImg: json['speakingImg'],
    );
  }

  @override
  String toString() {
    return "Character{refId: $refId, name: $name, defaultImg: $defaultImg, speakingImg: $speakingImg}";
  }
}
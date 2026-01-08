import 'package:objectbox/objectbox.dart';

@Entity()
class TypeQuestion {
  int id = 0;
  String name;

  TypeQuestion({required this.name});
}
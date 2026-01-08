import 'package:objectbox/objectbox.dart';

@Entity()
class Config{
    int id = 0;

    String username;
    bool insertedTables = false;

    Config({required this.username});
}
import 'package:flutter/material.dart';
import 'package:sql_plataform/core/database/objectbox_manager.dart';
import 'package:sql_plataform/core/utils/database_seeder.dart';
import 'package:sql_plataform/views/screens/home_screen.dart';

void main()async {
  print("Starting application...");
  WidgetsFlutterBinding.ensureInitialized();
  await ObjectBoxManager.create();

  final seeder = DatabaseSeeder();
  await seeder.clearAll();
  await seeder.seedAll();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
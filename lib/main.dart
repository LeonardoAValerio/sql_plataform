import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sql_plataform/core/database/objectbox_manager.dart';
import 'package:sql_plataform/core/utils/database_seeder.dart';
import 'package:sql_plataform/services/sql/sql_question_executor.dart';
import 'package:sql_plataform/services/sql/sql_question_manager.dart';
import 'package:sql_plataform/views/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ObjectBoxManager.create();

  final seeder = DatabaseSeeder();
  await seeder.clearAll();
  await seeder.seedAll();

  final question = ObjectBoxManager.questionBox.get(2);
  final dataQuestion = jsonDecode(question!.dataQuestion);
  final result = dataQuestion['result'];

  final manager = new SQLQuestionManager(refIdQuestion: question!.id);
  final executor = new SQLQuestionExecutor(type: result['type'], query: "SELECT * FROM exercito");
  final resultQuery = await manager.executeQuery(executor);
  print(resultQuery);

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
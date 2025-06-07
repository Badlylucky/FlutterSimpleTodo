import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studying_flutter/providers/todo_list_model.dart';
import 'package:studying_flutter/screens/todo_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoListModel(),
      child: const MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const TodoListScreen()
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studying_flutter/providers/todo_list_model.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todoListModel = Provider.of<TodoListModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('TODO')),
      body: ListView.builder(
        itemCount: todoListModel.get().length,
        itemBuilder: (context, index) {
          final todoItems = todoListModel.get();
          final todo = todoItems[index];
          return ListTile(
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            leading: Checkbox(
              value: todo.isCompleted,
              onChanged: (bool? newValue) {
                if (newValue != null) {
                  todoListModel.toggleTodoStatus(todo.id);
                }
              }
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                todoListModel.removeTodo(todo.id);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
          todoListModel.addTodo('test1');
          todoListModel.addTodo('test2');
          print('add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studying_flutter/providers/todo_list_model.dart';
import 'package:studying_flutter/widgets/todo_tile.dart';

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
                final todo = todoListModel.getByIndex(index);
                return TodoTile( // ここでカスタムウィジェットを使用
                  todo: todo,
                  onToggleStatus: () => todoListModel.toggleTodoStatus(todo.id),
                  onUpdateTitle: (newTitle) => todoListModel.updateTodoTitle(todo.id, newTitle),
                  onDelete: () => todoListModel.removeTodo(todo.id),
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

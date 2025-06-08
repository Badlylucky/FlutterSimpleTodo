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
      body: GestureDetector(
        onTap: () {
          // タップでキーボードを閉じる
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: ReorderableListView.builder(
          itemCount: todoListModel.todoItems.length,
          itemBuilder: (context, index) {
            final todo = todoListModel.todoItems[index];
            return Dismissible(
              key: ValueKey(todo.id),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20.0),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20.0),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.horizontal,
              onDismissed: (direction) {
                // スワイプが完了したとき、TODOを削除する
                todoListModel.removeTodo(todo.id);
              },
              child: TodoTile(
                key: ValueKey(todo.id), // Dismissibleのキーと一致させる
                todo: todo,
                isInitiallyEditing: todo.id == todoListModel.editingTodoId,
                onToggleStatus: () => todoListModel.toggleTodoStatus(todo.id),
                onUpdateTitle: (newTitle) => todoListModel.updateTodoTitle(todo.id, newTitle),
                onDelete: () => todoListModel.removeTodo(todo.id),
              ),
            );
          },
          onReorder: (int oldIndex, int newIndex) {
            // todoリストの順序を更新する
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            todoListModel.reorderTodos(oldIndex, newIndex);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          todoListModel.addEmptyTodoAndSetEditing();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

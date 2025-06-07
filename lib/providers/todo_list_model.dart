import 'package:flutter/foundation.dart';
import 'package:studying_flutter/models/todo_item.dart';
import 'package:uuid/uuid.dart';

class TodoListModel extends ChangeNotifier {
  final List<TodoItem> _todoItems = [];

  List<TodoItem> get todoItems => _todoItems;

  void addTodo(String title) {
    const uuid = Uuid();
    final newTodo = TodoItem(id: uuid.v7(), title: title);
    _todoItems.add(newTodo);
    notifyListeners();
  }

  void toggleTodoStatus(String id) {
    final index = _todoItems.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todoItems[index] = _todoItems[index].toggle();
      notifyListeners();
    }
  }

  void removeTodo(String id) {
    _todoItems.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  void updateTodoTitle(String id, String newTitle) {
    final index = _todoItems.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todoItems[index] = _todoItems[index].updateTitle(newTitle);
      notifyListeners();
    }
  }

  void reorderTodos(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final todo = _todoItems.removeAt(oldIndex);
    _todoItems.insert(newIndex, todo);
    notifyListeners();
  }
}
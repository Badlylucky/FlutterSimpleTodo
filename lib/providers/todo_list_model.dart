import 'package:flutter/foundation.dart';
import 'package:studying_flutter/models/todo_item.dart';
import 'package:uuid/uuid.dart';

class TodoListModel extends ChangeNotifier {
  final List<TodoItem> _todoItems = [];
  String? _editingTodoId; // 編集中のTODOのID

  List<TodoItem> get todoItems => _todoItems;
  String? get editingTodoId => _editingTodoId;

  void addTodo(String title) {
    const uuid = Uuid();
    final newTodo = TodoItem(id: uuid.v7(), title: title);
    _todoItems.add(newTodo);
    notifyListeners();
  }

  TodoItem addEmptyuTodoAndSetEditing() {
    const uuid = Uuid();
    final newTodo = TodoItem(id: uuid.v7(), title: '');
    _todoItems.add(newTodo);
    _editingTodoId = newTodo.id;
    notifyListeners();
    return newTodo;
  }

  void setEditingTodoId(String? id) {
    _editingTodoId = id;
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
    if (_editingTodoId == id) {
      _editingTodoId = null; // 編集中のTODOが削除された場合はIDをクリア
    }
    notifyListeners();
  }

  void updateTodoTitle(String id, String newTitle) {
    final index = _todoItems.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todoItems[index] = _todoItems[index].updateTitle(newTitle);
      if (_editingTodoId == id) {
        _editingTodoId = null; // 編集中のTODOのタイトルが更新された場合はIDをクリア
      }
      notifyListeners();
    }
  }

  void reorderTodos(int oldIndex, int newIndex) {
    if (newIndex < 0 || newIndex >= _todoItems.length) {
      return; // 無効なインデックスの場合は何もしない
    }
    final todo = _todoItems.removeAt(oldIndex);
    _todoItems.insert(newIndex, todo);
    notifyListeners();
  }
}
import 'package:flutter_test/flutter_test.dart';
import 'package:studying_flutter/providers/todo_list_model.dart';

void main() {
  late TodoListModel model;

  setUp(() {
    model = TodoListModel();
  });
  group('addTodo', () {
    test('新しいTODOを追加できること', () {
      expect(model.todoItems.length, 0);
      model.addTodo('Test Todo');
      expect(model.todoItems.length, 1);
      expect(model.todoItems[0].title, 'Test Todo');
      expect(model.todoItems[0].isCompleted, false);
      expect(model.todoItems[0].id, isNotNull);
    });
    test('空のタイトルでTODOを追加できること', () {
      model.addTodo('');
      expect(model.todoItems.length, 1);
      expect(model.todoItems[0].title, '');
    });
    test('同じタイトルで複数のTODOを追加できること', () {
      model.addTodo('Duplicate Todo');
      model.addTodo('Duplicate Todo');
      expect(model.todoItems.length, 2);
      expect(model.todoItems[0].title, 'Duplicate Todo');
      expect(model.todoItems[1].title, 'Duplicate Todo');
    });
  });

  group('addEmptyTodoAndSetEditing', () {
    test('空のTODOを追加して編集状態にできること', () {
      final newTodo = model.addEmptyTodoAndSetEditing();
      expect(model.todoItems.length, 1);
      expect(newTodo.title, '');
      expect(model.editingTodoId, newTodo.id);
    });
  });

  group('setEditingTodoId', () {
    test('編集中のTODOのIDを設定できること', () {
      model.setEditingTodoId('test-id');
      expect(model.editingTodoId, 'test-id');
    });
    test('nullを設定すると編集中のTODOがクリアされること', () {
      model.setEditingTodoId('test-id');
      model.setEditingTodoId(null);
      expect(model.editingTodoId, isNull);
    });
  });

  group('toggleTodoStatus', () {
    test('TODOのステータスをトグルできること', () {
      model.addTodo('Test Todo');
      final todoId = model.todoItems[0].id;
      expect(model.todoItems[0].isCompleted, false);
      model.toggleTodoStatus(todoId);
      expect(model.todoItems[0].isCompleted, true);
      model.toggleTodoStatus(todoId);
      expect(model.todoItems[0].isCompleted, false);
    });
  });

  group('removeTodo', () {
    test('TODOを削除できること', () {
      model.addTodo('Test Todo');
      final todoId = model.todoItems[0].id;
      expect(model.todoItems.length, 1);
      model.removeTodo(todoId);
      expect(model.todoItems.length, 0);
    });
    test('削除したTODOが編集中の場合、編集中のIDがクリアされること', () {
      model.addTodo('Test Todo');
      final todoId = model.todoItems[0].id;
      model.setEditingTodoId(todoId);
      model.removeTodo(todoId);
      expect(model.editingTodoId, isNull);
    });
  });

  group('updateTodoTitle', () {
    test('TODOのタイトルを更新できること', () {
      model.addTodo('Old Title');
      final todoId = model.todoItems[0].id;
      model.updateTodoTitle(todoId, 'New Title');
      expect(model.todoItems[0].title, 'New Title');
    });
    test('同じタイトルで更新しても変更されないこと', () {
      model.addTodo('Same Title');
      final todoId = model.todoItems[0].id;
      model.updateTodoTitle(todoId, 'Same Title');
      expect(model.todoItems[0].title, 'Same Title');
    });
  });

  group('reorderTodos', () {
    test('TODOの順序を変更できること', () {
      model.addTodo('First Todo');
      model.addTodo('Second Todo');
      model.addTodo('Third Todo');
      expect(model.todoItems.map((todo) => todo.title).toList(), ['First Todo', 'Second Todo', 'Third Todo']);
      
      model.reorderTodos(0, 2);
      expect(model.todoItems.map((todo) => todo.title).toList(), ['Second Todo', 'Third Todo', 'First Todo']);
      
      model.reorderTodos(2, 0);
      expect(model.todoItems.map((todo) => todo.title).toList(), ['First Todo', 'Second Todo', 'Third Todo']);
    });
    test('無効なインデックスで何もしないこと', () {
      model.addTodo('Only One');
      expect(model.todoItems.length, 1);
      model.reorderTodos(0, 1); // 無効なインデックス
      expect(model.todoItems.length, 1);
    });
  });
}
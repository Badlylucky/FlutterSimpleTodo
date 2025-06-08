
import 'package:flutter_test/flutter_test.dart';
import 'package:studying_flutter/models/todo_item.dart';

void main() {
  group('complete item', () {
    test('コンプリートされていないとき、コンプリート状態になること', () {
      final todo = TodoItem(id: 'test', title: 'title', isCompleted: false);
      final completedTodo = todo.complete();
      expect(completedTodo.isCompleted, isTrue);
    });
    test('コンプリートされているとき、コンプリート状態のままであること', () {
      final todo = TodoItem(id: 'test', title: 'title', isCompleted: true);
      final completedTodo = todo.complete();
      expect(completedTodo.isCompleted, isTrue);
    });
  });
  group('uncomplete item', () {
    test('コンプリートされているとき、未コンプリート状態になること', () {
      final todo = TodoItem(id: 'test', title: 'title', isCompleted: true);
      final uncompletedTodo = todo.uncomplete();
      expect(uncompletedTodo.isCompleted, isFalse);
    });
    test('未コンプリート状態のとき、未コンプリート状態のままであること', () {
      final todo = TodoItem(id: 'test', title: 'title', isCompleted: false);
      final uncompletedTodo = todo.uncomplete();
      expect(uncompletedTodo.isCompleted, isFalse);
    });
  });
  group('toggle item', () {
    test('コンプリートされていないとき、コンプリート状態になること', () {
      final todo = TodoItem(id: 'test', title: 'title', isCompleted: false);
      final toggledTodo = todo.toggle();
      expect(toggledTodo.isCompleted, isTrue);
    });
    test('コンプリートされているとき、未コンプリート状態になること', () {
      final todo = TodoItem(id: 'test', title: 'title', isCompleted: true);
      final toggledTodo = todo.toggle();
      expect(toggledTodo.isCompleted, isFalse);
    });
  });
  group('update title', () {
    test('タイトルを更新できること', () {
      final todo = TodoItem(id: 'test', title: 'old title', isCompleted: false);
      final updatedTodo = todo.updateTitle('new title');
      expect(updatedTodo.title, 'new title');
      expect(updatedTodo.id, todo.id);
      expect(updatedTodo.isCompleted, todo.isCompleted);
    });
    test('同じタイトルでも更新できること', () {
      final todo = TodoItem(id: 'test', title: 'same title', isCompleted: false);
      final updatedTodo = todo.updateTitle('same title');
      expect(updatedTodo.title, 'same title');
      expect(updatedTodo.id, todo.id);
      expect(updatedTodo.isCompleted, todo.isCompleted);
    });
  });
}
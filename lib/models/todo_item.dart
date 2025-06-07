class TodoItem {
  final String id; // UUIDv7
  String title; // TODOの内容
  bool isCompleted;

  TodoItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  TodoItem complete() {
    return TodoItem(id: id, title: title, isCompleted: true);
  }

  TodoItem uncomplete() {
    return TodoItem(id: id, title: title, isCompleted: false);
  }

  TodoItem toggle() {
    return TodoItem(id: id, title: title, isCompleted: !isCompleted);
  }

  TodoItem updateTitle(String newTitle) {
    return TodoItem(id: id, title: newTitle, isCompleted: isCompleted);
  }
}
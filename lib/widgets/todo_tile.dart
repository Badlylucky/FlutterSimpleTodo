import 'package:flutter/material.dart';
import 'package:studying_flutter/models/todo_item.dart';

class TodoTile extends StatefulWidget {
  final TodoItem todo;
  final VoidCallback onToggleStatus;
  final ValueChanged<String> onUpdateTitle;
  final VoidCallback onDelete;

  const TodoTile({
    super.key,
    required this.todo,
    required this.onToggleStatus,
    required this.onUpdateTitle,
    required this.onDelete,
  });

  @override
  State<TodoTile> createState() => _TodoTileState();
}

class _TodoTileState extends State<TodoTile> {
  bool _isEditing = false; // TODOが編集状態か
  late TextEditingController _editController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.todo.title);
    _focusNode = FocusNode();

    // フォーカスが外れたときに編集モードを終了し、タイトルを更新する
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _isEditing) {
        _exitEditNodeAndSave();
      }
    });
  }

  @override
  void dispose() {
    _editController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // 編集モードに入る
  void _enterEditMode() {
    setState(() {
      _isEditing = true;
    });
    // 次のフレームでTextFieldにフォーカスを当てる
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      // テキストの末尾にカーソルを移動
      _editController.selection = TextSelection.fromPosition(
        TextPosition(offset: _editController.text.length),
      );
    });
  }

  // 編集モードを終了し、タイトルを更新する
  void _exitEditNodeAndSave() {
    if (_editController.text.isNotEmpty && _editController.text != widget.todo.title) {
      widget.onUpdateTitle(_editController.text);
    }
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onToggleStatus,
      onLongPress:  _enterEditMode,
      
      // 編集モードに応じてTextとTextFieldを切り替える
      title: _isEditing
          ? TextField(
              controller: _editController,
              focusNode: _focusNode,
              autofocus: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(
                decoration: widget.todo.isCompleted ? TextDecoration.lineThrough : null,
              ),
              onSubmitted: (_) => _exitEditNodeAndSave(),
            )
          : Text(
            widget.todo.title,
            style: TextStyle(
              decoration: widget.todo.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
      leading: Icon(
        Icons.lens,
        size: 14,
      ),
    );
  }
}
      
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studying_flutter/models/todo_item.dart';
import 'package:studying_flutter/providers/todo_list_model.dart';

class TodoTile extends StatefulWidget {
  final TodoItem todo;
  final bool isInitiallyEditing; // 初期状態で編集モードにするか
  final VoidCallback onToggleStatus;
  final ValueChanged<String> onUpdateTitle;
  final VoidCallback onDelete;

  const TodoTile({
    super.key,
    required this.todo,
    required this.onToggleStatus,
    required this.onUpdateTitle,
    required this.onDelete,
    this.isInitiallyEditing = false,
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

    // 初期状態で編集モードにする
    if (widget.isInitiallyEditing) {
      _isEditing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
        // テキストの末尾にカーソルを移動
        _editController.selection = TextSelection.fromPosition(
          TextPosition(offset: _editController.text.length),
        );
      });
    }

    // フォーカスが外れたときに編集モードを終了し、タイトルを更新する
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _isEditing) {
        _exitEditNodeAndSave();
      }
    });
  }

  @override
  void didUpdateWidget(covariant TodoTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isInitiallyEditing && !_isEditing) {
      _enterEditMode();
    }
    // TODOアイテムの内容（タイトル）が変わった場合は、コントローラも更新
    if (oldWidget.todo.title != widget.todo.title && !_isEditing) {
        _editController.text = widget.todo.title;
    }
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
    if (_editController.text != widget.todo.title) {
      widget.onUpdateTitle(_editController.text);
    }
    setState(() {
      _isEditing = false;
    });

    // 編集終了時に、TodoListModelのeditingTodoIdをクリアする
    Provider.of<TodoListModel>(context, listen: false).setEditingTodoId(null);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_isEditing) {
          widget.onToggleStatus();
        }
        // 上位のonTapイベントを発火させる
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onDoubleTap: () {
        if (!_isEditing) {
          _enterEditMode();
        }
      },
      // 編集モードに応じてTextとTextFieldを切り替える
      child: ListTile(  
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
                onSubmitted: (_) {
                  _focusNode.unfocus();
                  _exitEditNodeAndSave();
                },
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
      ),
    );
  }
}

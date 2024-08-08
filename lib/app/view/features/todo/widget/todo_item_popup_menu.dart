import 'package:flutter/material.dart';
import 'package:todo_api/api.dart';
import 'package:todo_list_app/app/common/todo_actions.dart';

enum AnimationStyles { defaultStyle, custom, none }

enum Menu { preview, mark, remove, edit }

class TodoItemPopupMenu extends StatelessWidget {
  const TodoItemPopupMenu({
    required this.todoEntity,
    required this.actions,
    super.key,
  });

  final TodoEntity todoEntity;
  final TodoActions actions;

  @override
  Widget build(BuildContext context) {
    final animationStyle = AnimationStyle(
      curve: Easing.emphasizedDecelerate,
      duration: const Duration(milliseconds: 300),
    );
    return PopupMenuButton<Menu>(
      popUpAnimationStyle: animationStyle,
      icon: const Icon(Icons.more_vert),
      onSelected: (Menu menu) => switch (menu) {
        Menu.preview => actions.onShowDetails(todoEntity),
        Menu.mark => actions.onMarkAsDone(todoEntity),
        Menu.remove => actions.onDelete(todoEntity),
        Menu.edit => actions.onEdit(todoEntity),
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
        const PopupMenuItem<Menu>(
          value: Menu.preview,
          child: ListTile(
            leading: Icon(Icons.open_in_new),
            title: Text('Task details'),
          ),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.mark,
          child: ListTile(
            leading: Icon(Icons.check),
            title: Text('Mark as done'),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<Menu>(
          value: Menu.edit,
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<Menu>(
          value: Menu.remove,
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('Remove'),
          ),
        ),
      ],
    );
  }
}

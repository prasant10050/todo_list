import 'package:flutter/material.dart';
import 'package:todo_api/api.dart';
import 'package:todo_list_app/app/common/todo_actions.dart';
import 'package:todo_list_app/app/view/features/todo/widget/todo_item_popup_menu.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    required this.todoEntity,
    required this.actions,
    super.key,
  });

  final TodoEntity todoEntity;
  final TodoActions actions;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).listTileTheme.titleTextStyle?.copyWith(
          decoration:
              todoEntity.isCompleted ? TextDecoration.lineThrough : null,
        );

    final subTitleStyle =
        Theme.of(context).listTileTheme.subtitleTextStyle?.copyWith(
              decoration:
                  todoEntity.isCompleted ? TextDecoration.lineThrough : null,
            );

    return ListTile(
      title: Text(
        todoEntity.title,
        style: titleStyle,
      ),
      subtitle: Text(
        todoEntity.description,
        style: subTitleStyle,
      ),
      leading: Checkbox(
        value: todoEntity.isCompleted,
        onChanged: (value) => actions.onMarkAsDone(todoEntity),
      ),
      trailing: TodoItemPopupMenu(
        actions: actions,
        todoEntity: todoEntity,
      ),
    );
  }
}
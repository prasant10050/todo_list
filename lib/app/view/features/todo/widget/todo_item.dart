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

    return Card(
      margin: const EdgeInsetsDirectional.only(
        bottom: 16,
      ),
      child: ListTile(
        contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        title: Text(
          todoEntity.title,
          style: TextStyle(
            decoration: todoEntity.isCompleted ? TextDecoration.lineThrough : null,
          ),
          //style: titleStyle,
        ),
        subtitle: Text(
          todoEntity.description,
          style: TextStyle(
            decoration: todoEntity.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        leading: Checkbox(
          value: todoEntity.isCompleted,
          onChanged: (value) => actions.onMarkAsDone(todoEntity),
        ),
        trailing: TodoItemPopupMenu(
          actions: actions,
          todoEntity: todoEntity,
        ),
      ),
    );
  }
}

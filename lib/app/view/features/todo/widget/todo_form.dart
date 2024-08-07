import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_api/api.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/add_todo/add_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_event.dart';
import 'package:todo_list_app/app/view/features/todo/widget/actions.dart';

class TodoForm extends StatefulWidget {
  const TodoForm({super.key, this.todoEntity, this.isNew = false});

  final bool isNew;
  final TodoEntity? todoEntity;

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController textInputTitleController;
  late TextEditingController textInputDescriptionController;

  @override
  void initState() {
    super.initState();

    textInputTitleController = TextEditingController();
    textInputDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    textInputTitleController.dispose();
    textInputDescriptionController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TodoForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    super.didUpdateWidget(oldWidget);
    if (oldWidget.todoEntity != widget.todoEntity) {
      _formKey.currentState?.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.isNew ? 'Add' : 'Edit'} todo'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: textInputTitleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              maxLength: 150,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                } else if (value.length > 20) {
                  return 'Limit the title to 20 characters.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: textInputDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.view_headline),
                border: OutlineInputBorder(),
              ),
              maxLength: 150,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                if (value.length > 100) {
                  return 'Limit the description to 100 characters.';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final todo = TodoEntity(
                title: textInputTitleController.value.text,
                description: textInputDescriptionController.value.text,
                taskId: TaskId.fromUniqueString('default'),
              );
              context
                  .read<AddTodoBloc>()
                  .add(AddTodoRequested(todoEntity: todo));
              Navigator.of(context).pop(todo);
            }
          },
          child: const Text('Save'),
        ),
        TextButton(
          onPressed: () async {
            final title=textInputTitleController.value.text;
            final description= textInputDescriptionController.value.text;
            final canCancel=title.isEmpty || description.isEmpty;
            if(canCancel){
              return;
            }
            await confirm(
              context,
              title: 'Discard changes?',
              content: 'Are you sure you want to discard your changes?',
            );
          },
          child: const Text('Discard'),
        ),
      ],
    );
  }
}

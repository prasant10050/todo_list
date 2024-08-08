import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_api/api.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/add_todo/add_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/get_todo/get_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_event.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/update_todo/update_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/widget/actions.dart';

class TodoForm extends StatefulWidget {
  const TodoForm({
    super.key,
    this.todoEntity,
    this.isNew = true,
    this.showMeDetails = false,
  });

  final bool isNew;
  final TodoEntity? todoEntity;
  final bool showMeDetails;

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

    final entity = widget.todoEntity;
    if (entity == null) return;

    textInputTitleController.text = entity.title;
    textInputDescriptionController.text = entity.description;
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: textInputTitleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(),
                    ),
                    //maxLength: 150,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      } else if (value.length > 20) {
                        return 'Limit the title to 20 characters.';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: textInputDescriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      prefixIcon: Icon(Icons.view_headline),
                      border: OutlineInputBorder(),
                    ),
                    //maxLength: 150,
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
                ),
              ],
            ),
          ],
        ),
      ),
      actions: widget.showMeDetails
          ? [
              TextButton(
                onPressed: () {
                  context.read<GetTodoBloc>().add(
                        ShowTodoDetailsRequested(
                          hasOpened: false,
                          todoEntity: widget.todoEntity!,
                        ),
                      );
                  return;
                },
                child: const Text('Close'),
              ),
            ]
          : [
              TextButton(
                onPressed: () async {
                  final title = textInputTitleController.value.text;
                  final description = textInputDescriptionController.value.text;
                  final canCancel = title.isEmpty || description.isEmpty;
                  if (canCancel) {
                    context.read<AddTodoBloc>().add(
                          const DiscardTodoDialogRequested(hasDiscard: false),
                        );
                    return;
                  }
                  await confirm(
                    context,
                    title: 'Discard changes?',
                    content: 'Are you sure you want to discard your changes?',
                    onConfirm: () => context.read<AddTodoBloc>().add(
                          const DiscardTodoDialogRequested(hasDiscard: false),
                        ),
                  );
                },
                child: const Text('Discard'),
              ),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    final title = textInputTitleController.value.text;
                    final description =
                        textInputDescriptionController.value.text;
                    final entity = widget.todoEntity;
                    // Edit or update `todo`
                    if (!widget.isNew && entity != null) {
                      final copyEntity = entity.copyWith(
                        title: title,
                        description: description,
                      );

                      context
                          .read<UpdateTodoBloc>()
                          .add(UpdateTodoRequested(todoEntity: copyEntity));
                    }else{
                      // New entry `todo`
                      final todo = TodoEntity(
                        title: title,
                        description: description,
                        taskId: TaskId.generate(),
                      );
                      context
                          .read<AddTodoBloc>()
                          .add(AddTodoRequested(todoEntity: todo));
                    }
                  }
                },
                child: const Text('Save'),
              ),
            ],
    );
  }
}

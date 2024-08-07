import 'package:di/di.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_api/api.dart';
import 'package:todo_list_app/app/common/global_config.dart';
import 'package:todo_list_app/app/common/todo_actions.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/get_todo/get_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_state.dart';
import 'package:todo_list_app/app/view/features/todo/widget/sliver_list_separator.dart';
import 'package:todo_list_app/app/view/features/todo/widget/todo_form.dart';
import 'package:todo_list_app/app/view/features/todo/widget/todo_item.dart';
import 'package:todo_list_app/app/widget/page_body.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<TodoEntity> todoEntities = [];

  Widget _listWidget() {
    final items = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

    return SliverListSeparator(
      builder: (context, index) => ListTile(title: Text(items[index])),
      separator: const Divider(),
      childCount: items.length,
    );
  }

  Future<TodoEntity?> _openDialog(TodoId? todoId) {
    return showDialog<TodoEntity>(
      context: context,
      builder: (context) => TodoForm(
        key: todoId != null ? ValueKey(todoId) : UniqueKey(),
      ),
    );
  }

  void _editTodo(TodoEntity todo) {
    // Implement edit functionality
  }

  void _markAsDone(TodoEntity todo) {
    setState(() {
      //todo.isDone = !todo.isDone;
    });
  }

  void _showDetails(TodoEntity todo) {
    // Implement show details functionality
  }

  void _deleteTodo(TodoEntity todo) {
    setState(() {
      //todos.remove(todo);
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final margins = GlobalConfig.responsiveInsets(media.size.width);
    final topPadding =
        margins; //media.padding.top + kToolbarHeight + margins; //margins * 1.5;
    final bottomPadding = media.padding.bottom + margins;
    final width = media.size.width;
    final theme = Theme.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: FlexColorScheme.themedSystemNavigationBar(
        context,
        useDivider: false,
        opacity: 0.60,
        noAppBar: true,
      ),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('My Todo List'),
            actions: const [],
          ),
          body: PageBody(
            controller: ScrollController(),
            constraints: BoxConstraints(
              minWidth: double.infinity,
              minHeight: media.size.height,
            ),
            child: BlocBuilder<GetTodoBloc, TodoState>(
              bloc: context.read<GetTodoBloc>(),
              buildWhen: (previous, current) => previous != current,
              builder: (context, todoState) {
                
                return SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(
                      minWidth: double.infinity,
                      maxHeight: media.size.height -
                          (media.padding.top +
                              kToolbarHeight +
                              media.padding.bottom),
                    ),
                    padding: EdgeInsetsDirectional.only(
                      top: topPadding,
                      start: margins * 2.5,
                      end: margins * 2.5,
                      //bottom: bottomPadding,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: CustomScrollView(
                            slivers: [
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final todo = todoEntities[index];

                                    final todoActions = TodoActions(
                                      onEdit: _editTodo,
                                      onMarkAsDone: _markAsDone,
                                      onShowDetails: _showDetails,
                                      onDelete: _deleteTodo,
                                    );

                                    return TodoItem(
                                      todoEntity: todo,
                                      actions: todoActions,
                                    );
                                  },
                                  childCount: todoEntities.length,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )),
    );
  }
}

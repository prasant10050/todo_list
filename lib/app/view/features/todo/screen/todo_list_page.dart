import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_bloc_builder_widget/multi_bloc_builder.dart';
import 'package:todo_api/api.dart';
import 'package:todo_list_app/app/common/global_config.dart';
import 'package:todo_list_app/app/common/screen_state_enum.dart';
import 'package:todo_list_app/app/common/todo_actions.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/add_todo/add_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/filter_todo/filter_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/get_todo/get_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/mark_todo/mark_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/remove_todo/remove_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_event.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_state.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/update_todo/update_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/extension/todo_state_extension.dart';
import 'package:todo_list_app/app/view/features/todo/widget/todo_filter_widget.dart';
import 'package:todo_list_app/app/view/features/todo/widget/todo_form.dart';
import 'package:todo_list_app/app/view/features/todo/widget/todo_item.dart';
import 'package:todo_list_app/app/widget/multiple_bloc_builder_widget.dart';
import 'package:todo_list_app/app/widget/page_body.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<TodoEntity> todoEntities = [];
  bool isTodoLoading = false;
  bool isTodoProcessing = false;
  bool hasTodoEmpty = false;

  TodoListBuildPageState buildPageState = TodoListBuildPageState.loading;

  @override
  void initState() {
    super.initState();
    _fetchTodoList(context);
  }

  void _fetchTodoList(BuildContext context) {
    if (context.mounted) {
      context.read<GetTodoBloc>().add(const GetAllTodoRequested());
    }
  }

  Future<TodoEntity?> _openDialog(
    TodoEntity? todoEntity, {
    bool isNew = true,
    bool showMeDetails = false,
  }) {
    return showDialog<TodoEntity>(
      context: context,
      barrierDismissible: false,
      builder: (context) => TodoForm(
        key: todoEntity?.taskId != null ? ValueKey(todoEntity) : UniqueKey(),
        todoEntity: todoEntity,
        isNew: isNew,
        showMeDetails: showMeDetails,
      ),
    );
  }

  void _editTodo(
    TodoEntity todo,
  ) {
    context
        .read<UpdateTodoBloc>()
        .add(OpenEditTodoDialogRequested(todoEntity: todo));
  }

  void _markAsDone(TodoEntity todo) {
    context.read<MarkTodoBloc>().add(
          MarkTodoRequested(
            todoEntity: todo.copyWith(isCompleted: !todo.isCompleted),
          ),
        );
  }

  void _showDetails(TodoEntity todo) {
    context.read<GetTodoBloc>().add(
          ShowTodoDetailsRequested(todoEntity: todo),
        );
  }

  void _filterTodo(Filter filter){
    if(context.mounted) {
      context
          .read<GetTodoBloc>()
          .add( FilterTodoRequested(filter: filter));
    }
  }

  void _deleteTodo(TodoEntity todo) {
    context.read<RemoveTodoBloc>().add(
          RemoveTodoRequested(taskId: todo.taskId),
        );
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
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Todo List'),
          actions: const [],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<AddTodoBloc>().add(
                  const OpenAddTodoDialogRequested(),
                );
            return;
          },
          child: const Icon(Icons.add),
        ),
        body: PageBody(
          controller: ScrollController(),
          constraints: BoxConstraints(
            minWidth: double.infinity,
            minHeight: media.size.height,
          ),
          child: MultiBlocListener(
            listeners: [
              BlocListener<GetTodoBloc, TodoState>(
                listener: (context, todoState) {
                  return _listenState(todoState, context);
                },
              ),
              BlocListener<AddTodoBloc, TodoState>(
                listener: (context, todoState) {
                  return _listenState(todoState, context);
                },
              ),
              BlocListener<RemoveTodoBloc, TodoState>(
                listener: (context, todoState) {
                  return _listenState(todoState, context);
                },
              ),
              BlocListener<MarkTodoBloc, TodoState>(
                listener: (context, todoState) {
                  return _listenState(todoState, context);
                },
              ),
              BlocListener<UpdateTodoBloc, TodoState>(
                listener: (context, todoState) {
                  return _listenState(todoState, context);
                },
              ),
              BlocListener<FilterTodoBloc, TodoState>(
                listener: (context, todoState) {
                  return _listenState(todoState, context);
                },
              ),
            ],
            child: BlocBuilder<
                GetTodoBloc,
                TodoState>(
              buildWhen: (previous, current) => previous!=current,
              builder: (context, state) {
                state.mayBeMap(
                  orElse: () {
                    buildPageState = TodoListBuildPageState.empty;
                    todoEntities=[];
                  },
                  getAll: (state) {
                    buildPageState = TodoListBuildPageState.loaded;
                    todoEntities = List<TodoEntity>.from(
                        state.todoEntities.toList());
                  },
                  removeAll: (state) {
                    buildPageState = TodoListBuildPageState.empty;
                  },
                  filterAll: (state) {
                    buildPageState = TodoListBuildPageState.loaded;
                    todoEntities = List<TodoEntity>.from(
                        state.todoEntities.toList());
                  },
                  empty: (state) {
                    buildPageState = TodoListBuildPageState.empty;
                  },
                  loading: (state) {
                    isTodoLoading = state.isLoading;
                    buildPageState = TodoListBuildPageState.loading;
                  },
                );
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
                         TodoFilterWidget(onFilter: _filterTodo,),
                        const Divider(),
                        Expanded(
                          child: switch (buildPageState) {
                            TodoListBuildPageState.loading => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            TodoListBuildPageState.empty => const Center(
                              child: Text('Empty'),
                            ),
                            _ => CustomScrollView(
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
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _listenState(TodoState todoState, BuildContext context) {
    return todoState.mapOrNull(
      error: (state) {},
      openAddTodoDialog: (state) {
        if (!state.hasOpened) {
          Navigator.of(context).pop();
        } else {
          Future.delayed(
            Durations.short2,
            () async => _openDialog(null),
          );
        }
      },
      openEditTodoDialog: (state) {
        if (!state.hasOpened) {
          Navigator.of(context).pop();
        } else {
          Future.delayed(
            Durations.short2,
            () async => _openDialog(state.todoEntity, isNew: false),
          );
        }
      },
      discardTodo: (state) {
        if (state.hasDiscard) {
          Navigator.of(context).pop();
        }
      },
      todoDetails: (state) {
        if (!state.hasOpened) {
          Navigator.of(context).pop();
        } else {
          Future.delayed(
            Durations.short2,
            () async => _openDialog(
              state.todoEntity,
              isNew: false,
              showMeDetails: true,
            ),
          );
        }
      },
      processing: (state) {
        isTodoProcessing = state.isProcessing;
      },
      addTodo: (state) {
        _fetchTodoList(context);
      },
      markAsDone: (state) {
        _fetchTodoList(context);
      },
      remove: (state) {
        _fetchTodoList(context);
      },
      updateTodo: (state) {
        _fetchTodoList(context);
      },
    );
  }
}

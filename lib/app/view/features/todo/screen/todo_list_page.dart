import 'dart:developer';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:todo_api/api.dart';
import 'package:todo_list_app/app/common/global_config.dart';
import 'package:todo_list_app/app/common/screen_state_enum.dart';
import 'package:todo_list_app/app/common/todo_actions.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/add_todo/add_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/get_todo/get_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/mark_todo/mark_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/remove_todo/remove_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_event.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_state.dart';
import 'package:todo_list_app/app/view/features/todo/extension/todo_state_extension.dart';
import 'package:todo_list_app/app/view/features/todo/widget/todo_filter_widget.dart';
import 'package:todo_list_app/app/view/features/todo/widget/todo_form.dart';
import 'package:todo_list_app/app/view/features/todo/widget/todo_item.dart';
import 'package:todo_list_app/app/widget/gradientText.dart';
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
  var countTotalTodo = 0;
  var countCompletedTodo = 0;
  var countPendingTodo = 0;
  List<TodoEntity> allTodos = [];
  List<TodoEntity> allPendingTodos = [];
  List<TodoEntity> allCompletedTodos = [];
  Filter currentSelectedFiler = Filter.all;

  TodoListBuildPageState buildPageState = TodoListBuildPageState.loading;

  @override
  void initState() {
    super.initState();
    _fetchTodoList(context);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final margins = GlobalConfig.responsiveInsets(media.size.width);
    final topPadding = margins;
    final maxHeight = media.size.height -
        (media.padding.top + kToolbarHeight + media.padding.bottom);
    //final bottomPadding = media.padding.bottom + margins;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: FlexColorScheme.themedSystemNavigationBar(
        context,
        useDivider: false,
      ),
      child: Scaffold(
        appBar: _TodoAppBar(),
        floatingActionButton: _TodoFloatingActionButton(
          hasTodoEmpty: allTodos.isEmpty,
        ),
        body: PageBody(
          controller: ScrollController(),
          constraints: BoxConstraints(
            minWidth: double.infinity,
            minHeight: media.size.height,
          ),
          child: _MultiBlocListener(
            key: const Key('_TodoBlocListenerKey'),
            action: _listenState,
            child: BlocBuilder<GetTodoBloc, TodoState>(
              buildWhen: (previous, current) => previous != current,
              builder: (context, state) {
                _updatePageState(state);
                return SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(
                      minWidth: double.infinity,
                      maxHeight: maxHeight,
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
                        if (buildPageState == TodoListBuildPageState.loaded ||
                            buildPageState ==
                                TodoListBuildPageState.listEmpty) ...[
                          TodoFilterWidget(
                            onFilter: _filterTodo,
                          ),
                          const Divider(),
                          _TodoSummary(
                            countCompletedTodo: countCompletedTodo,
                            countTotalTodo: countTotalTodo,
                          ),
                          const Divider(),
                        ],
                        Expanded(
                          child: _TodoListView(
                            buildPageState: buildPageState,
                            todoEntities: todoEntities,
                          ),
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

  void _fetchTodoList(BuildContext context, [Filter filter = Filter.all]) {
    if (context.mounted) {
      context.read<GetTodoBloc>().add(const GetAllTodoRequested());
    }
  }

  void _filterTodo(Filter filter) {
    currentSelectedFiler = filter;
    if (context.mounted) {
      context.read<GetTodoBloc>().add(FilterTodoRequested(filter: filter));
    }
  }

  List<TodoEntity> _getSelectedList([Filter filter = Filter.all]) {
    switch (filter) {
      case Filter.all:
        return allTodos;
      case Filter.pending:
        return allPendingTodos;
      case Filter.completed:
        return allCompletedTodos;
    }
  }

  void _listenState(BuildContext context, TodoState todoState) {
    return todoState.mapOrNull(
      error: (state) {},
      openAddTodoDialog: (state) {
        if (!state.hasOpened) {
          Navigator.of(context).pop();
        } else {
          Future.delayed(
            Durations.short2,
            () async => _openDialog(state.todoEntity, isNew: state.isNew),
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
        _fetchTodoList(context, currentSelectedFiler);
      },
      markAsDone: (state) {
        _fetchTodoList(context, currentSelectedFiler);
      },
      remove: (state) {
        _fetchTodoList(context, currentSelectedFiler);
      },
      updateTodo: (state) {
        _fetchTodoList(context, currentSelectedFiler);
      },
    );
  }

  void _updatePageState(TodoState todoState) {
    todoState.mayBeMap(
      orElse: () {
        buildPageState = TodoListBuildPageState.loaded;
      },
      yieldAllTodo: _yieldAllTodo,
      removeAll: _emptyState,
      filterAll: (state) {
        currentSelectedFiler = state.filter;
        _fetchAllTodoFromFilter();
      },
      empty: _emptyState,
      loading: (state) {
        isTodoLoading = state.isLoading;
        buildPageState = TodoListBuildPageState.loading;
      },
    );
  }

  void _yieldAllTodo(YieldAllTodoState state) {
      allTodos = List<TodoEntity>.from(state.allTodos.toList());
      allPendingTodos = List<TodoEntity>.from(state.allPendingTodos.toList());
      allCompletedTodos =
          List<TodoEntity>.from(state.allCompletedTodos.toList());

      _fetchAllTodoFromFilter();
      _countAllTodo();
    }

  void _emptyState(state) {
      buildPageState = TodoListBuildPageState.empty;
      todoEntities = [];
      allTodos = [];
      allPendingTodos = [];
      allCompletedTodos = [];
      _countAllTodo();
    }

  void _countAllTodo() {
    countTotalTodo = allTodos.length;
    countCompletedTodo = allCompletedTodos.length;
    countPendingTodo = allPendingTodos.length;
  }

  void _fetchAllTodoFromFilter() {
    todoEntities = _getSelectedList(currentSelectedFiler);
    if (todoEntities.isNotEmpty) {
      buildPageState = TodoListBuildPageState.loaded;
    } else {
      buildPageState = TodoListBuildPageState.listEmpty;
    }
  }
}

class _TodoFloatingActionButton extends StatelessWidget {
  const _TodoFloatingActionButton({required this.hasTodoEmpty});

  final bool hasTodoEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (!hasTodoEmpty) ...[
          FloatingActionButton(
            onPressed: () {
              context
                  .read<RemoveTodoBloc>()
                  .add(const RemoveAllTodoRequested());
            },
            tooltip: 'Remove all todos',
            child: const Icon(Icons.delete_forever),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
        FloatingActionButton(
          onPressed: () {
            context.read<AddTodoBloc>().add(const OpenAddTodoDialogRequested());
          },
          tooltip: 'Add Todo',
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class _TodoAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 1),
            child: SizedBox(
              height: 45,
              width: 45,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('assets/images/robo_avatar.png'),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: GradientText(
              'Prasant - Todolist',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 59, 67, 88),
                  Color.fromARGB(255, 90, 69, 69),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

typedef MultiBlocListenerAction = void Function(
  BuildContext context,
  TodoState state,
);

class _MultiBlocListener extends StatelessWidget {
  const _MultiBlocListener({
    required this.action,
    required this.child,
    super.key,
  });

  final Widget child;
  final MultiBlocListenerAction action;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetTodoBloc, TodoState>(
          listener: action,
        ),
        BlocListener<AddTodoBloc, TodoState>(
          listener: action,
        ),
        BlocListener<RemoveTodoBloc, TodoState>(
          listener: action,
        ),
        BlocListener<MarkTodoBloc, TodoState>(
          listener: action,
        ),
      ],
      child: child,
    );
  }
}

class _TodoListView extends StatefulWidget {
  const _TodoListView({
    required this.buildPageState,
    required this.todoEntities,
  });

  final TodoListBuildPageState buildPageState;
  final List<TodoEntity> todoEntities;

  @override
  State<_TodoListView> createState() => _TodoListViewState();
}

class _TodoListViewState extends State<_TodoListView> {
  void _editTodo(
    TodoEntity todo,
  ) {
    context
        .read<AddTodoBloc>()
        .add(OpenAddTodoDialogRequested(todoEntity: todo, isNew: false));
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

  void _deleteTodo(TodoEntity todo) {
    context.read<RemoveTodoBloc>().add(
          RemoveTodoRequested(taskId: todo.taskId),
        );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.buildPageState == TodoListBuildPageState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.buildPageState == TodoListBuildPageState.empty) {
      return const _TodoEmpty();
    }

    if (widget.buildPageState == TodoListBuildPageState.listEmpty) {
      return const _TodoEmpty(
        message: 'No todo found',
      );
    }

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final todo = widget.todoEntities[index];

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
            childCount: widget.todoEntities.length,
          ),
        ),
      ],
    );
  }
}

class _TodoEmpty extends StatelessWidget {
  const _TodoEmpty({
    this.message = 'No todos found. Add some tasks to get started.',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/tasks.png',
          fit: BoxFit.cover,
          height: media.size.height * 0.3,
        ),
        Text(
          message,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _TodoSummary extends StatelessWidget {
  const _TodoSummary({
    required this.countCompletedTodo,
    required this.countTotalTodo,
  });

  final int countCompletedTodo;
  final int countTotalTodo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (countTotalTodo == 0) {
      return const Offstage();
    }
    return Padding(
      padding:
          const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: StepProgressIndicator(
              totalSteps: countTotalTodo,
              currentStep: countCompletedTodo,
              size: 16,
              padding: 0,
              roundedEdges: const Radius.circular(10),
              selectedGradientColor: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.surfaceTint.withOpacity(0.5),
                  theme.colorScheme.surfaceTint,
                ],
              ),
              unselectedGradientColor: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.inversePrimary,
                  theme.colorScheme.inversePrimary,
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          AnimatedSwitcher(
            duration: Durations.medium2,
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.2, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: Text(
              '$countCompletedTodo/$countTotalTodo completed',
              key: ValueKey<int>(countCompletedTodo),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

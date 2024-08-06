import 'package:di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/add_todo/add_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/filter_todo/filter_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/get_todo/get_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/mark_todo/mark_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/remove_todo/remove_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/update_todo/update_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/screen/todo_list_page.dart';
import 'package:todo_list_app/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddTodoBloc>(
          create: (context) => DependencyProvider.get<AddTodoBloc>(),
        ),
        BlocProvider<FilterTodoBloc>(
          create: (context) => DependencyProvider.get<FilterTodoBloc>(),
        ),
        BlocProvider<RemoveTodoBloc>(
          create: (context) => DependencyProvider.get<RemoveTodoBloc>(),
        ),
        BlocProvider<MarkTodoBloc>(
          create: (context) => DependencyProvider.get<MarkTodoBloc>(),
        ),
        BlocProvider<UpdateTodoBloc>(
          create: (context) => DependencyProvider.get<UpdateTodoBloc>(),
        ),
        BlocProvider<GetTodoBloc>(
          create: (context) => DependencyProvider.get<GetTodoBloc>(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          useMaterial3: true,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: TodoListPage(),
      ),
    );
  }
}

import 'package:di/di.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_list_app/app/common/global_config.dart';
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
    const themeMode = ThemeMode.system;
    // Opt in/out on Material 3
    const useMaterial3 = true;
    const usedScheme = FlexScheme.amber;

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
        theme: FlexThemeData.light(
          scheme: usedScheme,
          appBarElevation: 1,
          visualDensity: GlobalConfig.visualDensity,
          fontFamily: GlobalConfig.fontFamily,
          textTheme: GlobalConfig.textTheme,
          typography: Typography.material2021(platform: defaultTargetPlatform),
        ),
        // Same definition for the dark theme, but using FlexThemeData.dark().
        darkTheme: FlexThemeData.dark(
          scheme: usedScheme,
          appBarElevation: 1.5,
          visualDensity: GlobalConfig.visualDensity,
          fontFamily: GlobalConfig.fontFamily,
          textTheme: GlobalConfig.textTheme,
          typography: Typography.material2021(platform: defaultTargetPlatform),
        ),
        // Use the above dark or light theme based on active themeMode.
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: TodoListPage(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/add_todo/add_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/get_todo/get_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/mark_todo/mark_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/remove_todo/remove_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_event.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_state.dart';
import 'package:todo_api/api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_list_app/app/view/features/todo/screen/todo_list_page.dart';

class MockGetTodoBloc extends Mock implements GetTodoBloc {}
class MockAddTodoBloc extends Mock implements AddTodoBloc {}
class MockMarkTodoBloc extends Mock implements MarkTodoBloc {}
class MockRemoveTodoBloc extends Mock implements RemoveTodoBloc {}

void main() {
  late MockGetTodoBloc mockGetTodoBloc;
  late MockAddTodoBloc mockAddTodoBloc;
  late MockMarkTodoBloc mockMarkTodoBloc;
  late MockRemoveTodoBloc mockRemoveTodoBloc;

  setUp(() {
    mockGetTodoBloc = MockGetTodoBloc();
    mockAddTodoBloc = MockAddTodoBloc();
    mockMarkTodoBloc = MockMarkTodoBloc();
    mockRemoveTodoBloc = MockRemoveTodoBloc();
  });

  tearDown(() {
    mockGetTodoBloc.close();
    mockAddTodoBloc.close();
    mockMarkTodoBloc.close();
    mockRemoveTodoBloc.close();
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetTodoBloc>(create: (_) => mockGetTodoBloc),
        BlocProvider<AddTodoBloc>(create: (_) => mockAddTodoBloc),
        BlocProvider<MarkTodoBloc>(create: (_) => mockMarkTodoBloc),
        BlocProvider<RemoveTodoBloc>(create: (_) => mockRemoveTodoBloc),
      ],
      child: const MaterialApp(
        home: TodoListPage(),
      ),
    );
  }

  testWidgets('renders TodoListPage with initial loading state', (tester) async {
    when(() => mockGetTodoBloc.state).thenReturn(const TodoLoading());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders empty state when there are no todos', (tester) async {
    when(() => mockGetTodoBloc.state).thenReturn(const TodoEmpty());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('No todos found. Add some tasks to get started.'), findsOneWidget);
  });

  testWidgets('renders list of todos', (tester) async {
    final todoEntities = [
      TodoEntity(title: 'Test Todo 1', description: 'Description 1', taskId: TaskId.generate(), isCompleted: false),
      TodoEntity(title: 'Test Todo 2', description: 'Description 2', taskId: TaskId.generate(), isCompleted: true),
    ];

    when(() => mockGetTodoBloc.state).thenReturn(YieldAllTodoState(allTodos: todoEntities));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Test Todo 1'), findsOneWidget);
    expect(find.text('Test Todo 2'), findsOneWidget);
  });

  testWidgets('opens add todo dialog when floating action button is pressed', (tester) async {
    when(() => mockGetTodoBloc.state).thenReturn(const TodoInitial());
    when(() => mockAddTodoBloc.state).thenReturn(const TodoInitial());

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Add todo'), findsOneWidget);
  });

  testWidgets('removes all todos when delete all button is pressed', (tester) async {
    final todoEntities = [
      TodoEntity(title: 'Test Todo 1', description: 'Description 1', taskId: TaskId.generate(), isCompleted: false),
    ];

    when(() => mockGetTodoBloc.state).thenReturn(YieldAllTodoState(allTodos: todoEntities));
    when(() => mockRemoveTodoBloc.state).thenReturn(const TodoInitial());

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byIcon(Icons.delete_forever));
    await tester.pumpAndSettle();

    verify(() => mockRemoveTodoBloc.add(const RemoveAllTodoRequested())).called(1);
  });
}
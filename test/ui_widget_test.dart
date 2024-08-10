// The initial list of to-do items is fetched successfully on initState
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_api/api.dart';
import 'package:todo_list_app/app/common/todo_actions.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/add_todo/add_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/get_todo/get_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/mark_todo/mark_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/remove_todo/remove_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_event.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_state.dart';
import 'package:todo_list_app/app/view/features/todo/screen/todo_list_page.dart';
import 'package:todo_list_app/app/view/features/todo/widget/todo_filter_widget.dart';
import 'package:todo_list_app/app/view/features/todo/widget/todo_form.dart';
import 'package:todo_list_app/app/view/features/todo/widget/todo_item.dart';
import 'package:todo_list_app/app/view/features/todo/widget/todo_item_popup_menu.dart';
import 'package:todo_list_app/app/widget/gradientText.dart';
import 'package:todo_list_app/app/widget/page_body.dart';

class MockGetTodoBloc extends Mock implements GetTodoBloc {}

class MockAddTodoBloc extends Mock implements AddTodoBloc {}

class MockMarkTodoBloc extends Mock implements MarkTodoBloc {}

class MockRemoveTodoBloc extends Mock implements RemoveTodoBloc {}

class MockTodoState extends Mock implements TodoState {}

class MockTodoEvent extends Mock implements TodoEvent {}

class MockBuildContext extends Mock implements BuildContext {}

class MockTodoFilterCallback extends Mock {
  void call(Filter filter);
}

class MockTodoActions extends Mock implements TodoActions {}

void main() {
  late MockGetTodoBloc mockGetTodoBloc;
  late MockAddTodoBloc mockAddTodoBloc;
  late MockMarkTodoBloc mockMarkTodoBloc;
  late MockRemoveTodoBloc mockRemoveTodoBloc;
  late MockTodoState mockTodoState;

  setUp(() {
    mockGetTodoBloc = MockGetTodoBloc();
    mockAddTodoBloc = MockAddTodoBloc();
    mockMarkTodoBloc = MockMarkTodoBloc();
    mockRemoveTodoBloc = MockRemoveTodoBloc();
    mockTodoState = MockTodoState();
// Mock the GetTodoBloc
    when(() => mockGetTodoBloc.state).thenReturn(const TodoInitial());

    // Mock the AddTodoBloc
    when(() => mockAddTodoBloc.state).thenReturn(const TodoInitial());

    // Mock the RemoveTodoBloc
    when(() => mockRemoveTodoBloc.state).thenReturn(const TodoInitial());

    // Mock the MarkTodoBloc
    when(() => mockMarkTodoBloc.state).thenReturn(const TodoInitial());
  });

  setUpAll(
    () {
      registerFallbackValue(MockTodoEvent());
      registerFallbackValue(Filter.all);
      registerFallbackValue(AddTodoRequested(todoEntity: TodoEntity(title: '', description: '', taskId: TaskId.generate())));
      registerFallbackValue(
        TodoEntity(
          taskId: TaskId.generate(),
          title: 'Test Todo',
          description: 'desc',
        ),
      );
    },
  );

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetTodoBloc>(create: (_) => mockGetTodoBloc),
        BlocProvider<AddTodoBloc>(create: (_) => mockAddTodoBloc),
        BlocProvider<RemoveTodoBloc>(create: (_) => mockRemoveTodoBloc),
        BlocProvider<MarkTodoBloc>(create: (_) => mockMarkTodoBloc),
      ],
      child: const MaterialApp(
        home: TodoListPage(),
      ),
    );
  }

  testWidgets('handles_null_scroll_controller_gracefully',
      (WidgetTester tester) async {
    final child = const Text('Test Child');
    final widget = PageBody(child: child, controller: null);

    final testWidget = MaterialApp(
      home: Scaffold(
        body: widget,
      ),
    );

    await tester.pumpWidget(testWidget);

    expect(find.byWidget(child), findsOneWidget);
  });

  testWidgets('handles_null_scroll_controller_gracefully',
      (WidgetTester tester) async {
    final child = const Text('Test Child');
    final widget = PageBody(child: child, controller: null);

    final testWidget = MaterialApp(
      home: Scaffold(
        body: widget,
      ),
    );

    await tester.pumpWidget(testWidget);

    expect(find.byWidget(child), findsOneWidget);
  });

  testWidgets('renders_child_within_constraints_with_different_child_widgets',
      (WidgetTester tester) async {
    final child = const Column(
      children: [
        Text('Child 1'),
        Text('Child 2'),
      ],
    );
    final widget = PageBody(child: child);

    final testWidget = MaterialApp(
      home: Scaffold(
        body: widget,
      ),
    );

    await tester.pumpWidget(testWidget);

    expect(find.byWidget(child), findsOneWidget);
  });

  testWidgets('handles_empty_text_string_gracefully',
      (WidgetTester tester) async {
    final gradient = LinearGradient(colors: [Colors.red, Colors.blue]);
    final widget = GradientText(
      '',
      gradient: gradient,
      style: TextStyle(fontSize: 20),
    );

    final testWidget = MaterialApp(
      home: Scaffold(
        body: widget,
      ),
    );

    await tester.pumpWidget(testWidget);

    final textFinder = find.text('');
    expect(textFinder, findsOneWidget);

    final shaderMaskFinder = find.byType(ShaderMask);
    expect(shaderMaskFinder, findsOneWidget);

    final shaderMaskWidget = tester.widget<ShaderMask>(shaderMaskFinder);
    expect(shaderMaskWidget.shaderCallback(Rect.zero), isNotNull);
  });

  testWidgets('displays_text_with_specified_gradient',
      (WidgetTester tester) async {
    final gradient = LinearGradient(colors: [Colors.red, Colors.blue]);
    final widget = GradientText(
      'Hello, World!',
      gradient: gradient,
      style: TextStyle(fontSize: 20),
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: widget,
      ),
    ));

    final textFinder = find.text('Hello, World!');
    expect(textFinder, findsOneWidget);

    final shaderMaskFinder = find.byType(ShaderMask);
    expect(shaderMaskFinder, findsOneWidget);

    final shaderMaskWidget = tester.widget<ShaderMask>(shaderMaskFinder);
    expect(shaderMaskWidget.shaderCallback(Rect.fromLTWH(0, 0, 100, 100)),
        isNotNull);
  });

  testWidgets('widget renders with all filter options', (WidgetTester tester) async {
    final mockCallback = MockTodoFilterCallback();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TodoFilterWidget(onFilter: mockCallback),
        ),
      ),
    );

    expect(find.byType(ChoiceChip), findsNWidgets(Filter.values.length));
    for (var filter in Filter.values) {
      expect(find.text(filter.name.capitalize), findsOneWidget);
    }
  });

  testWidgets('no filters available in enum', (WidgetTester tester) async {
    final mockCallback = MockTodoFilterCallback();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TodoFilterWidget(onFilter: mockCallback),
        ),
      ),
    );

    expect(find.byType(ChoiceChip), findsNothing);
  });

  testWidgets('choice_chip_selection_updates_state_correctly', (WidgetTester tester) async {
    // Setup
    final mockCallback = MockTodoFilterCallback();
    final widget = TodoFilterWidget(onFilter: mockCallback);

    // Pump the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: widget,
        ),
      ),
    );

    // Verify initial state
    expect(find.byType(ChoiceChip), findsNWidgets(Filter.values.length));

    // Verify filter options are rendered
    for (var filter in Filter.values) {
      expect(find.text(filter.name.capitalize), findsOneWidget);
    }

    // Simulate choice chip selection
    await tester.tap(find.byType(ChoiceChip).first);
    await tester.pump();

    // Verify state update
    verify(() => mockCallback.call(Filter.all)).called(1);
  });

  testWidgets('onFilter callback is triggered with the correct filter', (WidgetTester tester) async {
    final mockCallback = MockTodoFilterCallback();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TodoFilterWidget(onFilter: mockCallback),
        ),
      ),
    );

    for (var filter in Filter.values) {
      await tester.tap(find.text(filter.name.capitalize));
      verify(() => mockCallback(filter)).called(1);
    }
  });

  testWidgets('form_initializes_with_empty_fields', (WidgetTester tester) async {
    final mockAddTodoBloc = MockAddTodoBloc();
    final mockGetTodoBloc = MockGetTodoBloc();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider<AddTodoBloc>.value(value: mockAddTodoBloc),
              BlocProvider<GetTodoBloc>.value(value: mockGetTodoBloc),
            ],
            child: const TodoForm(),
          ),
        ),
      ),
    );

    expect(find.text(''), findsNWidgets(2));
  });

  // Form validates title and description correctly
  testWidgets('form_validates_title_and_description', (WidgetTester tester) async {
    final mockAddTodoBloc = MockAddTodoBloc();
    final mockGetTodoBloc = MockGetTodoBloc();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider<AddTodoBloc>.value(value: mockAddTodoBloc),
              BlocProvider<GetTodoBloc>.value(value: mockGetTodoBloc),
            ],
            child: const TodoForm(),
          ),
        ),
      ),
    );

    // Test form initialization
    expect(find.text('Add todo'), findsOneWidget);
    expect(find.text('Please enter a title'), findsNothing);
    expect(find.text('Please enter a description'), findsNothing);
  });

  testWidgets('displays title and description correctly', (WidgetTester tester) async {
    final todoEntity = TodoEntity(
      title: 'Test Title',
      description: 'Test Description',
      taskId: TaskId.fromUniqueString('1'),
    );

    final actions = MockTodoActions();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TodoItem(
            todoEntity: todoEntity,
            actions: actions,
          ),
        ),
      ),
    );

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
  });

  testWidgets('tapping the checkbox triggers the onMarkAsDone callback', (WidgetTester tester) async {
    final todoEntity = TodoEntity(
      title: 'Test Title',
      description: 'Test Description',
      taskId: TaskId.fromUniqueString('1'),
    );

    final actions = MockTodoActions();

    when(() => actions.onMarkAsDone(todoEntity)).thenReturn(null);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TodoItem(
            todoEntity: todoEntity,
            actions: actions,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    verify(() => actions.onMarkAsDone(todoEntity)).called(1);

  });

  testWidgets('popup_menu_displays_all_options', (WidgetTester tester) async {
    final mockActions = MockTodoActions();
    final todoEntity = TodoEntity(
      title: 'Test Task',
      description: 'Test Description',
      taskId: TaskId.fromUniqueString('1'),
      isCompleted: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TodoItemPopupMenu(
            todoEntity: todoEntity,
            actions: mockActions,
          ),
        ),
      ),
    );

    // Tap the popup menu button
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    // Verify all menu options are displayed
    expect(find.text('Task details'), findsOneWidget);
    expect(find.text('Mark as done'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Remove'), findsOneWidget);
  });

}



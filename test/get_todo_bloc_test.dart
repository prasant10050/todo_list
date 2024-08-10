import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_api/api.dart';
import 'package:todo_impl/impl.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/get_todo/get_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_event.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_state.dart';

class MockGetTodoUsecase extends Mock implements GetTodoUsecase {}

class MockGetAllTodoUsecase extends Mock implements GetAllTodoUsecase {}

class MockFilterAllTodoUsecase extends Mock implements FilterAllTodoUsecase {}

void main() {
  late GetTodoBloc getTodoBloc;
  late MockGetTodoUsecase mockGetTodoUsecase;
  late MockGetAllTodoUsecase mockGetAllTodoUsecase;
  late MockFilterAllTodoUsecase mockFilterAllTodoUsecase;

  setUpAll(() {
    registerFallbackValue(
      TodoEntity(
        taskId: TaskId.generate(),
        title: 'Test Todo',
        description: 'desc',
      ),
    );
    registerFallbackValue([
      TodoEntity(
          title: 'Task 1',
          description: 'Description 1',
          taskId: TaskId.fromUniqueString('1'),),
      TodoEntity(
          title: 'Task 2',
          description: 'Description 2',
          taskId: TaskId.fromUniqueString('2'),
          isCompleted: true,),
    ]);
    registerFallbackValue(
      TaskId.generate(),
    );
  });

  setUp(() {
    mockGetTodoUsecase = MockGetTodoUsecase();
    mockGetAllTodoUsecase = MockGetAllTodoUsecase();
    mockFilterAllTodoUsecase = MockFilterAllTodoUsecase();
    getTodoBloc = GetTodoBloc(
      getTodoUsecase: mockGetTodoUsecase,
      getAllTodoUsecase: mockGetAllTodoUsecase,
      filterAllTodoUsecase: mockFilterAllTodoUsecase,
    );
  });

  final taskId = TaskId.generate();
  final todoEntity = TodoEntity(
    title: 'Test Todo',
    description: 'Test Description',
    taskId: taskId,
  );

  final failure = const DomainFailure('Error occurred');

  final todoEntities = [
    TodoEntity(
        title: 'Task 1',
        description: 'Description 1',
        taskId: TaskId.fromUniqueString('1'),),
    TodoEntity(
        title: 'Task 2',
        description: 'Description 2',
        taskId: TaskId.fromUniqueString('2'),
        isCompleted: true,),
  ];

  final filteredTodos = [
    TodoEntity(
        title: 'Task 2',
        description: 'Description 2',
        taskId: TaskId.fromUniqueString('2'),
        isCompleted: true,),
  ];

  blocTest<GetTodoBloc, TodoState>(
    'get_todo_requested_success',
    build: () {
      when(() => mockGetTodoUsecase.call(taskId))
          .thenAnswer((_) async => Right(todoEntity));
      return getTodoBloc;
    },
    act: (bloc) => bloc.add(GetTodoRequested(taskId: taskId)),
    expect: () => [
      const TodoLoading(),
      const TodoLoading(isLoading: false),
      AddTodoSuccess(todoEntity: todoEntity),
    ],
  );

  blocTest<GetTodoBloc, TodoState>(
    'get_todo_requested_failure',
    build: () {
      when(() => mockGetTodoUsecase.call(taskId))
          .thenAnswer((_) async => Left(failure));
      return getTodoBloc;
    },
    act: (bloc) => bloc.add(GetTodoRequested(taskId: taskId)),
    expect: () => [
      const TodoLoading(),
      const TodoLoading(isLoading: false),
      TodoFailure(message: failure.message),
    ],
  );

  blocTest<GetTodoBloc, TodoState>(
    'show_todo_details_requested_emits_correct_state',
    build: () {
      return getTodoBloc;
    },
    act: (bloc) => bloc
        .add(ShowTodoDetailsRequested(todoEntity: todoEntity)),
    expect: () => [
      ShowTodoDetailsState(todoEntity: todoEntity),
    ],
  );

  blocTest<GetTodoBloc, TodoState>(
    '''
emits [TodoLoading, YieldAllTodoState] when GetAllTodoRequested is added and succeeds''',
    build: () {
      when(() => mockGetAllTodoUsecase.call())
          .thenAnswer((_) async => Right([todoEntity]));
      return getTodoBloc;
    },
    act: (bloc) => bloc.add(const GetAllTodoRequested()),
    expect: () => [
      const TodoLoading(),
      const TodoLoading(isLoading: false),
      YieldAllTodoState(
        todoEntities: [todoEntity],
        allTodos: [todoEntity],
      ),
    ],
  );

  blocTest<GetTodoBloc, TodoState>(
    'emits [TodoLoading, FilterTodoState] when FilterTodoRequested is added and succeeds',
    build: () => getTodoBloc,
    setUp: () {
      when(() => mockFilterAllTodoUsecase.call(Filter.completed))
          .thenAnswer((_) async => Right(filteredTodos));
    },
    act: (bloc) =>
        bloc.add(const FilterTodoRequested(filter: Filter.completed)),
    expect: () => [
      const TodoLoading(),
      const TodoLoading(isLoading: false),
      FilterTodoState(filter: Filter.completed, todoEntities: filteredTodos),
    ],
  );

  blocTest<GetTodoBloc, TodoState>(
    'test_execute_emits_todo_failure_on_usecase_failure',
    build: () => getTodoBloc,
    act: (bloc) {
      when(() => mockGetAllTodoUsecase.call()).thenAnswer(
          (_) async => const Left(CommonFailure('Failed to fetch todos')),);
      return bloc.add(const GetAllTodoRequested());
    },
    expect: () => [
      const TodoLoading(),
      const TodoLoading(isLoading: false),
      const TodoFailure(message: 'Failed to fetch todos'),
    ],
  );
  blocTest<GetTodoBloc, TodoState>(
    'emits [TodoLoading, AddTodoSuccess] when GetTodoRequested is added and succeeds',
    build: () {
      when(() => mockGetTodoUsecase.call(any())).thenAnswer(
        (_) async => Right(todoEntity),
      );
      return getTodoBloc;
    },
    act: (bloc) =>
        bloc.add(GetTodoRequested(taskId: TaskId.fromUniqueString('1'))),
    expect: () => [
      const TodoLoading(),
      const TodoLoading(isLoading: false),
      AddTodoSuccess(todoEntity: todoEntity),
    ],
  );

  blocTest<GetTodoBloc, TodoState>(
    'should emit failure state when usecase execution fails',
    build: () {
      when(() => mockGetTodoUsecase.call(taskId)).thenAnswer(
          (_) async => const Left(DatabaseFailure('Database error')),);
      return getTodoBloc;
    },
    act: (bloc) => bloc.add(GetTodoRequested(taskId: taskId)),
    expect: () => [
      const TodoLoading(),
      const TodoLoading(isLoading: false),
      const TodoFailure(message: 'Database error'),
    ],
  );
}

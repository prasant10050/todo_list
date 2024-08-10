import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_api/api.dart';
import 'package:todo_impl/impl.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/remove_todo/remove_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_event.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_state.dart';

class MockRemoveTodoUsecase extends Mock implements RemoveTodoUsecase {}
class MockRemoveAllTodoUsecase extends Mock implements RemoveAllTodoUsecase {}
class MockTaskId extends Mock implements TaskId {}

void main() {
  late RemoveTodoBloc removeTodoBloc;
  late MockRemoveTodoUsecase mockRemoveTodoUsecase;
  late MockRemoveAllTodoUsecase mockRemoveAllTodoUsecase;
  late MockTaskId mockTaskId;

  setUpAll(() {
    registerFallbackValue(
      TodoEntity(
        taskId: TaskId.generate(),
        title: 'Test Todo',
        description: 'desc',
      ),
    );
    registerFallbackValue(TaskId.generate(),);
  });
  setUp(() {
    mockRemoveTodoUsecase = MockRemoveTodoUsecase();
    mockRemoveAllTodoUsecase = MockRemoveAllTodoUsecase();
    mockTaskId = MockTaskId();
    removeTodoBloc = RemoveTodoBloc(
      removeTodoUsecase: mockRemoveTodoUsecase,
      removeAllTodoUsecase: mockRemoveAllTodoUsecase,
    );
  });

  blocTest<RemoveTodoBloc, TodoState>(
    'remove_todo_requested_transitions_to_remove_todo_state',
    build: () {
      when(() => mockRemoveTodoUsecase.call(any())).thenAnswer(
            (_) async => Right(null),
      );
      return removeTodoBloc;
    },
    act: (bloc) => bloc.add(RemoveTodoRequested(taskId: mockTaskId)),
    expect: () => [
      const TodoProcessing(),
      const TodoProcessing(isProcessing: false),
      const RemoveTodoState(),
    ],
  );

  blocTest<RemoveTodoBloc, TodoState>(
    'remove_all_todo_requested_transitions_to_remove_all_todo_state',
    build: () {
      when(() => mockRemoveAllTodoUsecase.call()).thenAnswer(
            (_) async => Right(null),
      );
      return removeTodoBloc;
    },
    act: (bloc) => bloc.add(RemoveAllTodoRequested()),
    expect: () => [
      const TodoProcessing(),
      const TodoProcessing(isProcessing: false),
      const RemoveAllTodoState(),
    ],
  );

  

  // Initial state is TodoInitial
  test('Initial state is TodoInitial', () {
    // Arrange
    final removeTodoUsecaseMock = MockRemoveTodoUsecase();
    final removeAllTodoUsecaseMock = MockRemoveAllTodoUsecase();
    final bloc = RemoveTodoBloc(
      removeTodoUsecase: removeTodoUsecaseMock,
      removeAllTodoUsecase: removeAllTodoUsecaseMock,
    );

    // Act

    // Assert
    expect(bloc.state, equals(const TodoInitial()));
  });

  blocTest<RemoveTodoBloc, TodoState>(
    'remove_todo_success',
    build: () {
      when(() => mockRemoveTodoUsecase.call(any())).thenAnswer((_) async => Right(null));
      return removeTodoBloc;
    },
    act: (bloc) => bloc.add(RemoveTodoRequested(taskId: TaskId.generate(),)),
    expect: () => [
      const TodoProcessing(),
      const TodoProcessing(isProcessing: false),
      const RemoveTodoState(),
    ],
  );

  blocTest<RemoveTodoBloc, TodoState>(
    'remove_todo_failure',
    build: () {
      when(() => mockRemoveTodoUsecase.call(any())).thenAnswer((_) async => Left(CommonFailure('Failed to remove todo')));
      return removeTodoBloc;
    },
    act: (bloc) => bloc.add(RemoveTodoRequested(taskId: TaskId.generate())),
    expect: () => [
      const TodoProcessing(),
      const TodoProcessing(isProcessing: false),
      const TodoFailure(message: 'Failed to remove todo'),
    ],
  );

  blocTest<RemoveTodoBloc, TodoState>(
    'test_remove_all_todo_items_successfully',
    build: () => removeTodoBloc,
    act: (bloc) {
      when(() => mockRemoveAllTodoUsecase.call()).thenAnswer((_) async => Right(null));
      bloc.add(const RemoveAllTodoRequested());
    },
    expect: () => [
      const TodoProcessing(),
      const TodoProcessing(isProcessing: false),
      const RemoveAllTodoState(),
    ],
    verify: (_) {
      verify(() => mockRemoveAllTodoUsecase.call()).called(1);
    },
  );

  blocTest<RemoveTodoBloc, TodoState>(
    'remove_todo_success',
    build: () {
      when(() => mockRemoveTodoUsecase.call(any())).thenAnswer((_) async => Right(null));
      return removeTodoBloc;
    },
    act: (bloc) => bloc.add(RemoveTodoRequested(taskId: TaskId.generate())),
    expect: () => [
      const TodoProcessing(),
      const TodoProcessing(isProcessing: false),
      const RemoveTodoState(),
    ],
  );
}
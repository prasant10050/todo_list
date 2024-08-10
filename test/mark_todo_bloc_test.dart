// Marking a todo item as done emits TodoProcessing state followed by MarkTodoState
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_api/api.dart';
import 'package:todo_impl/impl.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/mark_todo/mark_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_event.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_state.dart';

class MockMarkTodoUsecase extends Mock implements MarkTodoUsecase {}

void main() {
  late MockMarkTodoUsecase mockMarkTodoUsecase;
  late MarkTodoBloc markTodoBloc;
  late TodoEntity todoEntity;

  setUpAll(() {
    registerFallbackValue(
      TodoEntity(
        taskId: TaskId.fromUniqueString('1'),
        title: 'Test Todo',
        description: 'desc',
      ),
    );
    /*   registerFallbackValue(MockMapper());
    registerFallbackValue(MockBaseStorage());
    registerFallbackValue(MockTodoInMemoryDataSource());
    registerFallbackValue(MockTodoLocalDataSource());
    registerFallbackValue(MockTodoRepository());*/
  });

  setUp(() {
    mockMarkTodoUsecase = MockMarkTodoUsecase();
    markTodoBloc = MarkTodoBloc(markTodoUsecase: mockMarkTodoUsecase);
    todoEntity = TodoEntity(
        taskId: TaskId.fromUniqueString('1'),
        title: 'Test Todo',
        description: 'desc');
  });

  blocTest<MarkTodoBloc, TodoState>(
    'mark_todo_emits_processing_and_mark_state',
    build: () {
      when(() => mockMarkTodoUsecase.call(any())).thenAnswer(
        (_) async => Right(todoEntity),
      );
      return markTodoBloc;
    },
    act: (bloc) => bloc.add(MarkTodoRequested(todoEntity: todoEntity)),
    expect: () => [
      const TodoProcessing(),
      const TodoProcessing(isProcessing: false),
      MarkTodoState(todoEntity: todoEntity),
    ],
  );

  blocTest<MarkTodoBloc, TodoState>(
    'mark_non_existent_todo_emits_failure_state',
    build: () {
      when(() => mockMarkTodoUsecase.call(any())).thenAnswer(
        (_) async => const Left(CommonFailure('Todo not found')),
      );
      return markTodoBloc;
    },
    act: (bloc) => bloc.add(MarkTodoRequested(todoEntity: todoEntity)),
    expect: () => [
      const TodoProcessing(),
      const TodoProcessing(isProcessing: false),
      const TodoFailure(message: 'Todo not found'),
    ],
  );

  blocTest<MarkTodoBloc, TodoState>(
    'Successful marking of a todo item emits MarkTodoState',
    build: () {
      when(() => mockMarkTodoUsecase.call(todoEntity))
          .thenAnswer((_) async => Right(todoEntity));
      return markTodoBloc;
    },
    act: (bloc) => bloc.add(MarkTodoRequested(todoEntity: todoEntity)),
    expect: () => [
      const TodoProcessing(),
      const TodoProcessing(isProcessing: false),
      MarkTodoState(todoEntity: todoEntity),
    ],
  );
}

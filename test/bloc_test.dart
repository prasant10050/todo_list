// AddTodoRequested event triggers _handleAddTodo and results in AddTodoSuccess state
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_api/api.dart';
import 'package:todo_impl/impl.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/add_todo/add_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_event.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_state.dart';

class MockAddTodoUsecase extends Mock implements AddTodoUsecase {}
class MockUpdateTodoUsecase extends Mock implements UpdateTodoUsecase {}
class MockTodoEntity extends Mock implements TodoEntity {}

void main() {
  late AddTodoUsecase addTodoUsecase;
  late UpdateTodoUsecase updateTodoUsecase;
  late AddTodoBloc addTodoBloc;
  late TodoEntity todoEntity;

  setUpAll(() {
    registerFallbackValue(
      TodoEntity(
        taskId: TaskId.generate(),
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
    addTodoUsecase = MockAddTodoUsecase();
    updateTodoUsecase = MockUpdateTodoUsecase();
    addTodoBloc = AddTodoBloc(
      addTodoUsecase: addTodoUsecase,
      updateTodoUsecase: updateTodoUsecase,
    );
    todoEntity = MockTodoEntity();
  });

  blocTest<AddTodoBloc, TodoState>(
    'add_todo_requested_triggers_handle_add_todo_and_results_in_add_todo_success',
    build: () {
      when(() => addTodoUsecase.call(any())).thenAnswer(
            (_) async => Right(todoEntity),
      );
      return addTodoBloc;
    },
    act: (bloc) => bloc.add(AddTodoRequested(todoEntity: todoEntity)),
    expect: () => [
      const TodoProcessing(),
      const TodoProcessing(isProcessing: false),
      AddTodoSuccess(todoEntity: todoEntity),
      const OpenAddTodoDialogState(hasOpened: false, isNew: true),
    ],
  );

  blocTest<AddTodoBloc, TodoState>(
    'UpdateTodoRequested event triggers _handleUpdateTodo and results in UpdateTodoState',
    build: () {
      when(() => updateTodoUsecase.call(any())).thenAnswer(
            (_) async => Right(todoEntity),
      );
      return addTodoBloc;
    },
    act: (bloc) => bloc.add(UpdateTodoRequested(todoEntity: todoEntity)),
    expect: () => [
      const TodoProcessing(),
      const TodoProcessing(isProcessing: false),
      UpdateTodoState(todoEntity: todoEntity),
      OpenAddTodoDialogState(hasOpened: false, todoEntity: todoEntity, isNew: false),
    ],
  );
}
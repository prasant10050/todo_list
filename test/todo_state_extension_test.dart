// Correctly maps TodoLoading state
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_api/api.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_state.dart';
import 'package:todo_list_app/app/view/features/todo/extension/todo_state_extension.dart';

class UnknownState extends TodoState {
  const UnknownState();

  @override
  List<Object?> get props => [];
}

void main() {
  test('map correctly maps TodoLoading state', () {
    const state = TodoLoading();
    final result = state.map(
      loading: (s) => 'loading',
      processing: (s) => 'processing',
      empty: (s) => 'empty',
      error: (s) => 'error',
      remove: (s) => 'remove',
      removeAll: (s) => 'removeAll',
      getById: (s) => 'getById',
      yieldAllTodo: (s) => 'yieldAllTodo',
      addTodo: (s) => 'addTodo',
      updateTodo: (s) => 'updateTodo',
      markAsDone: (s) => 'markAsDone',
      filterAll: (s) => 'filterAll',
      openAddTodoDialog: (s) => 'openAddTodoDialog',
      discardTodo: (s) => 'discardTodo',
      openEditTodoDialog: (s) => 'openEditTodoDialog',
      todoDetails: (s) => 'todoDetails',
      orElse: () => 'orElse',
    );
    expect(result, 'loading');
  });

  test('map handles unknown state with orElse function', () {
    const state = UnknownState();
    final result = state.map(
      loading: (s) => 'loading',
      processing: (s) => 'processing',
      empty: (s) => 'empty',
      error: (s) => 'error',
      remove: (s) => 'remove',
      removeAll: (s) => 'removeAll',
      getById: (s) => 'getById',
      yieldAllTodo: (s) => 'yieldAllTodo',
      addTodo: (s) => 'addTodo',
      updateTodo: (s) => 'updateTodo',
      markAsDone: (s) => 'markAsDone',
      filterAll: (s) => 'filterAll',
      openAddTodoDialog: (s) => 'openAddTodoDialog',
      discardTodo: (s) => 'discardTodo',
      openEditTodoDialog: (s) => 'openEditTodoDialog',
      todoDetails: (s) => 'todoDetails',
      orElse: () => 'orElse',
    );
    expect(result, 'orElse');
  });

  test('handles null callback for TodoLoading state', () {
    const state = TodoLoading();
    final result = state.mapOrNull(
      loading: null,
      processing: (s) => 'processing',
      empty: (s) => 'empty',
      error: (s) => 'error',
      remove: (s) => 'remove',
      removeAll: (s) => 'removeAll',
      getById: (s) => 'getById',
      yieldAllTodo: (s) => 'yieldAllTodo',
      addTodo: (s) => 'addTodo',
      updateTodo: (s) => 'updateTodo',
      markAsDone: (s) => 'markAsDone',
      filterAll: (s) => 'filterAll',
      openAddTodoDialog: (s) => 'openAddTodoDialog',
      discardTodo: (s) => 'discardTodo',
      openEditTodoDialog: (s) => 'openEditTodoDialog',
      todoDetails: (s) => 'todoDetails',
    );
    expect(result, null);
  });

  // Handles missing optional callbacks in mayBeMap function
  test('Handles missing optional callbacks in mayBeMap function', () {
    const state = TodoLoading();
    final result = state.mayBeMap(
      loading: (s) => 'loading',
      processing: (s) => 'processing',
      empty: (s) => 'empty',
      error: (s) => 'error',
      remove: (s) => 'remove',
      removeAll: (s) => 'removeAll',
      getById: (s) => 'getById',
      yieldAllTodo: (s) => 'yieldAllTodo',
      addTodo: (s) => 'addTodo',
      updateTodo: (s) => 'updateTodo',
      markAsDone: (s) => 'markAsDone',
      filterAll: (s) => 'filterAll',
      openAddTodoDialog: (s) => 'openAddTodoDialog',
      discardTodo: (s) => 'discardTodo',
      openEditTodoDialog: (s) => 'openEditTodoDialog',
      todoDetails: (s) => 'todoDetails',
      orElse: () => 'orElse',
    );
    expect(result, 'loading');
  });

  test('test_correctly_maps_yield_all_todo_state', () {
    // Arrange
    final state = YieldAllTodoState(
      todoEntities: [
        TodoEntity(
          title: 'Task 1',
          description: 'Description 1',
          taskId: TaskId.fromUniqueString('1'),
        ),
      ],
      allTodos: [
        TodoEntity(
          title: 'Task 1',
          description: 'Description 1',
          taskId: TaskId.fromUniqueString('1'),
        ),
      ],
      allPendingTodos: [
        TodoEntity(
          title: 'Task 1',
          description: 'Description 1',
          taskId: TaskId.fromUniqueString('1'),
        ),
      ],
      allCompletedTodos: [
        TodoEntity(
          title: 'Task 1',
          description: 'Description 1',
          taskId: TaskId.fromUniqueString('1'),
        ),
      ],
    );

    // Act
    final result = state.map(
      loading: (s) => 'loading',
      processing: (s) => 'processing',
      empty: (s) => 'empty',
      error: (s) => 'error',
      remove: (s) => 'remove',
      removeAll: (s) => 'removeAll',
      getById: (s) => 'getById',
      yieldAllTodo: (s) => 'yieldAllTodo',
      addTodo: (s) => 'addTodo',
      updateTodo: (s) => 'updateTodo',
      markAsDone: (s) => 'markAsDone',
      filterAll: (s) => 'filterAll',
      openAddTodoDialog: (s) => 'openAddTodoDialog',
      discardTodo: (s) => 'discardTodo',
      openEditTodoDialog: (s) => 'openEditTodoDialog',
      todoDetails: (s) => 'todoDetails',
      orElse: () => 'orElse',
    );

    // Assert
    expect(result, 'yieldAllTodo');
  });
}

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_impl/impl.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_event.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_state.dart';

class AddTodoBloc extends Bloc<TodoEvent, TodoState> {
  AddTodoBloc({required this.addTodoUsecase}) : super(const TodoInitial()) {
    on<AddTodoRequested>(_handleAddTodo);
    on<OpenAddTodoDialogRequested>(_handleOpenAddTodoDialog);
    on<DiscardTodoDialogRequested>(_handleDiscardTodoDialog);
  }

  final AddTodoUsecase addTodoUsecase;

  Future<void> _handleAddTodo(
    AddTodoRequested event,
    Emitter<TodoState> emit,
  ) async {
    emit(const OpenAddTodoDialogState(hasOpened: false));
    await Future.delayed(Durations.medium2, () {});
    emit(const TodoProcessing());
    final result = await addTodoUsecase(event.todoEntity);
    emit(const TodoProcessing(isProcessing: false));

    return result.fold(
      (left) => emit(TodoFailure(message: left.message)),
      (right) => emit(AddTodoSuccess(todoEntity: right)),
    );
  }

  void _handleOpenAddTodoDialog(
    OpenAddTodoDialogRequested event,
    Emitter<TodoState> emit,
  ) {
    emit(OpenAddTodoDialogState(hasOpened: event.hasOpened));
  }

  void _handleDiscardTodoDialog(
    DiscardTodoDialogRequested event,
    Emitter<TodoState> emit,
  ) {
    emit(DiscardTodoDialogState(hasDiscard: event.hasDiscard));
  }
}

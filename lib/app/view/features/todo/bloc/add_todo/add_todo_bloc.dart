import 'package:bloc/bloc.dart';
import 'package:todo_impl/impl.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_event.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_state.dart';

class AddTodoBloc extends Bloc<TodoEvent, TodoState> {
  AddTodoBloc({required this.addTodoUsecase}) : super(TodoInitial()) {
    on<AddTodoRequested>(_handleAddTodo);
    on<OpenAddTodoDialogRequested>(_handleOpenAddTodoDialog);
    on<DiscardTodoDialogRequested>(_handleDiscardTodoDialog);
  }

  final AddTodoUsecase addTodoUsecase;

  Future<void> _handleAddTodo(
    AddTodoRequested event,
    Emitter<TodoState> emit,
  ) async {
    emit(const TodoProcessing());
    final result = await addTodoUsecase(event.todoEntity);
    emit(const TodoProcessing(isProcessing: false));

    result.fold(
      (left) => emit(TodoFailure(message: left.message)),
      (right) => emit(AddTodoSuccess(todoEntity: right)),
    );
  }

  Future<void> _handleOpenAddTodoDialog(
    OpenAddTodoDialogRequested event,
    Emitter<TodoState> emit,
  ) async {
    emit(OpenAddTodoDialogState(hasOpened: event.hasOpened));
  }

  Future<void> _handleDiscardTodoDialog(
    DiscardTodoDialogRequested event,
    Emitter<TodoState> emit,
  ) async {
    emit(DiscardTodoDialogState(hasDiscard: event.hasDiscard));
  }
}

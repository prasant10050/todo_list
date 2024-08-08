import 'package:bloc/bloc.dart';
import 'package:todo_impl/impl.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_event.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_state.dart';

class UpdateTodoBloc extends Bloc<TodoEvent, TodoState> {
  UpdateTodoBloc({required this.updateTodoUsecase})
      : super(const TodoInitial()) {
    // event: Update `todo`
    on<UpdateTodoRequested>(_handleUpdateTodo);
    on<OpenEditTodoDialogRequested>(_handleOpenEditTodoDialog);
  }

  final UpdateTodoUsecase updateTodoUsecase;

  Future<void> _handleUpdateTodo(
    UpdateTodoRequested event,
    Emitter<TodoState> emit,
  ) async {
    emit(const TodoProcessing());
    final result = await updateTodoUsecase(event.todoEntity);
    emit(const TodoProcessing(isProcessing: false));

    result.fold(
      (left) => emit(TodoFailure(message: left.message)),
      (right) => emit(UpdateTodoState(todoEntity: right)),
    );
  }

  Future<void> _handleOpenEditTodoDialog(
    OpenEditTodoDialogRequested event,
    Emitter<TodoState> emit,
  ) async {
    emit(
      OpenEditTodoDialogState(
        hasOpened: event.hasOpened,
        todoEntity: event.todoEntity,
      ),
    );
  }
}

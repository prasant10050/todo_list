import 'package:bloc/bloc.dart';
import 'package:todo_impl/impl.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_event.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_state.dart';

class AddTodoBloc extends Bloc<TodoEvent, TodoState> {
  AddTodoBloc({required this.addTodoUsecase, required this.updateTodoUsecase})
      : super(const TodoInitial()) {
    on<AddTodoRequested>(_handleAddTodo);
    on<UpdateTodoRequested>(_handleUpdateTodo);
    on<OpenAddTodoDialogRequested>(_handleOpenAddTodoDialog);
    on<DiscardTodoDialogRequested>(_handleDiscardTodoDialog);
  }

  final AddTodoUsecase addTodoUsecase;
  final UpdateTodoUsecase updateTodoUsecase;

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
    emit(const OpenAddTodoDialogState(hasOpened: false, isNew: true));
  }

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
    emit(
      OpenAddTodoDialogState(
        hasOpened: false,
        todoEntity: event.todoEntity,
        isNew: false,
      ),
    );
  }

  void _handleOpenAddTodoDialog(
    OpenAddTodoDialogRequested event,
    Emitter<TodoState> emit,
  ) {
    emit(
      OpenAddTodoDialogState(
        hasOpened: event.hasOpened,
        todoEntity: event.todoEntity,
        isNew: event.isNew,
      ),
    );
  }

  void _handleDiscardTodoDialog(
    DiscardTodoDialogRequested event,
    Emitter<TodoState> emit,
  ) {
    emit(DiscardTodoDialogState(hasDiscard: event.hasDiscard));
  }
}

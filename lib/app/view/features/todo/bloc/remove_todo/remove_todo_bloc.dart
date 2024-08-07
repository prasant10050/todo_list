import 'package:bloc/bloc.dart';
import 'package:todo_api/api.dart';
import 'package:todo_impl/impl.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_event.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_state.dart';

class RemoveTodoBloc extends Bloc<TodoEvent, TodoState> {
  RemoveTodoBloc({
    required this.removeTodoUsecase,
    required this.removeAllTodoUsecase,
  }) : super(TodoInitial()) {
    on<RemoveTodoRequested>(_handleRemoveTodo);
    on<RemoveAllTodoRequested>(_handleRemoveAllTodos);
  }

  final RemoveTodoUsecase removeTodoUsecase;
  final RemoveAllTodoUsecase removeAllTodoUsecase;

  Future<void> _handleRemoveTodo(
    RemoveTodoRequested event,
    Emitter<TodoState> emit,
  ) async {
    await _execute<Failure, void>(
      emit,
      () => removeTodoUsecase(event.taskId),
      const RemoveTodoState(),
    );
  }

  Future<void> _handleRemoveAllTodos(
    RemoveAllTodoRequested event,
    Emitter<TodoState> emit,
  ) async {
    await _execute<Failure, void>(
      emit,
      removeAllTodoUsecase.call,
      const RemoveAllTodoState(),
    );
  }

  Future<void> _execute<L, R>(
    Emitter<TodoState> emit,
    Future<Either<L, R>> Function() usecase,
    TodoState successState,
  ) async {
    emit(const TodoProcessing());
    final result = await usecase();
    emit(const TodoProcessing(isProcessing: false));

    result.fold(
      (left) => emit(TodoFailure(message: (left as Failure).message)),
      (right) => emit(successState),
    );
  }
}

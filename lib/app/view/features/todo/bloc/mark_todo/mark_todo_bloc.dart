import 'package:bloc/bloc.dart';
import 'package:todo_impl/impl.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_event.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_state.dart';

class MarkTodoBloc extends Bloc<TodoEvent, TodoState> {
  MarkTodoBloc({required this.markTodoUsecase}) : super(TodoInitial()) {
    // event: Mark done or not done `todo`
    on<MarkTodoRequested>(_handleMarkTodo);
  }

  final MarkTodoUsecase markTodoUsecase;

  Future<void> _handleMarkTodo(
    MarkTodoRequested event,
    Emitter<TodoState> emit,
  ) async {
    emit(const TodoProcessing());
    final result = await markTodoUsecase(event.todoEntity);
    emit(const TodoProcessing(isProcessing: false));

    result.fold(
      (left) => emit(TodoFailure(message: left.message)),
      (right) => emit(MarkTodoState(todoEntity: right)),
    );
  }
}

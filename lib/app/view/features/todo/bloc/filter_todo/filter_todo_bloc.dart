import 'package:bloc/bloc.dart';
import 'package:todo_api/api.dart';
import 'package:todo_impl/impl.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_event.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_state.dart';

class FilterTodoBloc extends Bloc<TodoEvent, TodoState> {
  FilterTodoBloc({required this.filterAllTodoUsecase}) : super(TodoInitial()) {
    on<FilterTodoRequested>(_handleFilterAllTodos);
  }

  final FilterAllTodoUsecase filterAllTodoUsecase;

  Future<void> _handleFilterAllTodos(
    FilterTodoRequested event,
    Emitter<TodoState> emit,
  ) async {
    await _execute<Failure, List<TodoEntity>>(
      emit,
      () => filterAllTodoUsecase(event.filter),
      (right) => right.isEmpty
          ? const TodoEmpty()
          : FilterTodoState(todoEntities: right.toList(), filter: event.filter),
    );
  }

  Future<void> _execute<L, R>(
    Emitter<TodoState> emit,
    Future<Either<L, R>> Function() usecase,
    TodoState Function(R) onSuccess,
  ) async {
    emit(const TodoLoading());
    final result = await usecase();
    emit(const TodoLoading(isLoading: false));

    result.fold(
      (left) {
        emit(TodoFailure(message: (left as Failure).message));
      },
      (right) => emit(onSuccess(right)),
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:todo_api/api.dart';
import 'package:todo_impl/impl.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_event.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_state.dart';

class GetTodoBloc extends Bloc<TodoEvent, TodoState> {
  GetTodoBloc({
    required this.getAllTodoUsecase,
    required this.getTodoUsecase,
    required this.filterAllTodoUsecase,
  }) : super(const TodoInitial()) {
    on<GetTodoRequested>(_handleGetTodo);
    on<GetAllTodoRequested>(_handleGetAllTodos);
    on<ShowTodoDetailsRequested>(_handleShowTodoDetails);
    on<FilterTodoRequested>(_handleFilterAllTodos);
  }

  final GetTodoUsecase getTodoUsecase;
  final GetAllTodoUsecase getAllTodoUsecase;
  final FilterAllTodoUsecase filterAllTodoUsecase;

  Future<void> _handleGetTodo(
    GetTodoRequested event,
    Emitter<TodoState> emit,
  ) async {
    await _execute<Failure, TodoEntity>(
      emit,
      () => getTodoUsecase(event.taskId),
      (right) => AddTodoSuccess(todoEntity: right),
    );
  }

  Future<void> _handleGetAllTodos(
    GetAllTodoRequested event,
    Emitter<TodoState> emit,
  ) async {
    await _execute<Failure, List<TodoEntity>>(
      emit,
      getAllTodoUsecase.call,
      (right) {
        if (right.isEmpty) {
          return const TodoEmpty();
        } else {
          final todos = List<TodoEntity>.from(right.toList(growable: false));
          final allCompletedTodo =
              todos.where((task) => task.isCompleted).toList(growable: false);
          final allPendingTodo =
              todos.where((task) => !task.isCompleted).toList(growable: false);
          return YieldAllTodoState(
            todoEntities: right.toList(),
            allTodos: todos,
            allCompletedTodos: allCompletedTodo,
            allPendingTodos: allPendingTodo,
          );
        }
      },
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

    return result.fold(
      (left) {
        emit(TodoFailure(message: (left as Failure).message));
      },
      (right) => emit(onSuccess(right)),
    );
  }

  Future<void> _handleShowTodoDetails(
    ShowTodoDetailsRequested event,
    Emitter<TodoState> emit,
  ) async {
    emit(
      ShowTodoDetailsState(
        hasOpened: event.hasOpened,
        todoEntity: event.todoEntity,
      ),
    );
  }

  Future<void> _handleFilterAllTodos(
    FilterTodoRequested event,
    Emitter<TodoState> emit,
  ) async {
    await _execute<Failure, List<TodoEntity>>(
      emit,
      () => filterAllTodoUsecase(event.filter),
      (right) =>
          FilterTodoState(todoEntities: right.toList(), filter: event.filter),
    );
  }
}

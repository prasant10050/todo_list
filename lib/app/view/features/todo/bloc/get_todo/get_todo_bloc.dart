import 'package:bloc/bloc.dart';
import 'package:todo_api/api.dart';
import 'package:todo_impl/impl.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_event.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/todo_state.dart';

class GetTodoBloc extends Bloc<TodoEvent, TodoState> {
  GetTodoBloc({required this.getAllTodoUsecase, required this.getTodoUsecase})
      : super(const TodoInitial()) {
    on<GetTodoRequested>(_handleGetTodo);
    on<GetAllTodoRequested>(_handleGetAllTodos);
    on<ShowTodoDetailsRequested>(_handleShowTodoDetails);
  }

  final GetTodoUsecase getTodoUsecase;
  final GetAllTodoUsecase getAllTodoUsecase;

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
      (right) => right.isEmpty
          ? const TodoEmpty()
          : GetAllTodoState(todoEntities: right.toList()),
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
    emit(ShowTodoDetailsState(
        hasOpened: event.hasOpened, todoEntity: event.todoEntity,),);
  }
}

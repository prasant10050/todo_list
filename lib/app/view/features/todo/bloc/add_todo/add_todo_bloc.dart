import 'package:bloc/bloc.dart';
import 'package:todo_api/api.dart';
import 'package:todo_list_app/app/view/features/todo_event.dart';
import 'package:todo_list_app/app/view/features/todo_state.dart';

class AddTodoBloc extends Bloc<TodoEvent, TodoState> {
  AddTodoBloc({required this.addTodoUsecase}) : super(TodoInitial()) {
    on<TodoEvent>((event, emit) async {
      if (event is AddTodoRequested) {
        emit(const AddTodoLoading(isLoading: true));
        final result = await addTodoUsecase(event.todoEntity);
        emit(const AddTodoLoading(isLoading: false));
        result.fold(
          (left) {
            emit(TodoFailure(message: left.message));
          },
          (right) {
            emit(AddTodoSuccess(todoEntity: right));
          },
        );
      }
    });
  }

  final IAddTodoUsecase addTodoUsecase;
}

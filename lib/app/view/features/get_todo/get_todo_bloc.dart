import 'package:bloc/bloc.dart';
import 'package:todo_api/api.dart';
import 'package:todo_list_app/app/view/features/todo_event.dart';
import 'package:todo_list_app/app/view/features/todo_state.dart';

class GetTodoBloc extends Bloc<TodoEvent, TodoState> {
  GetTodoBloc({required this.getAllTodoUsecase, required this.getTodoUsecase})
      : super(TodoInitial()) {
    on<TodoEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  final IGetTodoUsecase getTodoUsecase;
  final IGetAllTodoUsecase getAllTodoUsecase;
}

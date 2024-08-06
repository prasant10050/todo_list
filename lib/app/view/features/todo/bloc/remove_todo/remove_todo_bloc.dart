import 'package:bloc/bloc.dart';
import 'package:todo_api/api.dart';
import 'package:todo_list_app/app/view/features/todo_event.dart';
import 'package:todo_list_app/app/view/features/todo_state.dart';

class RemoveTodoBloc extends Bloc<TodoEvent, TodoState> {
  RemoveTodoBloc(
      {required this.removeTodoUsecase, required this.removeAllTodoUsecase})
      : super(TodoInitial()) {
    on<TodoEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  final IRemoveTodoUsecase removeTodoUsecase;
  final IRemoveAllTodoUsecase removeAllTodoUsecase;
}

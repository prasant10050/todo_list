import 'package:bloc/bloc.dart';
import 'package:todo_api/api.dart';
import 'package:todo_list_app/app/view/features/todo_event.dart';
import 'package:todo_list_app/app/view/features/todo_state.dart';

class UpdateTodoBloc extends Bloc<TodoEvent, TodoState> {
  UpdateTodoBloc({required this.updateTodoUsecase}) : super(TodoInitial()) {
    on<TodoEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  final IUpdateTodoUsecase updateTodoUsecase;
}

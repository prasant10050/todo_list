import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'update_todo_event.dart';
part 'update_todo_state.dart';

class UpdateTodoBloc extends Bloc<UpdateTodoEvent, UpdateTodoState> {
  UpdateTodoBloc() : super(UpdateTodoInitial()) {
    on<UpdateTodoEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

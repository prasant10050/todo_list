part of 'update_todo_bloc.dart';

sealed class UpdateTodoState extends Equatable {
  const UpdateTodoState();
}

final class UpdateTodoInitial extends UpdateTodoState {
  @override
  List<Object> get props => [];
}

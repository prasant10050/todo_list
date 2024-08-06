import 'package:equatable/equatable.dart';
import 'package:todo_api/api.dart';

abstract class TodoState extends Equatable {
  const TodoState();
}

final class TodoInitial extends TodoState {
  @override
  List<Object> get props => [];
}

final class AddTodoLoading extends TodoState {
  const AddTodoLoading({required this.isLoading});

  final bool isLoading;

  @override
  List<Object> get props => [isLoading];
}

final class AddTodoSuccess extends TodoState {
  const AddTodoSuccess({required this.todoEntity});

  final TodoEntity todoEntity;

  @override
  List<Object> get props => [todoEntity];
}

final class TodoFailure extends TodoState {
  const TodoFailure({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

final class RemoveTodoState extends TodoState {
  const RemoveTodoState({this.message = 'Todo remove successfully'});

  final String message;

  @override
  List<Object?> get props => [message];
}

final class RemoveAllTodoState extends TodoState {
  const RemoveAllTodoState({this.message = 'Remove all todo successfully'});

  final String message;

  @override
  List<Object?> get props => [message];
}

final class GetTodoState extends TodoState {
  const GetTodoState({required this.todoEntity});

  final TodoEntity todoEntity;

  @override
  List<Object?> get props => [todoEntity];
}

final class GetAllTodoState extends TodoState {
  const GetAllTodoState({this.todoEntities = const []});

  final List<TodoEntity> todoEntities;

  @override
  List<Object?> get props => [todoEntities];
}

final class MarkTodoState extends TodoState {
  const MarkTodoState({
    required this.todoEntity,
  });

  final TodoEntity todoEntity;

  @override
  List<Object?> get props => [todoEntity];
}

final class UpdateTodoState extends TodoState {
  const UpdateTodoState({
    required this.todoEntity,
    this.message = 'Todo update successfully',
  });

  final TodoEntity todoEntity;
  final String message;

  @override
  List<Object?> get props => [todoEntity];
}

final class FilterTodoState extends TodoState {
  const FilterTodoState({
    required this.filter,
    this.todoEntities = const [],
  });

  final Filter filter;
  final List<TodoEntity> todoEntities;

  @override
  List<Object?> get props => [filter, todoEntities];
}

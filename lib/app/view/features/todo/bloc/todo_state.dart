import 'package:equatable/equatable.dart';
import 'package:todo_api/api.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {
  const TodoInitial();

  @override
  List<Object> get props => [];
}

class TodoLoading extends TodoState {
  const TodoLoading({this.isLoading = true});

  final bool isLoading;

  @override
  List<Object> get props => [isLoading];
}

class TodoProcessing extends TodoState {
  const TodoProcessing({this.isProcessing = true});

  final bool isProcessing;

  @override
  List<Object> get props => [isProcessing];
}

class TodoEmpty extends TodoState {
  const TodoEmpty({this.message = 'Todo is empty'});

  final String message;

  @override
  List<Object> get props => [message];
}

class AddTodoSuccess extends TodoState {
  const AddTodoSuccess({required this.todoEntity});

  final TodoEntity todoEntity;

  @override
  List<Object> get props => [todoEntity];
}

class TodoFailure extends TodoState {
  const TodoFailure({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

class RemoveTodoState extends TodoState {
  const RemoveTodoState({this.message = 'Todo remove successfully'});

  final String message;

  @override
  List<Object?> get props => [message];
}

class RemoveAllTodoState extends TodoState {
  const RemoveAllTodoState({this.message = 'Remove all todo successfully'});

  final String message;

  @override
  List<Object?> get props => [message];
}

class GetTodoState extends TodoState {
  const GetTodoState({required this.todoEntity});

  final TodoEntity todoEntity;

  @override
  List<Object?> get props => [todoEntity];
}

class GetAllTodoState extends TodoState {
  const GetAllTodoState({this.todoEntities = const []});

  final List<TodoEntity> todoEntities;

  @override
  List<Object?> get props => [todoEntities];
}

class MarkTodoState extends TodoState {
  const MarkTodoState({
    required this.todoEntity,
  });

  final TodoEntity todoEntity;

  @override
  List<Object?> get props => [todoEntity];
}

class UpdateTodoState extends TodoState {
  const UpdateTodoState({
    required this.todoEntity,
    this.message = 'Todo update successfully',
  });

  final TodoEntity todoEntity;
  final String message;

  @override
  List<Object?> get props => [todoEntity];
}

class FilterTodoState extends TodoState {
  const FilterTodoState({
    required this.filter,
    this.todoEntities = const [],
  });

  final Filter filter;
  final List<TodoEntity> todoEntities;

  @override
  List<Object?> get props => [filter, todoEntities];
}

class OpenAddTodoDialogState extends TodoState {
  const OpenAddTodoDialogState({
    this.hasOpened = true,
    this.todoEntity,
    this.isNew = true,
  });

  final bool hasOpened;
  final TodoEntity? todoEntity;
  final bool isNew;

  @override
  List<Object?> get props => [hasOpened, todoEntity,isNew];
}

class DiscardTodoDialogState extends TodoState {
  const DiscardTodoDialogState({this.hasDiscard = true});

  final bool hasDiscard;

  @override
  List<Object?> get props => [hasDiscard];
}

class OpenEditTodoDialogState extends TodoState {
  const OpenEditTodoDialogState({
    required this.todoEntity,
    this.hasOpened = true,
  });

  final bool hasOpened;
  final TodoEntity todoEntity;

  @override
  List<Object?> get props => [hasOpened, todoEntity];
}

class ShowTodoDetailsState extends TodoState {
  const ShowTodoDetailsState({required this.todoEntity, this.hasOpened = true});

  final bool hasOpened;
  final TodoEntity todoEntity;

  @override
  List<Object?> get props => [hasOpened, todoEntity];
}

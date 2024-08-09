import 'package:equatable/equatable.dart';
import 'package:todo_api/api.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class AddTodoRequested extends TodoEvent {
  const AddTodoRequested({required this.todoEntity});

  final TodoEntity todoEntity;

  @override
  List<Object?> get props => [todoEntity];
}

class RemoveTodoRequested extends TodoEvent {
  const RemoveTodoRequested({required this.taskId});

  final TaskId taskId;

  @override
  List<Object?> get props => [taskId];
}

class RemoveAllTodoRequested extends TodoEvent {
  const RemoveAllTodoRequested();

  @override
  List<Object?> get props => [];
}

class GetTodoRequested extends TodoEvent {
  const GetTodoRequested({required this.taskId});

  final TaskId taskId;

  @override
  List<Object?> get props => [taskId];
}

class GetAllTodoRequested extends TodoEvent {
  const GetAllTodoRequested();

  @override
  List<Object?> get props => [];
}

class MarkTodoRequested extends TodoEvent {
  const MarkTodoRequested({
    required this.todoEntity,
  });

  final TodoEntity todoEntity;

  @override
  List<Object?> get props => [todoEntity];
}

class UpdateTodoRequested extends TodoEvent {
  const UpdateTodoRequested({
    required this.todoEntity,
  });

  final TodoEntity todoEntity;

  @override
  List<Object?> get props => [todoEntity];
}

class FilterTodoRequested extends TodoEvent {
  const FilterTodoRequested({
    required this.filter,
  });

  final Filter filter;

  @override
  List<Object?> get props => [filter];
}

class OpenAddTodoDialogRequested extends TodoEvent {
  const OpenAddTodoDialogRequested({
    this.hasOpened = true,
    this.todoEntity,
    this.isNew = true,
  });

  final bool hasOpened;
  final TodoEntity? todoEntity;
  final bool isNew;

  @override
  List<Object?> get props => [hasOpened, todoEntity, isNew];
}

class OpenEditTodoDialogRequested extends TodoEvent {
  const OpenEditTodoDialogRequested({
    required this.todoEntity,
    this.hasOpened = true,
  });

  final bool hasOpened;
  final TodoEntity todoEntity;

  @override
  List<Object?> get props => [hasOpened, todoEntity];
}

class ShowTodoDetailsRequested extends TodoEvent {
  const ShowTodoDetailsRequested(
      {required this.todoEntity, this.hasOpened = true});

  final bool hasOpened;
  final TodoEntity todoEntity;

  @override
  List<Object?> get props => [hasOpened, todoEntity];
}

class DiscardTodoDialogRequested extends TodoEvent {
  const DiscardTodoDialogRequested({this.hasDiscard = true});

  final bool hasDiscard;

  @override
  List<Object?> get props => [hasDiscard];
}

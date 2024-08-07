import 'package:equatable/equatable.dart';
import 'package:todo_api/api.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();
}

final class AddTodoRequested extends TodoEvent {
  const AddTodoRequested({required this.todoEntity});

  final TodoEntity todoEntity;

  @override
  List<Object?> get props => [todoEntity];
}

final class RemoveTodoRequested extends TodoEvent {
  const RemoveTodoRequested({required this.taskId});

  final TaskId taskId;

  @override
  List<Object?> get props => [taskId];
}

final class RemoveAllTodoRequested extends TodoEvent {
  const RemoveAllTodoRequested();

  @override
  List<Object?> get props => [];
}

final class GetTodoRequested extends TodoEvent {
  const GetTodoRequested({required this.taskId});

  final TaskId taskId;

  @override
  List<Object?> get props => [taskId];
}

final class GetAllTodoRequested extends TodoEvent {
  const GetAllTodoRequested();

  @override
  List<Object?> get props => [];
}

final class MarkTodoRequested extends TodoEvent {
  const MarkTodoRequested({
    required this.todoEntity,
  });

  final TodoEntity todoEntity;

  @override
  List<Object?> get props => [todoEntity];
}

final class UpdateTodoRequested extends TodoEvent {
  const UpdateTodoRequested({
    required this.todoEntity,
  });

  final TodoEntity todoEntity;

  @override
  List<Object?> get props => [todoEntity];
}

final class FilterTodoRequested extends TodoEvent {
  const FilterTodoRequested({
    required this.filter,
  });

  final Filter filter;

  @override
  List<Object?> get props => [filter];
}

final class OpenAddTodoDialogRequested extends TodoEvent {
  const OpenAddTodoDialogRequested({this.hasOpened=true});
  final bool hasOpened;
  @override
  List<Object?> get props => [hasOpened];
}

final class OpenEditTodoDialogRequested extends TodoEvent {
  const OpenEditTodoDialogRequested({this.hasOpened=true});
  final bool hasOpened;
  @override
  List<Object?> get props => [hasOpened];
}

final class ShowTodoDetailsRequested extends TodoEvent {
  const ShowTodoDetailsRequested({this.hasOpened=true});
  final bool hasOpened;
  @override
  List<Object?> get props => [hasOpened];
}

final class DiscardTodoDialogRequested extends TodoEvent {
  const DiscardTodoDialogRequested({this.hasDiscard=true});
  final bool hasDiscard;
  @override
  List<Object?> get props => [hasDiscard];
}

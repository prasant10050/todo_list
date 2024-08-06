import 'package:domain/domain.dart';
import 'package:domain/src/error/failure.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_api/api.dart';
import 'package:todo_impl/src/domain/mapper/todo_mapper.dart';

class TodoInMemoryDataSource implements ITodoDataSource {
  TodoInMemoryDataSource({required this.mapper});

  final List<TodoDto> _tasks = [];
  final Mapper<TodoEntity,TodoDto> mapper;

  @override
  Future<Either<Failure, TodoDto>> addTodo(TodoEntity todoEntity) async {
    try {
      final id = const Uuid().v4();
      final todo = todoEntity.copyWith(taskId: TaskId.fromUniqueString(id));
      final result = mapper.mapFromEntity(todo);
      _tasks.add(result);
      return Right(result);
    } catch (e) {
      debugPrint('AddTodo exception: $e');
      return const Left(DatabaseFailure('Could not add todo: {}'));
    }
  }

  @override
  Future<Either<Failure, List<TodoDto>>> getAllTodos() async {
    try {
      final todoList = _tasks.toList();
      return Right(todoList);
    } catch (e) {
      debugPrint('GetAllTodo exception: $e');
      return const Left(DatabaseFailure('Could not get all todos: {}'));
    }
  }

  @override
  Future<Either<Failure, TodoDto>> getTodo(TaskId todoId) async {
    try {
      final cacheTodoId = todoId.getOrThrow();
      final defaultTodo = TodoDto(
        title: '',
        description: '',
        taskId: TaskId.fromUniqueString(''),
      );
      final result = _tasks.firstWhere(
        (element) => element.taskId == todoId,
        orElse: () => defaultTodo,
      );
      if (result.taskId.getOrThrow().isEmpty) {
        return const Left(DatabaseFailure('Could not get todo: {}'));
      }
      return Right(result);
    } catch (e) {
      debugPrint('GetTodo exception: $e');
      return const Left(DatabaseFailure('Could not get todo: {}'));
    }
  }

  @override
  Future<Either<Failure, TodoDto>> markTodo(
    TaskId todoId,
    TodoEntity todoEntity,
  ) async {
    try {
      final id = todoEntity.taskId.getOrThrow();
      final index = _tasks.indexWhere((element) => element.taskId == todoId);
      _tasks[index] = mapper.mapFromEntity(todoEntity);
      return Right(_tasks[index]);
    } catch (e) {
      debugPrint('MarkTodo exception: $e');
      return const Left(DatabaseFailure('Could not mark todo: {}'));
    }
  }

  @override
  Future<Either<Failure, void>> removeAllTodos() async {
    try {
      return Right(_tasks.clear());
    } catch (e) {
      debugPrint('RemoveAllTodos exception: $e');
      return const Left(DatabaseFailure('Could not add todo: {}'));
    }
  }

  @override
  Future<Either<Failure, void>> removeTodo(TaskId todoId) async {
    try {
      final id = todoId.getOrThrow();
      return Right(_tasks.removeWhere((item) => item.taskId == todoId));
    } catch (e) {
      debugPrint('RemoveTodo exception: $e');
      return const Left(DatabaseFailure('Could not delete todo: {}'));
    }
  }

  @override
  Future<Either<Failure, TodoDto>> updateTodo(TodoEntity todoEntity) async {
    try {
      final index =
          _tasks.indexWhere((element) => element.taskId == todoEntity.taskId);
      _tasks[index] = mapper.mapFromEntity(todoEntity);
      return Right(_tasks[index]);
    } catch (e) {
      debugPrint('UpdateTodo exception: $e');
      return const Left(DatabaseFailure('Could not update todo: {}'));
    }
  }
}

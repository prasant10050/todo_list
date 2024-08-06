import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:domain/src/error/failure.dart';
import 'package:either_dart/src/either.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_api/api.dart';
import 'package:todo_impl/src/domain/mapper/todo_mapper.dart';

class TodoLocalDataSource implements ITodoDataSource {
  TodoLocalDataSource({required this.storage, required this.mapper});

  final BaseStorage<TodoEntity, TodoDto> storage;
  final Mapper<TodoEntity,TodoDto> mapper;

  @override
  Future<Either<Failure, TodoDto>> addTodo(TodoEntity todoEntity) async {
    try {
      final id = await storage.put(todoEntity);
      final result = mapper.mapFromEntity(
          todoEntity.copyWith(taskId: TaskId.fromUniqueString(id)));
      return Right(result);
    } catch (e) {
      debugPrint('AddTodo exception: $e');
      return const Left(DatabaseFailure('Could not add todo: {}'));
    }
  }

  @override
  Future<Either<Failure, List<TodoDto>>> getAllTodos() async {
    try {
      final todoList = await storage.getAll();
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
      final todo = await storage.getByKey(cacheTodoId);
      if (todo == null) {
        return const Left(DatabaseFailure('Could not get todo: {}'));
      }
      final result = mapper.mapFromEntity(todo);
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
      final todo = await storage.update(id, todoEntity);
      return Right(todo);
    } catch (e) {
      debugPrint('MarkTodo exception: $e');
      return const Left(DatabaseFailure('Could not mark todo: {}'));
    }
  }

  @override
  Future<Either<Failure, void>> removeAllTodos() async {
    try {
      return Right(storage.clear());
    } catch (e) {
      debugPrint('RemoveAllTodos exception: $e');
      return const Left(DatabaseFailure('Could not add todo: {}'));
    }
  }

  @override
  Future<Either<Failure, void>> removeTodo(TaskId todoId) async {
    try {
      final id = todoId.getOrThrow();
      return Right(await storage.delete(id));
    } catch (e) {
      debugPrint('RemoveTodo exception: $e');
      return const Left(DatabaseFailure('Could not delete todo: {}'));
    }
  }

  @override
  Future<Either<Failure, TodoDto>> updateTodo(TodoEntity todoEntity) async {
    try {
      final id = todoEntity.taskId.getOrThrow();
      final todo = await storage.update(id, todoEntity);
      //final result = mapper.mapFromEntity(todoEntity.copyWith(taskId: TaskId.fromUniqueString(id)));
      return Right(todo);
    } catch (e) {
      debugPrint('UpdateTodo exception: $e');
      return const Left(DatabaseFailure('Could not update todo: {}'));
    }
  }
}

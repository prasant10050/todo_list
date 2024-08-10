import 'dart:async';

import 'package:data/data.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_api/api.dart';

class TodoLocalDataSource implements ITodoDataSource {
  TodoLocalDataSource({required this.storage, required this.mapper});

  final BaseStorage storage;
  final Mapper<TodoEntity, TodoDto> mapper;

  @override
  Future<Either<Failure, TodoDto>> addTodo(TodoEntity todoEntity) async {
    try {
      final newTaskId = TaskId.generate();
      final copyEntity = todoEntity.copyWith(taskId: newTaskId);
      await storage.put(newTaskId.value, copyEntity.toMap());
      final result = mapper.mapFromEntity(copyEntity);
      return Right(result);
    } catch (e) {
      debugPrint('AddTodo exception: $e');
      return const Left(DatabaseFailure('Could not add todo: {}'));
    }
  }

  @override
  Future<Either<Failure, List<TodoDto>>> getAllTodos() async {
    try {
      final result = await storage.getAllValuesInMap();
      if (result == null) {
        return const Right([]);
      }
      final todoList = <TodoDto>[];
      for (final element in result.entries) {
        todoList.add(TodoDto.fromMap(element.value as Map<String, dynamic>));
      }
      return Right(todoList);
    } catch (e) {
      debugPrint('GetAllTodo exception: $e');
      return const Left(DatabaseFailure('Could not get all todos: {}'));
    }
  }

  @override
  Future<Either<Failure, TodoDto>> getTodo(TaskId todoId) async {
    try {
      final cacheTodoId = todoId.value;
      final todo = await storage.getByKey(cacheTodoId);
      if (todo == null) {
        return const Left(DatabaseFailure('Could not get todo: {}'));
      }
      final result = TodoDto.fromMap(todo as Map<String, dynamic>);
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
      final id = todoEntity.taskId.value;
      await storage.update(id, todoEntity.toMap());
      return Right(mapper.mapFromEntity(todoEntity));
    } catch (e) {
      debugPrint('MarkTodo exception: $e');
      return const Left(DatabaseFailure('Could not mark todo: {}'));
    }
  }

  @override
  Future<Either<Failure, void>> removeAllTodos() async {
    try {
      return Right(await storage.clear());
    } catch (e) {
      debugPrint('RemoveAllTodos exception: $e');
      return const Left(DatabaseFailure('Could not add todo: {}'));
    }
  }

  @override
  Future<Either<Failure, void>> removeTodo(TaskId todoId) async {
    try {
      final id = todoId.value;
      return Right(await storage.delete(id));
    } catch (e) {
      debugPrint('RemoveTodo exception: $e');
      return const Left(DatabaseFailure('Could not delete todo: {}'));
    }
  }

  @override
  Future<Either<Failure, TodoDto>> updateTodo(TodoEntity todoEntity) async {
    try {
      final id = todoEntity.taskId.value;
      await storage.update(id, todoEntity.toMap());
      return Right(mapper.mapFromEntity(todoEntity));
    } catch (e) {
      debugPrint('UpdateTodo exception: $e');
      return const Left(DatabaseFailure('Could not update todo: {}'));
    }
  }
}

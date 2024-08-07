import 'package:domain/domain.dart';
import 'package:either_dart/either.dart';
import 'package:todo_api/api.dart';

abstract class ITodoRepository {
  Future<Either<Failure, TodoEntity>> addTodo(TodoEntity todoEntity);

  Future<Either<Failure, TodoEntity>> updateTodo(TodoEntity todoEntity);

  Future<Either<Failure, void>> removeTodo(TaskId todoId);

  Future<Either<Failure, void>> removeAllTodos();

  Future<Either<Failure, TodoEntity>> getTodo(TaskId todoId);

  Future<Either<Failure, List<TodoEntity>>> getAllTodos();

  Future<Either<Failure, TodoEntity>> markTodo(
    TaskId todoId,
    TodoEntity todoEntity,
  );
}

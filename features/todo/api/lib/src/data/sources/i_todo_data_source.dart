import 'package:domain/domain.dart';
import 'package:either_dart/either.dart';
import 'package:todo_api/api.dart';

abstract interface class ITodoDataSource {
  Future<Either<Failure, TodoDto>> addTodo(TodoEntity todoEntity);

  Future<Either<Failure, TodoDto>> updateTodo(TodoEntity todoEntity);

  Future<Either<Failure, void>> removeTodo(TaskId todoId);

  Future<Either<Failure, void>> removeAllTodos();

  Future<Either<Failure, TodoDto>> getTodo(TaskId todoId);

  Future<Either<Failure, List<TodoDto>>> getAllTodos();

  Future<Either<Failure, TodoDto>> markTodo(
    TaskId todoId,
    TodoEntity todoEntity,
  );
}

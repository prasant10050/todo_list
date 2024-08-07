import 'package:domain/domain.dart';
import 'package:todo_api/api.dart';

class TodoRepository implements ITodoRepository {
  TodoRepository({required this.dataSource, required this.mapper});

  final ITodoDataSource dataSource;
  final Mapper<TodoEntity, TodoDto> mapper;

  @override
  Future<Either<Failure, TodoEntity>> addTodo(TodoEntity todoEntity) async {
    final result = await dataSource.addTodo(todoEntity);
    return result.fold(
      (left) {
        return Left(DomainFailure(left.message));
      },
      (right) {
        return Right(mapper.mapToEntity(right));
      },
    );
  }

  @override
  Future<Either<Failure, List<TodoEntity>>> getAllTodos() async {
    final result = await dataSource.getAllTodos();
    return result.fold(
      (left) {
        return Left(DomainFailure(left.message));
      },
      (right) {
        final data = List<TodoEntity>.from(
          right.map(
            mapper.mapToEntity,
          ),
        ).toList();
        return Right(data);
      },
    );
  }

  @override
  Future<Either<Failure, TodoEntity>> getTodo(TaskId todoId) async {
    final result = await dataSource.getTodo(todoId);
    return result.fold(
      (left) {
        return Left(DomainFailure(left.message));
      },
      (right) {
        return Right(mapper.mapToEntity(right));
      },
    );
  }

  @override
  Future<Either<Failure, TodoEntity>> markTodo(
    TaskId todoId,
    TodoEntity todoEntity,
  ) async {
    final result = await dataSource.markTodo(todoId, todoEntity);
    return result.fold(
      (left) {
        return Left(DomainFailure(left.message));
      },
      (right) {
        return Right(mapper.mapToEntity(right));
      },
    );
  }

  @override
  Future<Either<Failure, void>> removeAllTodos() async {
    final result = await dataSource.removeAllTodos();
    return result.fold(
      (left) {
        return Left(DomainFailure(left.message));
      },
      (right) {
        return Right(right);
      },
    );
  }

  @override
  Future<Either<Failure, void>> removeTodo(TaskId todoId) async {
    final result = await dataSource.removeTodo(todoId);
    return result.fold(
      (left) {
        return Left(DomainFailure(left.message));
      },
      (right) {
        return Right(right);
      },
    );
  }

  @override
  Future<Either<Failure, TodoEntity>> updateTodo(TodoEntity todoEntity) async {
    final result = await dataSource.updateTodo(todoEntity);
    return result.fold(
      (left) {
        return Left(DomainFailure(left.message));
      },
      (right) {
        return Right(mapper.mapToEntity(right));
      },
    );
  }
}

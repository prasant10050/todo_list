import 'package:domain/domain.dart';
import 'package:either_dart/src/either.dart';
import 'package:todo_api/api.dart';

class UpdateTodoUsecase extends IUpdateTodoUsecase{
  UpdateTodoUsecase(this.repository);

  final ITodoRepository repository;
  @override
  Future<Either<Failure, TodoEntity>> call(TodoEntity params) async{
    return repository.updateTodo(params);
  }

}
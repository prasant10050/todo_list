import 'package:domain/domain.dart';
import 'package:either_dart/src/either.dart';
import 'package:todo_api/api.dart';

class GetTodoUsecase extends IGetTodoUsecase {
  GetTodoUsecase(this.repository);

  final ITodoRepository repository;
  @override
  Future<Either<Failure, TodoEntity>> call(TaskId params) async{
    return repository.getTodo(params);
  }
}

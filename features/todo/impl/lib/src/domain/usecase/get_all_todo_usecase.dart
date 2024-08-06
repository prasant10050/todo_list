import 'package:domain/domain.dart';
import 'package:either_dart/src/either.dart';
import 'package:todo_api/api.dart';

class GetAllTodoUsecase extends IGetAllTodoUsecase {
  GetAllTodoUsecase(this.repository);

  final ITodoRepository repository;

  @override
  Future<Either<Failure, List<TodoEntity>>> call() async{
    return repository.getAllTodos();
  }
}

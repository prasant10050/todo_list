import 'package:domain/domain.dart';
import 'package:either_dart/src/either.dart';
import 'package:todo_api/api.dart';

class RemoveAllTodoUsecase extends IRemoveAllTodoUsecase{
  RemoveAllTodoUsecase(this.repository);

  final ITodoRepository repository;
  @override
  Future<Either<Failure, void>> call() async{
    return repository.removeAllTodos();
  }

}
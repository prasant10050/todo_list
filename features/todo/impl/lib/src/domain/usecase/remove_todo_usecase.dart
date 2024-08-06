import 'package:domain/domain.dart';
import 'package:either_dart/src/either.dart';
import 'package:todo_api/api.dart';

class RemoveTodoUsecase extends IRemoveTodoUsecase{
  RemoveTodoUsecase(this.repository);

  final ITodoRepository repository;
  @override
  Future<Either<Failure, void>> call(TaskId params) async{
    return repository.removeTodo(params);
  }

}
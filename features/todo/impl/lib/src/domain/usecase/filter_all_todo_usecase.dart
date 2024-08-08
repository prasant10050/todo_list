import 'package:todo_api/api.dart';
import 'package:todo_impl/impl.dart';

class FilterAllTodoUsecase extends IFilterAllTodoUsecase {
  FilterAllTodoUsecase({required this.getAllTodoUsecase});

  final GetAllTodoUsecase getAllTodoUsecase;

  @override
  Future<Either<Failure, List<TodoEntity>>> call(Filter params) async{
    return getAllTodoUsecase.call().fold(
      Left.new,
      (data) {
        switch (params) {
          case Filter.completed:
            return Right(data.where((task) => task.isCompleted).toList());
          case Filter.pending:
            return Right(data.where((task) => !task.isCompleted).toList());
          case Filter.all:
            return Right(data);
        }
      },
    );
  }
}

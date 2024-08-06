import 'package:domain/domain.dart';
import 'package:todo_api/api.dart';

class FilterAllTodoUsecase extends IFilterAllTodoUsecase {
  FilterAllTodoUsecase({required this.getAllTodoUsecase});

  final IGetAllTodoUsecase getAllTodoUsecase;

  @override
  Future<Either<Failure, List<TodoEntity>>> call(Filter params) {
    return getAllTodoUsecase().fold(
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

import 'package:domain/domain.dart';
import 'package:todo_api/api.dart';
enum Filter { all, completed, pending }
abstract class IFilterAllTodoUsecase extends UseCase<List<TodoEntity>,Filter>{}
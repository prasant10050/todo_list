import 'package:di/di.dart';
import 'package:todo_impl/impl.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/add_todo/add_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/get_todo/get_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/mark_todo/mark_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/remove_todo/remove_todo_bloc.dart';

class ApplicationDependenciesModuleResolver {
  static const String inMemory = 'in-memory';
  static const String local = 'local';

  static void register({bool isMemory = true}) {
    _registerFeatures(isMemory: isMemory);
    _registerBlocProviders(isMemory: isMemory);
  }

  static void _registerFeatures({bool isMemory = true}) {
    TodoDependencyModuleResolver.register(isMemory: isMemory);
  }

  static Future<void> _registerBlocProviders({bool isMemory = true}) async {
    DependencyProvider.registerFactory<AddTodoBloc>(
      () => AddTodoBloc(
        addTodoUsecase: DependencyProvider.get<AddTodoUsecase>(
          instanceName: isMemory ? inMemory : local,
        ),
        updateTodoUsecase: DependencyProvider.get<UpdateTodoUsecase>(
          instanceName: isMemory ? inMemory : local,
        ),
      ),
    );
    DependencyProvider.registerFactory<GetTodoBloc>(
      () => GetTodoBloc(
        getTodoUsecase: DependencyProvider.get<GetTodoUsecase>(
          instanceName: isMemory ? inMemory : local,
        ),
        getAllTodoUsecase: DependencyProvider.get<GetAllTodoUsecase>(
          instanceName: isMemory ? inMemory : local,
        ),
        filterAllTodoUsecase: DependencyProvider.get<FilterAllTodoUsecase>(
          instanceName: isMemory ? inMemory : local,
        ),
      ),
    );
    DependencyProvider.registerFactory<MarkTodoBloc>(
      () => MarkTodoBloc(
        markTodoUsecase: DependencyProvider.get<MarkTodoUsecase>(
          instanceName: isMemory ? inMemory : local,
        ),
      ),
    );
    DependencyProvider.registerFactory<RemoveTodoBloc>(
      () => RemoveTodoBloc(
        removeTodoUsecase: DependencyProvider.get<RemoveTodoUsecase>(
          instanceName: isMemory ? inMemory : local,
        ),
        removeAllTodoUsecase: DependencyProvider.get<RemoveAllTodoUsecase>(
          instanceName: isMemory ? inMemory : local,
        ),
      ),
    );
  }
}

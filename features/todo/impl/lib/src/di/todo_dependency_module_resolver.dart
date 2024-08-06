import 'package:data/data.dart';
import 'package:di/di.dart';
import 'package:domain/domain.dart';
import 'package:todo_api/api.dart';
import 'package:todo_impl/impl.dart';

class TodoDependencyModuleResolver {
  static const String inMemory = 'in-memory';
  static const String local = 'local';

  static void register({bool isMemory = false}) {
    _registerTodoDependencies(isMemory: isMemory);
  }

  static void _registerTodoDependencies({bool isMemory = false}) {
    // Mapper
    DependencyProvider.registerLazySingleton<Mapper<TodoEntity, TodoDto>>(
      TodoMapper.new,
    );

    // Local Storage
    DependencyProvider.registerLazySingleton<BaseStorage<TodoEntity, TodoDto>>(
      SecureLocalStorage.new,
    );

    // Data Sources
    DependencyProvider.registerLazySingleton<ITodoDataSource>(
      () => TodoInMemoryDataSource(
        mapper: DependencyProvider.get<Mapper<TodoEntity, TodoDto>>(),
      ),
      instanceName: inMemory,
    );
    DependencyProvider.registerLazySingleton<ITodoDataSource>(
      () => TodoLocalDataSource(
        mapper: DependencyProvider.get<Mapper<TodoEntity, TodoDto>>(),
        storage: DependencyProvider.get<BaseStorage<TodoEntity, TodoDto>>(),
      ),
      instanceName: local,
    );

    // Repository
    DependencyProvider.registerLazySingleton<ITodoRepository>(
      () => TodoRepository(
        dataSource: DependencyProvider.get<ITodoDataSource>(
          instanceName: isMemory ? inMemory : local,
        ),
        mapper: DependencyProvider.get<Mapper<TodoEntity, TodoDto>>(),
      ),
    );

    // UseCase
    DependencyProvider.registerLazySingleton<IAddTodoUsecase>(
      () => AddTodoUsecase(
        DependencyProvider.get<ITodoRepository>(
          instanceName: isMemory ? inMemory : local,
        ),
      ),
    );
    DependencyProvider.registerLazySingleton<IGetAllTodoUsecase>(
      () => GetAllTodoUsecase(
        DependencyProvider.get<ITodoRepository>(
          instanceName: isMemory ? inMemory : local,
        ),
      ),
    );
    DependencyProvider.registerLazySingleton<IFilterAllTodoUsecase>(
      () => FilterAllTodoUsecase(
        getAllTodoUsecase: DependencyProvider.get<IGetAllTodoUsecase>(
          instanceName: isMemory ? inMemory : local,
        ),
      ),
    );
    DependencyProvider.registerLazySingleton<IGetTodoUsecase>(
      () => GetTodoUsecase(
        DependencyProvider.get<ITodoRepository>(
          instanceName: isMemory ? inMemory : local,
        ),
      ),
    );
    DependencyProvider.registerLazySingleton<IMarkTodoUsecase>(
      () => MarkTodoUsecase(
        DependencyProvider.get<ITodoRepository>(
          instanceName: isMemory ? inMemory : local,
        ),
      ),
    );
    DependencyProvider.registerLazySingleton<IRemoveAllTodoUsecase>(
      () => RemoveAllTodoUsecase(
        DependencyProvider.get<ITodoRepository>(
          instanceName: isMemory ? inMemory : local,
        ),
      ),
    );
    DependencyProvider.registerLazySingleton<IRemoveTodoUsecase>(
      () => RemoveTodoUsecase(
        DependencyProvider.get<ITodoRepository>(
          instanceName: isMemory ? inMemory : local,
        ),
      ),
    );
    DependencyProvider.registerLazySingleton<IUpdateTodoUsecase>(
      () => UpdateTodoUsecase(
        DependencyProvider.get<ITodoRepository>(
          instanceName: isMemory ? inMemory : local,
        ),
      ),
    );
  }
}

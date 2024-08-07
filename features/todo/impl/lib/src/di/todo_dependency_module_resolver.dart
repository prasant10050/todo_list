import 'package:data/data.dart';
import 'package:di/di.dart';
import 'package:domain/domain.dart';
import 'package:todo_api/api.dart';
import 'package:todo_impl/impl.dart';

class TodoDependencyModuleResolver {
  static const String inMemory = 'in-memory';
  static const String local = 'local';

  static void register({bool isMemory = false}) {
    _registerTodoDataDependencies(isMemory: isMemory);
    _registerTodoDomainDependencies(isMemory: isMemory);
  }

  static void _registerTodoDataDependencies({bool isMemory = false}) {
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
      ()=>TodoInMemoryDataSource(
        mapper: DependencyProvider.get<Mapper<TodoEntity, TodoDto>>(),
      ),
      instanceName: inMemory,
    );
    DependencyProvider.registerLazySingleton<ITodoDataSource>(
          ()=>TodoLocalDataSource(
        mapper: DependencyProvider.get<Mapper<TodoEntity, TodoDto>>(),
        storage: DependencyProvider.get<BaseStorage<TodoEntity, TodoDto>>(),
      ),
      instanceName: local,
    );

    // Repository
    DependencyProvider.registerLazySingleton<ITodoRepository>(
          ()=>TodoRepository(
        dataSource: DependencyProvider.get<ITodoDataSource>(
          instanceName: isMemory ? inMemory : local,
        ),
        mapper: DependencyProvider.get<Mapper<TodoEntity, TodoDto>>(),
      ),
      instanceName: isMemory ? inMemory : local,
    );
  }

  static void _registerTodoDomainDependencies({bool isMemory = false}) {
    // UseCase
    DependencyProvider.registerLazySingleton<AddTodoUsecase>(
          ()=>AddTodoUsecase(
        DependencyProvider.get<ITodoRepository>(
          instanceName: isMemory ? inMemory : local,
        ),
      ),
      instanceName: isMemory ? inMemory : local,
    );
    DependencyProvider.registerLazySingleton<GetAllTodoUsecase>(
          ()=>GetAllTodoUsecase(
        DependencyProvider.get<ITodoRepository>(
          instanceName: isMemory ? inMemory : local,
        ),
      ),
      instanceName: isMemory ? inMemory : local,
    );
    DependencyProvider.registerLazySingleton<FilterAllTodoUsecase>(
      () => FilterAllTodoUsecase(
        getAllTodoUsecase: DependencyProvider.get<GetAllTodoUsecase>(
          instanceName: isMemory ? inMemory : local,
        ),
      ),
      instanceName: isMemory ? inMemory : local,
    );
    DependencyProvider.registerLazySingleton<GetTodoUsecase>(
          ()=>GetTodoUsecase(
        DependencyProvider.get<ITodoRepository>(
          instanceName: isMemory ? inMemory : local,
        ),
      ),
      instanceName: isMemory ? inMemory : local,
    );
    DependencyProvider.registerLazySingleton<MarkTodoUsecase>(
      () => MarkTodoUsecase(
        DependencyProvider.get<ITodoRepository>(
          instanceName: isMemory ? inMemory : local,
        ),
      ),
      instanceName: isMemory ? inMemory : local,
    );
    DependencyProvider.registerLazySingleton<RemoveAllTodoUsecase>(
      () => RemoveAllTodoUsecase(
        DependencyProvider.get<ITodoRepository>(
          instanceName: isMemory ? inMemory : local,
        ),
      ),
      instanceName: isMemory ? inMemory : local,
    );
    DependencyProvider.registerLazySingleton<RemoveTodoUsecase>(
      () => RemoveTodoUsecase(
        DependencyProvider.get<ITodoRepository>(
          instanceName: isMemory ? inMemory : local,
        ),
      ),
      instanceName: isMemory ? inMemory : local,
    );
    DependencyProvider.registerLazySingleton<UpdateTodoUsecase>(
      () => UpdateTodoUsecase(
        DependencyProvider.get<ITodoRepository>(
          instanceName: isMemory ? inMemory : local,
        ),
      ),
      instanceName: isMemory ? inMemory : local,
    );
  }
}

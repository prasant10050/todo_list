// Register dependencies with in-memory storage
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:di/di.dart';
import 'package:todo_impl/impl.dart';
import 'package:todo_api/api.dart';
import 'package:data/data.dart';

class MockMapper extends Mock implements Mapper<TodoEntity, TodoDto> {}
class MockBaseStorage extends Mock implements BaseStorage {}
class MockTodoInMemoryDataSource extends Mock implements TodoInMemoryDataSource {}
class MockTodoLocalDataSource extends Mock implements TodoLocalDataSource {}
class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(MockMapper());
    registerFallbackValue(MockBaseStorage());
    registerFallbackValue(MockTodoInMemoryDataSource());
    registerFallbackValue(MockTodoLocalDataSource());
    registerFallbackValue(MockTodoRepository());
  });

  test('register_with_in_memory_storage', () async {
    await TodoDependencyModuleResolver.register(isMemory: true);

    final mapper = DependencyProvider.get<Mapper<TodoEntity, TodoDto>>();
    final dataSource = DependencyProvider.get<ITodoDataSource>(instanceName: 'in-memory');
    final repository = DependencyProvider.get<ITodoRepository>(instanceName: 'in-memory');

    expect(mapper, isA<TodoMapper>());
    expect(dataSource, isA<TodoInMemoryDataSource>());
    expect(repository, isA<TodoRepository>());
  });

  test('register_with_null_values', () async {
    await TodoDependencyModuleResolver.register(isMemory: false);

    final mapper = DependencyProvider.get<Mapper<TodoEntity, TodoDto>>();
    final dataSource = DependencyProvider.get<ITodoDataSource>(instanceName: 'local');
    final repository = DependencyProvider.get<ITodoRepository>(instanceName: 'local');

    expect(mapper, isA<TodoMapper>());
    expect(dataSource, isA<TodoLocalDataSource>());
    expect(repository, isA<TodoRepository>());
  });

  test ('test_retrieve_registered_add_todo_usecase_instance',() {
    final mockTodoRepository = MockTodoRepository();
    final mockAddTodoUsecase = AddTodoUsecase(mockTodoRepository);

    DependencyProvider.registerLazySingleton<AddTodoUsecase>(() => mockAddTodoUsecase);

    final retrievedAddTodoUsecase = DependencyProvider.get<AddTodoUsecase>();

    expect(retrievedAddTodoUsecase, equals(mockAddTodoUsecase));
  });

  test ('test_retrieve_registered_mark_todo_usecase_instance',() {
    // Setup
    final mockTodoRepository = MockTodoRepository();
    final mockMarkTodoUsecase = MarkTodoUsecase(mockTodoRepository);
    DependencyProvider.registerLazySingleton<MarkTodoUsecase>(() => mockMarkTodoUsecase);

    // Test
    final retrievedMarkTodoUsecase = DependencyProvider.get<MarkTodoUsecase>();

    // Verify
    expect(retrievedMarkTodoUsecase, equals(mockMarkTodoUsecase));
  });

  test ('retrieve_registered_get_all_todo_usecase_instance_test',() {
    // Arrange
    final mockTodoRepository = MockTodoRepository();
    final mockMarkTodoUsecase = GetAllTodoUsecase(mockTodoRepository);
    DependencyProvider.registerLazySingleton<GetAllTodoUsecase>(() => mockMarkTodoUsecase);
    // Assert
    final getAllTodoUsecase = DependencyProvider.get<GetAllTodoUsecase>();

    expect(getAllTodoUsecase, isA<GetAllTodoUsecase>());
  });
}
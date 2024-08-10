// Registering dependencies with invalid storage type
import 'package:di/di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_impl/impl.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/add_todo/add_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/get_todo/get_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/mark_todo/mark_todo_bloc.dart';
import 'package:todo_list_app/app/view/features/todo/bloc/remove_todo/remove_todo_bloc.dart';
import 'package:todo_list_app/di/application_dependencies_module_resolver.dart';

class MockAddTodoUsecase extends Mock implements AddTodoUsecase {}
class MockUpdateTodoUsecase extends Mock implements UpdateTodoUsecase {}
class MockGetTodoUsecase extends Mock implements GetTodoUsecase {}
class MockGetAllTodoUsecase extends Mock implements GetAllTodoUsecase {}
class MockFilterAllTodoUsecase extends Mock implements FilterAllTodoUsecase {}
class MockMarkTodoUsecase extends Mock implements MarkTodoUsecase {}
class MockRemoveTodoUsecase extends Mock implements RemoveTodoUsecase {}
class MockRemoveAllTodoUsecase extends Mock implements RemoveAllTodoUsecase {}

void main() {
  test('should register dependencies with local storage', () {
    // Arrange

    // Act
    ApplicationDependenciesModuleResolver.register();

    // Assert
    expect(DependencyProvider.isRegistered<AddTodoBloc>(instanceName: 'local'),
        true,);
    expect(DependencyProvider.isRegistered<GetTodoBloc>(instanceName: 'local'),
        true,);
    expect(DependencyProvider.isRegistered<MarkTodoBloc>(instanceName: 'local'),
        true,);
    expect(
        DependencyProvider.isRegistered<RemoveTodoBloc>(instanceName: 'local'),
        true,);
  });

  test('register dependencies in memory mode', () async {
    // Arrange
    final addTodoUsecase = MockAddTodoUsecase();
    final updateTodoUsecase = MockUpdateTodoUsecase();
    final getTodoUsecase = MockGetTodoUsecase();
    final getAllTodoUsecase = MockGetAllTodoUsecase();
    final filterAllTodoUsecase = MockFilterAllTodoUsecase();
    final markTodoUsecase = MockMarkTodoUsecase();
    final removeTodoUsecase = MockRemoveTodoUsecase();
    final removeAllTodoUsecase = MockRemoveAllTodoUsecase();

    when(() => DependencyProvider.get<AddTodoUsecase>(instanceName: 'in-memory')).thenReturn(addTodoUsecase);
    when(() => DependencyProvider.get<UpdateTodoUsecase>(instanceName: 'in-memory')).thenReturn(updateTodoUsecase);
    when(() => DependencyProvider.get<GetTodoUsecase>(instanceName: 'in-memory')).thenReturn(getTodoUsecase);
    when(() => DependencyProvider.get<GetAllTodoUsecase>(instanceName: 'in-memory')).thenReturn(getAllTodoUsecase);
    when(() => DependencyProvider.get<FilterAllTodoUsecase>(instanceName: 'in-memory')).thenReturn(filterAllTodoUsecase);
    when(() => DependencyProvider.get<MarkTodoUsecase>(instanceName: 'in-memory')).thenReturn(markTodoUsecase);
    when(() => DependencyProvider.get<RemoveTodoUsecase>(instanceName: 'in-memory')).thenReturn(removeTodoUsecase);
    when(() => DependencyProvider.get<RemoveAllTodoUsecase>(instanceName: 'in-memory')).thenReturn(removeAllTodoUsecase);

    // Act
    ApplicationDependenciesModuleResolver.register(isMemory: true);

    // Assert
    verify(() => DependencyProvider.registerFactory<AddTodoBloc>(any())).called(1);
    verify(() => DependencyProvider.registerFactory<GetTodoBloc>(any())).called(1);
    verify(() => DependencyProvider.registerFactory<MarkTodoBloc>(any())).called(1);
    verify(() => DependencyProvider.registerFactory<RemoveTodoBloc>(any())).called(1);
  });
}

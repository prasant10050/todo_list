// addTodo successfully adds a new TodoEntity and returns it
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:either_dart/either.dart';
import 'package:todo_api/api.dart';
import 'package:domain/domain.dart';
import 'package:todo_impl/src/impl.dart';

class MockTodoDataSource extends Mock implements ITodoDataSource {}
class MockMapper extends Mock implements Mapper<TodoEntity, TodoDto> {}

void main() {
  late MockTodoDataSource mockDataSource;
  late MockMapper mockMapper;
  late TodoRepository repository;

  setUp(() {
    mockDataSource = MockTodoDataSource();
    mockMapper = MockMapper();
    repository = TodoRepository(dataSource: mockDataSource, mapper: mockMapper);
  });

  test('addTodo successfully adds a new TodoEntity and returns it', () async {
    final todoEntity = TodoEntity(
      title: 'Test Title',
      description: 'Test Description',
      taskId: TaskId.generate(),
    );
    final todoDto = TodoDto(
      title: 'Test Title',
      description: 'Test Description',
      taskId: todoEntity.taskId.value,
    );

    when(() => mockDataSource.addTodo(todoEntity)).thenAnswer((_) async => Right(todoDto));
    when(() => mockMapper.mapToEntity(todoDto)).thenReturn(todoEntity);

    final result = await repository.addTodo(todoEntity);

    expect(result.isRight, true);
    expect(result.right, todoEntity);
  });

  test('addTodo handles failure from dataSource and returns DomainFailure', () async {
    final todoEntity = TodoEntity(
      title: 'Test Title',
      description: 'Test Description',
      taskId: TaskId.generate(),
    );
    final failure = DatabaseFailure('Database error');

    when(() => mockDataSource.addTodo(todoEntity)).thenAnswer((_) async => Left(failure));

    final result = await repository.addTodo(todoEntity);

    expect(result.isLeft, true);
    expect(result.left, isA<DomainFailure>());
    expect(result.left.message, 'Database error');
  });

  // getAllTodos retrieves a list of all TodoEntities
  test('get all todos successfully retrieves all todo entities', () async {
    // Arrange
    final mockDataSource = MockTodoDataSource();
    final mockMapper = MockMapper();
    final repository = TodoRepository(dataSource: mockDataSource, mapper: mockMapper);


    final List<TodoDto> mockTodoDtoList = [
      TodoDto(title: 'Title 1', description: 'Description 1', taskId: '1'),
      TodoDto(title: 'Title 2', description: 'Description 2', taskId: '2'),
    ];

    final List<TodoEntity> expectedTodoEntityList = [
      TodoEntity(title: 'Title 1', description: 'Description 1', taskId: TaskId.fromUniqueString('1')),
      TodoEntity(title: 'Title 2', description: 'Description 2', taskId: TaskId.fromUniqueString('2')),
    ];

    when(() => mockDataSource.getAllTodos()).thenAnswer((_) async => Right(mockTodoDtoList));
    when(() => mockMapper.mapToEntity(mockTodoDtoList[0])).thenReturn(expectedTodoEntityList[0]);
    when(() => mockMapper.mapToEntity(mockTodoDtoList[1])).thenReturn(expectedTodoEntityList[1]);

    // Act
    final result = await repository.getAllTodos();

    // Assert
    expect(result.isRight, true);
    expect(result.right, expectedTodoEntityList);
  });

  // markTodo marks a TodoEntity as completed and returns it
  test('mark_todo_marks_entity_completed_and_returns_it',() async {
    // Arrange
    final todoId = TaskId.generate();
    final todoEntity = TodoEntity(
      title: 'Test Title',
      description: 'Test Description',
      taskId: todoId,
      isCompleted: false,
    );
    final completedTodoEntity = todoEntity.copyWith(isCompleted: true);
    final todoDto = TodoDto(
      title: 'Test Title',
      description: 'Test Description',
      taskId: todoId.value,
      isCompleted: true,
    );

    when(() => mockDataSource.markTodo(todoId, todoEntity)).thenAnswer((_) async => Right(todoDto));
    when(() => mockMapper.mapToEntity(todoDto)).thenReturn(completedTodoEntity);

    // Act
    final result = await repository.markTodo(todoId, todoEntity);

    // Assert
    expect(result.isRight, true);
    expect(result.right, completedTodoEntity);
  });

  test('remove_todo_successfully_removes_specific_todo_entity', () async {
    final todoId = TaskId.generate();

    when(() => mockDataSource.removeTodo(todoId)).thenAnswer((_) async => Right(null));

    final result = await repository.removeTodo(todoId);

    expect(result.isRight, true);
    verify(() => mockDataSource.removeTodo(todoId)).called(1);
  });

  test('get_todo_returns_specific_entity_by_task_id', () async {
    // Setup
    final taskId = TaskId.generate();
    final todoEntity = TodoEntity(
      title: 'Test Title',
      description: 'Test Description',
      taskId: taskId,
    );
    final todoDto = TodoDto(
      title: 'Test Title',
      description: 'Test Description',
      taskId: taskId.value,
    );

    // Stubbing
    when(() => mockDataSource.getTodo(taskId)).thenAnswer((_) async => Right(todoDto));
    when(() => mockMapper.mapToEntity(todoDto)).thenReturn(todoEntity);

    // Test
    final result = await repository.getTodo(taskId);

    // Verify
    expect(result.isRight, true);
    expect(result.right, todoEntity);
  });

  test('remove_all_todos_successfully',() async {
    // Setup
    // Define the behavior of the dataSource
    when(() => mockDataSource.removeAllTodos()).thenAnswer((_) async => Right(null));

    // Call the method under test
    final result = await repository.removeAllTodos();

    // Verify the result
    expect(result.isRight, true);

    // Verify that the dataSource method was called once
    verify(() => mockDataSource.removeAllTodos()).called(1);
  });
}
// Successfully add a new todo item
import 'package:data/data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_api/api.dart';
import 'package:todo_impl/src/data/sources/local/todo_local_data_source.dart';

class MockStorage extends Mock implements BaseStorage {}

class MockMapper extends Mock implements Mapper<TodoEntity, TodoDto> {}

void main() {
  late MockStorage mockStorage;
  late MockMapper mockMapper;
  late TodoLocalDataSource dataSource;

  setUp(() {
    registerFallbackValue(
      TodoEntity(
        taskId: TaskId.generate(),
        title: 'Test Todo',
        description: 'desc',
      ),
    );
    mockStorage = MockStorage();
    mockMapper = MockMapper();
    dataSource = TodoLocalDataSource(storage: mockStorage, mapper: mockMapper);
  });

  test('add_todo_success', () async {

    final todoEntity = TodoEntity(
      taskId: TaskId.generate(),
      title: 'Test Todo',
      description: 'desc',
    );
    final todoDto =
        TodoDto(taskId: '1', title: 'Test Todo', description: 'desc');

    when(() => mockStorage.put(any(), any())).thenAnswer((_) async => {});
    when(() => mockMapper.mapFromEntity(any())).thenReturn(todoDto);

    final result = await dataSource.addTodo(todoEntity);

    expect(result, Right(todoDto));
    verify(() => mockStorage.put(any(), any())).called(1);
    verify(() => mockMapper.mapFromEntity(any())).called(1);
  });

  test('add_todo_storage_full', () async {

    final todoEntity = TodoEntity(
      taskId: TaskId.generate(),
      title: 'Test Todo',
      description: 'desc',
    );

    when(() => mockStorage.put(any(), any()))
        .thenThrow(Exception('Storage Full'));

    final result = await dataSource.addTodo(todoEntity);

    expect(result, const Left(DatabaseFailure('Could not add todo: {}')));
    verify(() => mockStorage.put(any(), any())).called(1);
  });

  /*test('test_retrieve_specific_todo_by_id', () async {
    final todoId = TaskId.generate();
    final todoEntity =
        TodoEntity(taskId: todoId, title: 'Test Todo', description: 'desc');
    final todoDto =
        TodoDto(taskId: todoId.value, title: 'Test Todo', description: 'desc');

    when(
      () => mockStorage.getByKey(
        any(),
      ),
    ).thenAnswer((_) async => todoEntity.toMap());
    when(() => mockMapper.mapFromEntity(todoEntity)).thenReturn(todoDto);

    // Act
    final result = await dataSource.getTodo(todoId);

    // Assert
    expect(result, Right(todoDto));
    verifyNever(() => mockStorage.getByKey(todoId.value)).called(1);
    verifyNever(() => mockMapper.mapFromEntity(todoEntity)).called(1);
  });
*/
  test('Retrieve a non-existent todo item by ID', () async {
    // Define the behavior of the storage
    when(() => mockStorage.getByKey(any())).thenAnswer((_) async => null);

    // Call the method to retrieve a non-existent todo
    final result = await dataSource.getTodo(TaskId.generate());

    // Verify the result is a Left with DatabaseFailure
    expect(result.isLeft, true);
    expect(result.fold((failure) => failure, (todo) => null),
        isA<DatabaseFailure>());

    // Verify the storage method was called
    verify(() => mockStorage.getByKey(any())).called(1);
  });

  /*test('Retrieve all todo items when storage is not empty', () async {
    final mockStorage = MockStorage();
    final mockMapper = MockMapper();
    final dataSource =
        TodoLocalDataSource(storage: mockStorage, mapper: mockMapper);

    // Define mock data
    final todoEntity = TodoEntity(
      taskId: TaskId.fromUniqueString('1'),
      title: 'Test Todo',
      description: 'desc',
      isCompleted: false,
    );
    final todoDto = TodoDto(
      taskId: '1',
      title: 'Test Todo',
      description: 'desc',
      isCompleted: false,
    );
    final mapData = {
      '1': {
        'taskId': '1',
        'title': 'Test Todo',
        'description': 'desc',
        'isCompleted': false
      }
    };

    // Mock behavior
    when(() => mockStorage.getAllValuesInMap()).thenAnswer((_) async => mapData);
    when(() => mockMapper.mapFromEntity(any())).thenReturn(todoDto);

    // Call the method
    final result = await dataSource.getAllTodos();

    // Assertions
    expect(result.isRight, true);
    expect(result.right, <TodoDto>[todoDto]);
    verify(() => mockStorage.getAllValuesInMap()).called(1);
    verify(() => mockMapper.mapFromEntity(any())).called(1);
  });*/
  test(
    'Retrieve all todo items when storage is empty',
    () async {
      // Setup

      // Define behavior
      when(mockStorage.getAllValuesInMap).thenAnswer((_) async => null);

      // Call the method under test
      final result = await dataSource.getAllTodos();

      // Verify the result
      expect(result.isRight, true);
      expect(result.right, []);

      // Verify interactions
      verify(mockStorage.getAllValuesInMap).called(1);
    },
  );

  test(
    'Mark a todo item as completed',
    () async {
      final todoEntity = TodoEntity(
          taskId: TaskId.fromUniqueString('1'),
          title: 'Test Todo',
          description: 'desc',
          isCompleted: true);
      final updatedTodoEntity = todoEntity.copyWith(isCompleted: true);
      final todoDto = TodoDto(
          taskId: '1',
          title: 'Test Todo',
          isCompleted: true,
          description: 'desc');

      when(() => mockStorage.update(any(), any())).thenAnswer((_) async => {});
      when(() => mockMapper.mapFromEntity(any())).thenReturn(todoDto);

      final result =
          await dataSource.markTodo(todoEntity.taskId, updatedTodoEntity);

      expect(result.isRight, true);
      expect(result.right, todoDto);
      verify(() => mockStorage.update(any(), any())).called(1);
      verify(() => mockMapper.mapFromEntity(any())).called(1);
    },
  );

  test(
    'Update an existing todo item',
    () async {
      final todoEntity = TodoEntity(
          taskId: TaskId.fromUniqueString('1'),
          title: 'Test Todo',
          description: 'desc',
          isCompleted: true);
      final updatedTodoEntity = todoEntity.copyWith(title: 'Updated todo');
      final todoDto = TodoDto(
          taskId: '1',
          title: 'Updated todo',
          isCompleted: true,
          description: 'desc');

      when(() => mockStorage.update(any(), any())).thenAnswer((_) async => {});
      when(() => mockMapper.mapFromEntity(any())).thenReturn(todoDto);

      final result = await dataSource.updateTodo(updatedTodoEntity);

      expect(result.isRight, true);
      expect(result.right, todoDto);
      verify(() => mockStorage.update(any(), any())).called(1);
      verify(() => mockMapper.mapFromEntity(any())).called(1);
    },
  );
}

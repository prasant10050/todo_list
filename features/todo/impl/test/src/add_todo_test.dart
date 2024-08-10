import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:domain/domain.dart';
import 'package:todo_api/api.dart';
import 'package:either_dart/either.dart';
import 'package:todo_impl/impl.dart';

class MockTodoDataSource extends Mock implements ITodoDataSource {}
class MockMapper extends Mock implements Mapper<TodoEntity, TodoDto> {}

void main() {
  test('add_todo_success', () async {
    final mockDataSource = MockTodoDataSource();
    final mockMapper = MockMapper();
    final repository = TodoRepository(dataSource: mockDataSource, mapper: mockMapper);

    final todoEntity = TodoEntity(taskId: TaskId.fromUniqueString('1'), title: 'Test Todo',description: 'description');
    final todoDto = TodoDto(taskId: '1', title: 'Test Todo',description: 'description');

    when(mockDataSource.addTodo(todoEntity)).thenAnswer((_) async => Right(todoDto));
    when(mockMapper.mapToEntity(todoDto)).thenReturn(todoEntity);

    final result = await repository.addTodo(todoEntity);

    expect(result.isRight, true);
    expect(result.right, todoEntity);
  });
}
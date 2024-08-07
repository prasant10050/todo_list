import 'package:domain/domain.dart';
import 'package:todo_api/api.dart';

class TodoMapper implements Mapper<TodoEntity, TodoDto> {
  @override
  TodoDto mapFromEntity(TodoEntity entity) => TodoDto(
        title: entity.title,
        description: entity.description,
        taskId: entity.taskId,
        isCompleted: entity.isCompleted,
      );

  @override
  TodoEntity mapToEntity(TodoDto dto) => TodoEntity(
        title: dto.title,
        description: dto.description,
        taskId: dto.taskId,
        isCompleted: dto.isCompleted,
      );
}

import 'package:todo_api/api.dart';

class TodoMapper implements Mapper<TodoEntity, TodoDto> {
  @override
  TodoDto mapFromEntity(TodoEntity entity) => TodoDto(
        title: entity.title,
        description: entity.description,
        taskId: entity.taskId.value,
        isCompleted: entity.isCompleted,
      );

  @override
  TodoEntity mapToEntity(TodoDto dto) => TodoEntity(
        title: dto.title,
        description: dto.description,
        taskId: TaskId.fromUniqueString(dto.taskId),
        isCompleted: dto.isCompleted,
      );
}

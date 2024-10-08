import 'package:todo_api/api.dart';
import 'package:todo_api/src/api.dart';

class TodoEntity {
  const TodoEntity({
    required this.title,
    required this.description,
    required this.taskId,
    this.isCompleted = false,
  });

  factory TodoEntity.fromMap(Map<String, dynamic> map) {
    return TodoEntity(
      title: map['title'] as String,
      description: map['description'] as String,
      isCompleted: map['isCompleted'] as bool,
      taskId: map['taskId'] as TaskId,
    );
  }

  final String title;
  final String description;
  final bool isCompleted;
  final TaskId taskId;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'taskId': taskId.value,
    };
  }

  TodoEntity copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    TaskId? taskId,
  }) {
    return TodoEntity(
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      taskId: taskId ?? this.taskId,
    );
  }
}

import 'package:domain/domain.dart';
import 'package:todo_api/api.dart';

class TodoDto{
  TodoDto({
    required this.title,
    required this.description,
    required this.taskId,
    this.isCompleted = false,
  });

  factory TodoDto.fromMap(Map<String, dynamic> map) {
    return TodoDto(
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
      'title': this.title,
      'description': this.description,
      'isCompleted': this.isCompleted,
      'taskId': taskId,
    };
  }

  TodoDto copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    TaskId? taskId,
  }) {
    return TodoDto(
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      taskId: taskId ?? this.taskId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoDto &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          description == other.description &&
          isCompleted == other.isCompleted &&
          taskId == other.taskId;

  @override
  int get hashCode =>
      title.hashCode ^
      description.hashCode ^
      isCompleted.hashCode ^
      taskId.hashCode;
}

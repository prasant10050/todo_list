import 'package:todo_api/api.dart';

typedef TodoCallback = void Function(TodoEntity todo);
typedef TodoFilterCallback = void Function(Filter filter);

class TodoActions {
  TodoActions({
    required this.onEdit,
    required this.onMarkAsDone,
    required this.onShowDetails,
    required this.onDelete,
  });

  final TodoCallback onEdit;
  final TodoCallback onMarkAsDone;
  final TodoCallback onShowDetails;
  final TodoCallback onDelete;
}

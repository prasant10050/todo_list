import 'package:domain/domain.dart';
import 'package:uuid/uuid.dart';

class TodoId extends BaseId<String> {
  TodoId() : super(const Uuid().v4());

  @override
  List<Object?> get props => [value];
}

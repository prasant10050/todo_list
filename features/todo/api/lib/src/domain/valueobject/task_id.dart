import 'package:domain/domain.dart';
import 'package:either_dart/either.dart';
import 'package:uuid/uuid.dart';

class TaskId extends ValueObject<ValueFailure,String> {

  // We cannot let a simple String be passed in. This would allow for possible non-unique IDs.
  factory TaskId() {
    return TaskId._(
      Right(const Uuid().v1()),
    );
  }

  // Used with strings we trust are unique, such as database IDs.
  factory TaskId.fromUniqueString(String uniqueIdStr) {
    assert(uniqueIdStr.isNotEmpty,'uniqueIdStr must not be empty');
    return TaskId._(
      Right(uniqueIdStr),
    );
  }

  const TaskId._(this.value);
  @override
  final Either<ValueFailure, String> value;
}

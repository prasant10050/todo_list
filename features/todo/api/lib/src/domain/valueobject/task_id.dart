import 'package:domain/domain.dart';
import 'package:uuid/uuid.dart';

class TaskId extends ValueObject<String> {

  // We cannot let a simple String be passed in. This would allow for possible non-unique IDs.
  factory TaskId() {
    return TaskId._(
      const Uuid().v1(),
    );
  }

  // Used with strings we trust are unique, such as database IDs.
  factory TaskId.fromUniqueString(String uniqueIdStr) {
    assert(uniqueIdStr.isNotEmpty,'uniqueIdStr must not be empty');
    return TaskId._(
      uniqueIdStr,
    );
  }

  const TaskId._(super.value);

  factory TaskId.generate() {
    return TaskId._(const Uuid().v4());
  }
}

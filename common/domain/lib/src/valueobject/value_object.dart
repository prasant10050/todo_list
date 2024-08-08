import 'package:equatable/equatable.dart';

abstract class ValueObject<T> extends Equatable {
  const ValueObject(this.value);

  final T value;

  @override
  List<Object?> get props => [value];

  @override
  bool? get stringify => true;
}

import 'package:domain/domain.dart';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class ValueObject<T_Failure, T_Value>{
  const ValueObject();

  Either<T_Failure, T_Value> get value;

  // Returns the [value] of the object.
  // Throws a [TodoException] if the value is a [T_Failure].
  T_Value getOrThrow() {
    return value.fold(
      (failure) => throw TodoException(failure.toString()),
      (value) => value,
    );
  }

  // Returns true if the [value] is a [T_Value].
  bool get isValid => value.isRight;

  // Returns true if the [value] is a [T_Failure].
  bool get isNotValid => !isValid;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ValueObject<T_Failure, T_Value> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Value($value)';
}

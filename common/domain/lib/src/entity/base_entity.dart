import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class BaseEntity<ID> extends Equatable {
  late final ID _value;

  ID get value => _value;

  set value(ID value) {
    _value = value;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is BaseEntity &&
          runtimeType == other.runtimeType &&
          _value == other._value;

  @override
  int get hashCode => super.hashCode ^ _value.hashCode;
}

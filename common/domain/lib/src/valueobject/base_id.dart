import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class BaseId<ID> extends Equatable{
  const BaseId(this._value);

  final ID _value;

  ID get value => _value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is BaseId &&
          runtimeType == other.runtimeType &&
          _value == other._value;

  @override
  int get hashCode => super.hashCode ^ _value.hashCode;
}
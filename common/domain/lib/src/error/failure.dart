import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class Failure extends Equatable {

  const Failure(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class CommonFailure extends Failure {
  const CommonFailure(super.message);
}

class DomainFailure extends Failure {
  const DomainFailure(super.message);
}

class ValueFailure extends Failure {
  const ValueFailure(super.message);
}
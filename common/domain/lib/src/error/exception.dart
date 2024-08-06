import 'package:equatable/equatable.dart';

class TodoException extends Equatable implements Exception {
  const TodoException(this.message);

  final String message;

  @override
  List<Object?> get props => [];
}

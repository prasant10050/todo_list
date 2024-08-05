import 'package:domain/src/error/failure.dart';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<T, Params> {
  /// Future<T> call(P param);
  Future<Either<Failure, T>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

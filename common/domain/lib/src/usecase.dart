import 'package:domain/src/error/failure.dart';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<T, Params> extends Equatable{
  // Future<T> call(P param);
  Future<Either<Failure, T>> call(Params params);
  @override
  List<Object> get props => [];
}

abstract class NoParams<T> extends Equatable {
  Future<Either<Failure, T>> call();

  @override
  List<Object> get props => [];
}

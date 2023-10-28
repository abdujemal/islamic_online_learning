import 'package:dartz/dartz.dart';
import 'package:islamic_online_learning/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef StreamEither<T> = Stream<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'failure.dart';

abstract class BaseUseCase<T, Parameters> {
  Future<Either<Failure, T>> call(Parameters parameters);
}

class NoParameters extends Equatable {
  const NoParameters();
  @override
  List<Object?> get props => [];
}

int calculate(List<int> nums) {
  int sumOfSq = 0;
  for (int num in nums) {
    sumOfSq = sumOfSq + num * num;
  }
  return sumOfSq;
}

import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

class InputConverter {
  /// Converts a string to an integer.
  /// Returns a [Right] with the integer if conversion is successful,
  /// or a [Left] with a [FormatFailure] if conversion fails.
  Either<Failures, double> stringToUnsignedDouble(String str) {
    try {
      final doubleValue = double.parse(str);
      if (doubleValue < 0) throw const FormatException();
      return Right(doubleValue);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failures {
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is InvalidInputFailure;

  @override
  int get hashCode => runtimeType.hashCode;
}

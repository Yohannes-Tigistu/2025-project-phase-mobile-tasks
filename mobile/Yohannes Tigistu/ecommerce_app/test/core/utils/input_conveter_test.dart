import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/utils/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;
  setUp(() {
    inputConverter = InputConverter();
  });
  group('InputConverter', () {
    test('should be an instance of InputConverter', () {
      final num = '123.0';

      final result = inputConverter.stringToUnsignedDouble(num);

      expect(result, Right(123));
    });

    // Add more tests for InputConverter methods if needed
    test('should return a Left(InvalidInputFailure) when input is invalid', () {
      final invalidNum = 'abc';

      final result = inputConverter.stringToUnsignedDouble(invalidNum);

      expect(result, Left<Failures, int>(InvalidInputFailure()));
    });
    test(
      'should return a Left(InvalidInputFailure) when input is negative',
      () {
        final negativeNum = '-123';

        final result = inputConverter.stringToUnsignedDouble(negativeNum);

        expect(result, Left<Failures, int>(InvalidInputFailure()));
      },
            
    );
  });
}

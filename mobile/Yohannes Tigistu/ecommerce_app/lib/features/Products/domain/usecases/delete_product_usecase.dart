import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/success/confirmation.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/product_repository.dart';


class DeleteProductUsecase {
  final ProductRepository repository;

  DeleteProductUsecase(this.repository);

  Future<Either<Failures, Confirmation>> call(int id) async {
    return await repository.deleteProduct(id);
  }
}

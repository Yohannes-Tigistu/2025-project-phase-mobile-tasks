import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/success/confirmation.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class CreateNewProductUsecase {
  final ProductRepository repository;

  CreateNewProductUsecase(this.repository);
  Future<Either<Failures, Confirmation>> call(Product product) async {
    return await repository.createProduct(product);
}
}

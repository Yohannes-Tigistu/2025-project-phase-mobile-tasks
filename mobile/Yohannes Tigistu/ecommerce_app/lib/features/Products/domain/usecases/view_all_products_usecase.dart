import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';
class ViewAllProductsUsecase {
  final ProductRepository repository;

  ViewAllProductsUsecase(this.repository);

  Future<Either<Failures, List<Product>>> call() async {
    return await repository.getAllProducts();
    
  }
}

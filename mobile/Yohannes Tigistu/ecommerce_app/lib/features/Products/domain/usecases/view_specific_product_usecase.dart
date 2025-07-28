import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class ViewSpecificProductUsecase {
  final ProductRepository repository;

  ViewSpecificProductUsecase(this.repository);
  Future<Either<Failures, Product>> call(int id) async{
    return repository.getProductById(id);
  }
}
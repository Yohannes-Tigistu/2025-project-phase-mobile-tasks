import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'update_product_usecase.dart';
class ViewAllProductsUsecase implements UseCase<List<Product>,NoParams>{
  final ProductRepository repository;

  ViewAllProductsUsecase(this.repository);
@ override
  Future<Either<Failures, List<Product>>> call(NoParams) async {
    return await repository.getAllProducts();
    
  }
}


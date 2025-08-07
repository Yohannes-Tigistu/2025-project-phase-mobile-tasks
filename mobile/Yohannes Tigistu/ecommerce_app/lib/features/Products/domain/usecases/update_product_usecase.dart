import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/success/confirmation.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class UpdateProductUsecase {
  final ProductRepository repository;

  UpdateProductUsecase(this.repository);
  Future<Either<Failures, Confirmation>> call(Product product) async {
    return await repository.updateProduct(product);
  }
} 


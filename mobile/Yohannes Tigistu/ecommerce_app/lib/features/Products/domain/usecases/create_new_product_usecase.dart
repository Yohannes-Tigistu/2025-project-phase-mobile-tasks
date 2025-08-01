import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/success/confirmation.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class CreateNewProductUsecase implements  UseCase<Confirmation, Params>{
  final ProductRepository repository;

  CreateNewProductUsecase(this.repository);
  Future<Either<Failures, Confirmation>> call(Params params)
   async {
    return await repository.createProduct( params.product);
  }
}
class Params extends Equatable {
  final Product product;

  Params({required this.product});

  @override
  List<Object?> get props => [product];
}
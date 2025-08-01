import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';


class ViewSpecificProductUsecase implements UseCase <Product , Params> {
  final ProductRepository repository;

  ViewSpecificProductUsecase(this.repository);
  @override
  Future<Either<Failures, Product>> call(Params params ) async{
    return repository.getProductById(params.id);
  }
}
class Params extends Equatable{
 final int id;

 const Params({required this.id});

 @override
 List<Object> get props => [id];

}
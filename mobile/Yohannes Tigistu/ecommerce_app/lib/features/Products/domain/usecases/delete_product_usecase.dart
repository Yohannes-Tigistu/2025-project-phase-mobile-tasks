import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/success/confirmation.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/product_repository.dart';


class DeleteProductUsecase implements UseCase<Confirmation, Params> {  
  final ProductRepository repository;

  DeleteProductUsecase(this.repository);

  @override
  Future<Either<Failures, Confirmation>> call(Params params) async {
    return await repository.deleteProduct(params.id);
  } 
}
class Params extends Equatable{
  final int id;

  const Params({required this.id});
  
  @override

  List<Object?> get props => [id];
  


}
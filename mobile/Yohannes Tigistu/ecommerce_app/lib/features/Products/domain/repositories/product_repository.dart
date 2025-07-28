import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/success/confirmation.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failures, List<Product>>> getAllProducts();
  Future<Either<Failures, Product>> getProductById(int id);
  Future<Either<Failures, Confirmation>> deleteProduct(int id);
  Future<Either<Failures, Confirmation>> createProduct(Product product);
  Future<Either<Failures, Confirmation>> updateProduct(Product product);

}
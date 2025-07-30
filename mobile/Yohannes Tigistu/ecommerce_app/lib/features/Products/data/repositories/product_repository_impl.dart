import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/platform/network_info.dart';
import '../../../../core/success/confirmation.dart';

import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/products_local_data_source.dart';
import '../datasources/products_remote_data_source.dart';


class ProductRepositoryImpl implements ProductRepository{
  final ProductsRemoteDataSource remoteDataSource;
  final ProductsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failures, List<Product>>> getAllProducts() async {
    // Implementation for fetching all products
    // TODO: Replace with actual implementation
    return Left(ServerFailure('Failed to fetch products'));
  }

  @override
  Future<Either<Failures, Confirmation>> createProduct(Product product) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }

  @override
  Future<Either<Failures, Confirmation>> deleteProduct(int id) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Future<Either<Failures, Product>> getProductById(int id) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failures, Confirmation>> updateProduct(Product product) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }
}
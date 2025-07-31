import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/success/confirmation.dart';

import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/products_local_data_source.dart';
import '../datasources/products_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
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
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.getAllProducts();
        localDataSource.cacheProducts(remoteProducts);
        return Right(remoteProducts);
      } catch (e) {
        return Left(ServerFailure('Failed to fetch products'));
      }
    } else {
      try {
        final localProducts = await localDataSource.getLastProducts();
        return Right(localProducts);
      } catch (e) {
        return Left(CacheFailure('No cached products available'));
      }
    }
  }

  @override
  Future<Either<Failures, Confirmation>> createProduct(Product product) async {
    if (await networkInfo.isConnected) {
      try {
        final productModel = ProductModel.fromEntity(product);
        await remoteDataSource.createProduct(productModel);
        return Right(Confirmation('Product created successfully'));
      } catch (e) {
        return Left(ServerFailure('Failed to create product'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failures, Confirmation>> deleteProduct(int id) async {
    if (await networkInfo.isConnected) {
      try {
        remoteDataSource.deleteProduct(id);
        localDataSource.deleteProduct(id);
        return Right(Confirmation('Product deleted successfully'));
      } catch (e) {
        return Left(ServerFailure('Failed to delete product'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failures, Product>> getProductById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final product = await remoteDataSource.getProductById(id);
        localDataSource.cacheProduct(product);
        return Right(product);
      } catch (e) {
        return Left(ServerFailure('Failed to fetch product'));
      }
    } else {
      try {
        final product = await localDataSource.getProductById(id);
        return Right(product);
      } catch (e) {
        return Left(CacheFailure('No cached product available'));
      }
    }
  }

  @override
  Future<Either<Failures, Confirmation>> updateProduct(Product product) async {
    if (await networkInfo.isConnected) {
      try {
        final productModel = ProductModel.fromEntity(product);
        remoteDataSource.updateProduct(productModel);
        localDataSource.updateProduct(productModel);
        return Right(Confirmation('Product updated successfully'));
      } catch (e) {
        return Left(ServerFailure('Failed to update product'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../../../../core/success/confirmation.dart';
import '../../../../../features/Products/data/datasources/products_local_data_source.dart';
import '../../../../../features/Products/data/datasources/products_remote_data_source.dart';

import '../../../../../features/Products/data/models/product_model.dart';
import '../../../../../features/Products/data/repositories/product_repository_impl.dart';

class MockRemoteDataSource extends Mock implements ProductsRemoteDataSource {}

class MockLocalDataSource extends Mock implements ProductsLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ProductRepositoryImpl repository;
  late MockRemoteDataSource remoteDataSource;
  late MockLocalDataSource localDataSource;
  late MockNetworkInfo networkInfo;

  setUp(() {
    remoteDataSource = MockRemoteDataSource();
    localDataSource = MockLocalDataSource();
    networkInfo = MockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
    // Always stub isConnected to avoid null errors
    when(networkInfo.isConnected).thenAnswer((_) async => true);
  });

  group('getAllProducts', () {
    final tProductsModel = [
      ProductModel(
        id: 1,
        name: 'Test Product',
        description: 'This is a test product',
        category: 'Test Category',
        price: 19.99,
        imageUrl: 'http://example.com/image.jpg',
      ),
      ProductModel(
        id: 2,
        name: 'Another Product',
        description: 'This is another product',
        category: 'Test Category',
        price: 29.99,
        imageUrl: 'http://example.com/another_image.jpg',
      ),
    ];
    test('check if device is online', () async {
      // Arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // Act
      final result = await repository.getAllProducts();
      // Assert
      expect(result, Right(tProductsModel));
    });
    group('device is online', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // Arrange
          when(
            remoteDataSource.getAllProducts(),
          ).thenAnswer((_) async => tProductsModel);
          // Act
          final result = await repository.getAllProducts();
          // Assert
          verify(remoteDataSource.getAllProducts());
          expect(result, Right(tProductsModel));
        },
      );
      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // Arrange
          when(
            remoteDataSource.getAllProducts(),
          ).thenAnswer((_) async => tProductsModel);
          // Act
          await repository.getAllProducts();
          // Assert
          verify(localDataSource.cacheProducts(tProductsModel));
        },
      );
      test(
        'should return server failure when the call to remote data source fails',
        () async {
          // Arrange
          when(
            remoteDataSource.getAllProducts(),
          ).thenThrow(Exception('Server Failure'));
          // Act
          final result = await repository.getAllProducts();
          // Assert
          verify(remoteDataSource.getAllProducts());
          verifyZeroInteractions(localDataSource);
          expect(result, Left(ServerFailure('Failed to fetch products')));
        },
      );
    });
    group('device is offline', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });
      test('should return cached products when device is offline', () async {
        // Arrange
        when(
          localDataSource.getLastProducts(),
        ).thenAnswer((_) async => tProductsModel);
        // Act
        final result = await repository.getAllProducts();
        // Assert
        verify(localDataSource.getLastProducts());
        expect(result, Right(tProductsModel));
      });
      test('should return CacheFailure when there is no cached data', () async {
        // Arrange
        when(localDataSource.getLastProducts()).thenThrow(Exception('Cache Failure'));
        // Act
        final result = await repository.getAllProducts();
        // Assert
        verify(localDataSource.getLastProducts());
        expect(result, Left(CacheFailure('No cached products available')));
      });
    });
  });
 group('createProduct', (){
  setUp((){
    when(networkInfo.isConnected).thenAnswer((_) async => true);
  });
  group('when device is online', (){
    test('should return Confirmation when product is created successfully', () async {
      // Arrange
      final tProduct = ProductModel(
        id: 1,
        name: 'New Product',
        description: 'This is a new product',
        category: 'New Category',
        price: 9.99,
        imageUrl: 'http://example.com/new_image.jpg',
      );
      when(remoteDataSource.createProduct(tProduct)).thenAnswer((_) async => Confirmation( 'Product created successfully'));
      // Act
      final result = await repository.createProduct(tProduct);
      // Assert
      verify(remoteDataSource.createProduct(tProduct));
      expect(result, Right(Confirmation( 'Product created successfully')));
    
    });
    test('should return ServerFailure when product creation fails', () async {
      // Arrange
      final tProduct = ProductModel(
        id: 1,
        name: 'New Product',
        description: 'This is a new product',
        category: 'New Category',
        price: 9.99,
        imageUrl: 'http://example.com/new_image.jpg',
      );
      when(remoteDataSource.createProduct(tProduct)).thenThrow(Exception('Server Failure'));
      // Act
      final result = await repository.createProduct(tProduct);
      // Assert
      verify(remoteDataSource.createProduct(tProduct));
      expect(result, Left(ServerFailure('Failed to create product')));
    });
  });
  group('when device is offline', (){
    setUp(() {
      when(networkInfo.isConnected).thenAnswer((_) async => false);
    });
    test('should return CacheFailure when trying to create product while offline', () async {
      // Arrange
      final tProduct = ProductModel(
        id: 1,
        name: 'New Product',
        description: 'This is a new product',
        category: 'New Category',
        price: 9.99,
        imageUrl: 'http://example.com/new_image.jpg',
      );
      // Act
      final result = await repository.createProduct(tProduct);
      // Assert
      verifyZeroInteractions(remoteDataSource);
      expect(result, Left(CacheFailure('No network connection')));
    });
  }); 


   group('deleteProduct', () {
    const tId = 1;
    setUp(() {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
    });
    group('when device is online', () {
      test(
        'should return Confirmation when product is deleted successfully from remote and local sources',
        () async {
      // Arrange
      when(remoteDataSource.deleteProduct(tId))
        .thenAnswer((_) async => Confirmation('Product deleted successfully'));
      when(localDataSource.deleteProduct(tId))
        .thenAnswer((_) async => Confirmation('Product deleted successfully'));
      // Act
      final result = await repository.deleteProduct(tId);
      // Assert
      verify(remoteDataSource.deleteProduct(tId));
      verify(localDataSource.deleteProduct(tId));
      expect(result, Right(Confirmation('Product deleted successfully')));
      });

      test('should return ServerFailure when remote deletion fails', () async {
      // Arrange
      when(remoteDataSource.deleteProduct(tId))
        .thenThrow(Exception('Server Failure'));
      // Act
      final result = await repository.deleteProduct(tId);
      // Assert
      verify(remoteDataSource.deleteProduct(tId));
      verifyZeroInteractions(localDataSource);
      expect(result, Left(ServerFailure('Failed to delete product')));
      });
    });

    group('when device is offline', () {
      setUp(() {
      when(networkInfo.isConnected).thenAnswer((_) async => false);
      });
      test(
        'should return NetworkFailure when trying to delete product while offline',
        () async {
      // Act
      final result = await repository.deleteProduct(tId);
      // Assert
      verifyZeroInteractions(remoteDataSource);
      verifyZeroInteractions(localDataSource);
      expect(result, Left(NetworkFailure('No internet connection')));
      });
    });
    });

    group('getProductById', () {
    const tId = 1;
    final tProductModel = ProductModel(
      id: tId,
      name: 'Test Product',
      description: 'This is a test product',
      category: 'Test Category',
      price: 19.99,
      imageUrl: 'http://example.com/image.jpg',
    );

    group('when device is online', () {
      setUp(() {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote product when the call to remote data source is successful',
        () async {
      // Arrange
      when(remoteDataSource.getProductById(tId))
        .thenAnswer((_) async => tProductModel);
      // Act
      final result = await repository.getProductById(tId);
      // Assert
      verify(remoteDataSource.getProductById(tId));
      expect(result, Right(tProductModel));
      });

      test(
        'should cache the product locally when the call to remote data source is successful',
        () async {
      // Arrange
      when(remoteDataSource.getProductById(tId))
        .thenAnswer((_) async => tProductModel);
      // Act
      await repository.getProductById(tId);
      // Assert
      verify(localDataSource.cacheProduct(tProductModel));
      });

      test(
        'should return ServerFailure when the call to remote data source fails',
        () async {
      // Arrange
      when(remoteDataSource.getProductById(tId))
        .thenThrow(Exception('Server Failure'));
      // Act
      final result = await repository.getProductById(tId);
      // Assert
      verify(remoteDataSource.getProductById(tId));
      verifyZeroInteractions(localDataSource);
      expect(result, Left(ServerFailure('Failed to fetch product')));
      });
    });

    group('when device is offline', () {
      setUp(() {
      when(networkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cached product when device is offline', () async {
      // Arrange
      when(localDataSource.getProductById(tId))
        .thenAnswer((_) async => tProductModel);
      // Act
      final result = await repository.getProductById(tId);
      // Assert
      verify(localDataSource.getProductById(tId));
      verifyZeroInteractions(remoteDataSource);
      expect(result, Right(tProductModel));
      });

      test('should return CacheFailure when there is no cached product',
        () async {
      // Arrange
      when(localDataSource.getProductById(tId))
        .thenThrow(Exception('Cache Failure'));
      // Act
      final result = await repository.getProductById(tId);
      // Assert
      verify(localDataSource.getProductById(tId));
      verifyZeroInteractions(remoteDataSource);
      expect(result, Left(CacheFailure('No cached product available')));
      });
    });
    });

    group('updateProduct', () {
    final tProductModel = ProductModel(
      id: 1,
      name: 'Updated Product',
      description: 'This is an updated product',
      category: 'Updated Category',
      price: 39.99,
      imageUrl: 'http://example.com/updated_image.jpg',
    );

    group('when device is online', () {
      setUp(() {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return Confirmation when product is updated successfully on remote and local sources',
        () async {
      // Arrange
      when(remoteDataSource.updateProduct(tProductModel))
        .thenAnswer((_) async => Confirmation('Product updated successfully'));
      when(localDataSource.updateProduct(tProductModel))
        .thenAnswer((_) async => Confirmation('Product updated successfully'));
      // Act
      final result = await repository.updateProduct(tProductModel);
      // Assert
      verify(remoteDataSource.updateProduct(tProductModel));
      verify(localDataSource.updateProduct(tProductModel));
      expect(result, Right(Confirmation('Product updated successfully')));
      });

      test('should return ServerFailure when remote update fails', () async {
      // Arrange
      when(remoteDataSource.updateProduct(tProductModel))
        .thenThrow(Exception('Server Failure'));
      // Act
      final result = await repository.updateProduct(tProductModel);
      // Assert
      verify(remoteDataSource.updateProduct(tProductModel));
      verifyZeroInteractions(localDataSource);
      expect(result, Left(ServerFailure('Failed to update product')));
      });
    });

    group('when device is offline', () {
      setUp(() {
      when(networkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return NetworkFailure when trying to update product while offline',
        () async {
      // Act
      final result = await repository.updateProduct(tProductModel);
      // Assert
      verifyZeroInteractions(remoteDataSource);
      verifyZeroInteractions(localDataSource);
      expect(result, Left(NetworkFailure('No internet connection')));
      });
    });
    });
 });
}

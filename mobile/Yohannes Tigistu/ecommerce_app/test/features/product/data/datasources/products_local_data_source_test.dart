
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../lib/features/Products/data/models/product_model.dart';
import '../../../../../lib/features/Products/data/datasources/products_local_data_source.dart';
import '../../../../../lib/core/errors/exeption.dart';

class MockSharedPreferences extends Mock implements SharedPreferences{

}
const CACHED_PRODUCTS = 'cached_products';
void main(){
  // Mocking the ProductsLocalDataSource
  late ProductsLocalDataSourceImpl localDataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSource = ProductsLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });
  group('ProductsLocalDataSource Tests', () {
    group('get list of products', () {
      test('should return list of last cached products', () async {
        // Arrange
        final List<Map<String, dynamic>> productList = [
          {'id': 1, 'name': 'Product 1', 'description': 'Description 1', 'category': 'Category 1', 'price': 10.0, 'imageUrl': 'http://example.com/image1.jpg'},
          {'id': 2, 'name': 'Product 2', 'description': 'Description 2', 'category': 'Category 2', 'price': 20.0, 'imageUrl': 'http://example.com/image2.jpg'},
        ];
        final jsonString = jsonEncode(productList.map((product) => ProductModel.fromJson(product).toJson()).toList());
        when(mockSharedPreferences.getString(CACHED_PRODUCTS)).thenReturn(jsonString);
        when(mockSharedPreferences.getString(CACHED_PRODUCTS)).thenReturn(jsonString.toString());

        // Act
        final result = await localDataSource.getLastProducts();

        // Assert
        expect(result, isA<List<ProductModel>>());
        expect(result.length, 2);
        expect(result[0].name, 'Product 1');
      });

      test('should throw cache exception error', () {
        when(mockSharedPreferences.getString(CACHED_PRODUCTS)).thenReturn(null);
        expect(() => localDataSource.getLastProducts(), throwsA(isA<CacheException>()));
      });
    });

    // Additional tests for other methods can be added here
  test(
    'should cache products',
    () async {
      // Arrange
      final List<ProductModel> products = [
        ProductModel(id: 1, name: 'Product 1', description: 'Description 1', category: 'Category 1', price: 10.0, imageUrl: 'http://example.com/image1.jpg'),
        ProductModel(id: 2, name: 'Product 2', description: 'Description 2', category: 'Category 2', price: 20.0, imageUrl: 'http://example.com/image2.jpg'),
      ];
      final jsonString = jsonEncode(products.map((product) => product.toJson()).toList());
      when(mockSharedPreferences.setString( CACHED_PRODUCTS, jsonString)).thenAnswer((_) async => true);

      // Act
      await localDataSource.cacheProducts(products);

      // Assert
      verify(mockSharedPreferences.setString( CACHED_PRODUCTS, jsonString)).called(1);

    
    });

    test(
      'should return a product by id',
      () async {
        // Arrange
        final product = ProductModel(id: 1, name: 'Product 1', description: 'Description 1', category: 'Category 1', price: 10.0, imageUrl: 'http://example.com/image1.jpg');
        final jsonString = jsonEncode(product.toJson());
        when(mockSharedPreferences.getString(CACHED_PRODUCTS)).thenReturn(jsonString);

        // Act
        final result = await localDataSource.getProductById(1);

        // Assert
        expect(result, product);
      },
    );
    test(
      'should throw CacheException when product not found',
      () {

        // Arrange
        when(mockSharedPreferences.getString(CACHED_PRODUCTS)).thenReturn(null);

        // Act & Assert
        expect(() => localDataSource.getProductById(1), throwsA(isA<CacheException>()));
      },
    );
    
    test(
      'should cache a single product',
      () async {
        // Arrange
        final product = ProductModel(id: 1, name: 'Product 1', description: 'Description 1', category: 'Category 1', price: 10.0, imageUrl: 'http://example.com/image1.jpg');
        final jsonString = jsonEncode(product.toJson());
        when(mockSharedPreferences.setString(CACHED_PRODUCTS, jsonString)).thenAnswer((_) async => true);

        // Act
        await localDataSource.cacheProduct(product);

        // Assert
        verify(mockSharedPreferences.setString(CACHED_PRODUCTS, jsonString)).called(1);
      },
    );

    test(
      'should delete a product by id',
      () async {
        // Arrange
        final product = ProductModel(id: 1, name: 'Product 1', description: 'Description 1', category: 'Category 1', price: 10.0, imageUrl: 'http://example.com/image1.jpg');
        final jsonString = jsonEncode([product.toJson()]);
        when(mockSharedPreferences.getString(CACHED_PRODUCTS)).thenReturn(jsonString);
        // Mocking the setString method to simulate deletion
        when(mockSharedPreferences.setString(CACHED_PRODUCTS, jsonString)).thenAnswer((_) async => true);

        // Act
        await localDataSource.deleteProduct(1);

        // Assert
        verify(mockSharedPreferences.setString(CACHED_PRODUCTS, jsonString)).called(1);
      },
    );

    test(
      'should update a product',
      () async {
        // Arrange
        final product = ProductModel(id: 1, name: 'Product 1', description: 'Description 1', category: 'Category 1', price: 10.0, imageUrl: 'http://example.com/image1.jpg');
        final updatedProduct = ProductModel(id: 1, name: 'Updated Product', description: 'Updated Description', category: 'Updated Category', price: 15.0, imageUrl: 'http://example.com/updated_image.jpg');
        final jsonString = jsonEncode([product.toJson()]);
        when(mockSharedPreferences.getString(CACHED_PRODUCTS)).thenReturn(jsonString);
        when(mockSharedPreferences.setString(CACHED_PRODUCTS, jsonEncode([updatedProduct.toJson()]))).thenAnswer((_) async => true);

        // Act
        await localDataSource.updateProduct(updatedProduct);

        // Assert
        verify(mockSharedPreferences.setString(CACHED_PRODUCTS, jsonEncode([updatedProduct.toJson()]))).called(1);
      },
    );

  });
  


}
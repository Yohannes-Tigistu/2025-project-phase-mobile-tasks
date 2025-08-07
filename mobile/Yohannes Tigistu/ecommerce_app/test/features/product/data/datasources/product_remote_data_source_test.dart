import 'dart:convert';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:ecommerce_app/core/errors/exeption.dart';
import 'package:ecommerce_app/features/Products/data/models/product_model.dart';
import 'package:ecommerce_app/features/Products/data/datasources/products_remote_data_source.dart';
import 'product_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late ProductsRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = ProductsRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('ProductsRemoteDataSourceImpl', () {
    Uri baseUrl =
        Uri.parse('https://g5-flutter-learning-path-be.onrender.com/api/v1/products');
    final tProductModel = ProductModel(
      id: 1,
      name: 'Test Product',
      description: 'This is a test product',
      category: 'Test Category',
      price: 19.99,
      imageUrl: 'http://example.com/image.jpg',
    );
    final tProductList = [tProductModel];
    final tProductListJson = json.encode(
      tProductList.map((p) => p.toJson()).toList(),
    );
    final tProductJson = json.encode(tProductModel.toJson());

    group('getAllProducts', () {
      test(
        'should return a list of products when the response is 200',
        () async {
          // Arrange
          when(
            mockHttpClient.get(
              baseUrl,
              headers: anyNamed('headers'),
            ),
          ).thenAnswer((_) async => http.Response(tProductListJson, 200));
          // Act
          final result = await dataSource.getAllProducts();
          // Assert
          expect(result, equals(tProductList));
        },
      );

      test(
        'should throw a ServerException when the response is not 200',
        () async {
          // Arrange
          when(
            mockHttpClient.get(
              (baseUrl),
              headers: anyNamed('headers'),
            ),
          ).thenAnswer((_) async => http.Response('Error', 404));
          // Act & Assert
          final call = dataSource.getAllProducts;
          expect(() => call(), throwsA(isA<ServerException>()));
        },
      );
    });

    group('getProductById', () {
      const tId = 1;
      test(
        'should return a product when getProductById is called and response is 200',
        () async {
          // Arrange
          when(
            mockHttpClient.get(
              Uri.parse('$baseUrl/$tId'),
              headers: anyNamed('headers'),
            ),
          ).thenAnswer((_) async => http.Response(tProductJson, 200));
          // Act
          final result = await dataSource.getProductById(tId);
          // Assert
          expect(result, equals(tProductModel));
        },
      );

      test(
        'should throw a ServerException when getProductById response is not 200',
        () async {
          // Arrange
          when(
            mockHttpClient.get(
              Uri.parse('$baseUrl/$tId'),
              headers: anyNamed('headers'),
            ),
          ).thenAnswer((_) async => http.Response('Error', 404));
          // Act & Assert
          final call = dataSource.getProductById;
          expect(() => call(tId), throwsA(isA<ServerException>()));
        },
      );
    });

    group('createProduct', () {
      test('should call post for createProduct and succeed on 201', () async {
        // Arrange
        when(
          mockHttpClient.post(
            baseUrl,
            headers: {'Content-Type': 'application/json'},
            body: tProductJson,
          ),
        ).thenAnswer((_) async => http.Response(tProductJson, 201));
        // Act
        await dataSource.createProduct(tProductModel);
        // Assert
        verify(
          mockHttpClient.post(
            baseUrl,
            headers: {'Content-Type': 'application/json'},
            body: tProductJson,
          ),
        );
      });

      test(
        'should throw ServerException if createProduct response is not 201',
        () async {
          // Arrange
          when(
            mockHttpClient.post(
              baseUrl,
              headers: {'Content-Type': 'application/json'},
              body: tProductJson,
            ),
          ).thenAnswer((_) async => http.Response('Error', 400));
          // Act & Assert
          final call = dataSource.createProduct;
          expect(() => call(tProductModel), throwsA(isA<ServerException>()));
        },
      );
    });

    group('updateProduct', () {
      final tId = tProductModel.id;
      test('should call put for updateProduct and succeed on 200', () async {
        // Arrange
        when(
          mockHttpClient.put(
            Uri.parse('$baseUrl/$tId'),
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer((_) async => http.Response(tProductJson, 200));
        // Act
        await dataSource.updateProduct(tProductModel);
        // Assert
        verify(
          mockHttpClient.put(
            Uri.parse('$baseUrl/$tId'),
            headers: {'Content-Type': 'application/json'},
            body: tProductJson,
          ),
        );
      });

      test(
        'should throw ServerException if updateProduct response is not 200',
        () async {
          // Arrange
          when(
            mockHttpClient.put(
              Uri.parse('$baseUrl/$tId'),
              headers: anyNamed('headers'),
              body: anyNamed('body'),
            ),
          ).thenAnswer((_) async => http.Response('Error', 400));
          // Act & Assert
          final call = dataSource.updateProduct;
          expect(() => call(tProductModel), throwsA(isA<ServerException>()));
        },
      );
    });

    group('deleteProduct', () {
      const tId = 1;
      test(
        'should call delete for deleteProduct and succeed on 200 or 204',
        () async {
          // Arrange
          when(
            mockHttpClient.delete(
              Uri.parse('$baseUrl/$tId'),
              headers: anyNamed('headers'),
            ),
          ).thenAnswer((_) async => http.Response('', 200));
          // Act
          await dataSource.deleteProduct(tId);
          // Assert
          verify(
            mockHttpClient.delete(
              Uri.parse('$baseUrl/$tId'),
              headers: {'Content-Type': 'application/json'},
            ),
          );
        },
      );

      test(
        'should throw ServerException if deleteProduct response is not 200 or 204',
        () async {
          // Arrange
          when(
            mockHttpClient.delete(
              Uri.parse('$baseUrl/$tId'),
              headers: anyNamed('headers'),
            ),
          ).thenAnswer((_) async => http.Response('Error', 400));
          // Act & Assert
          final call = dataSource.deleteProduct;
          expect(() => call(tId), throwsA(isA<ServerException>()));
        },
      );
    });
  });
}

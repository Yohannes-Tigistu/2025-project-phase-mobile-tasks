import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../../../lib/core/errors/exeption.dart';
import '../../../../../lib/features/Products/data/models/product_model.dart';
import '../../../../../lib/features/Products/data/datasources/products_remote_data_source.dart';
class MockHttpClient extends Mock implements http.Client {}

void main() {
  late ProductsRemoteDataSourceImpl productsRemoteDataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    productsRemoteDataSource = ProductsRemoteDataSourceImpl(
      client: mockHttpClient,
    );
  });

  group('ProductsRemoteDataSourceImpl', () {
    const baseUrl =
        'https://g5-flutter-learning-path-be.onrender.com/api/v1/products';
    final tProductModel = ProductModel(
      id: 1,
      name: 'Test Product',
      description: 'This is a test product',
      category: 'Test Category',
      price: 19.99,
      imageUrl: 'http://example.com/image.jpg',
    );
    final tProductListJson =
        '[{"id":1,"name":"Test Product","description":"This is a test product","category":"Test Category","price":19.99,"imageUrl":"http://example.com/image.jpg"}]';
    final tProductJson =
        '{"id":1,"name":"Test Product","description":"This is a test product","category":"Test Category","price":19.99,"imageUrl":"http://example.com/image.jpg"}';

    test('should return a list of products when the response is 200', () async {
      // Arrange
      when(
        mockHttpClient.get(Uri.parse(baseUrl), headers: anyNamed('headers')),
      ).thenAnswer((_) async => http.Response(tProductListJson, 200));
      // Act
      final result = await productsRemoteDataSource.getAllProducts();
      // Assert
      expect(result, isA<List<ProductModel>>());
      expect(result.first, equals(tProductModel));
    });

    test('should throw an exception when the response is not 200', () async {
      // Arrange
      when(
        mockHttpClient.get(Uri.parse(baseUrl), headers: anyNamed('headers')),
      ).thenAnswer((_) async => http.Response('Error', 404));
      // Act & Assert
      expect(
        () => productsRemoteDataSource.getAllProducts(),
        throwsA(isA<ServerException>()),
      );
    });

    test(
      'should return a product when getProductById is called and response is 200',
      () async {
        // Arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/1'),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer((_) async => http.Response(tProductJson, 200));
        // Act
        final result = await productsRemoteDataSource.getProductById(1);
        // Assert
        expect(result, equals(tProductModel));
      },
    );

    test(
      'should throw an exception when getProductById response is not 200',
      () async {
        // Arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/1'),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer((_) async => http.Response('Error', 404));
        // Act & Assert
        expect(
          () => productsRemoteDataSource.getProductById(1),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test('should call post for createProduct and succeed on 201', () async {
      // Arrange
      when(
        mockHttpClient.post(
          Uri.parse('https://api.example.com/products'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('', 201));
      // Act
      await productsRemoteDataSource.createProduct(tProductModel);
      // Assert
      verify(
        mockHttpClient.post(
          Uri.parse('https://api.example.com/products'),
          body: anyNamed('body'),
        ),
      );
    });

    test(
      'should throw exception if createProduct response is not 201',
      () async {
        // Arrange
        when(
          mockHttpClient.post(
            Uri.parse('https://api.example.com/products'),
            body: anyNamed('body'),
          ),
        ).thenAnswer((_) async => http.Response('Error', 400));
        // Act & Assert
        expect(
          () => productsRemoteDataSource.createProduct(tProductModel),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test('should call put for updateProduct and succeed on 200', () async {
      // Arrange
      when(
        mockHttpClient.put(
          Uri.parse('https://api.example.com/products/1'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('', 200));
      // Act
      await productsRemoteDataSource.updateProduct(tProductModel);
      // Assert
      verify(
        mockHttpClient.put(
          Uri.parse('https://api.example.com/products/1'),
          body: anyNamed('body'),
        ),
      );
    });

    test(
      'should throw exception if updateProduct response is not 200',
      () async {
        // Arrange
        when(
          mockHttpClient.put(
            Uri.parse('https://api.example.com/products/1'),
            body: anyNamed('body'),
          ),
        ).thenAnswer((_) async => http.Response('Error', 400));
        // Act & Assert
        expect(
          () => productsRemoteDataSource.updateProduct(tProductModel),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test('should call delete for deleteProduct and succeed on 204', () async {
      // Arrange
      when(
        mockHttpClient.delete(Uri.parse('https://api.example.com/products/1')),
      ).thenAnswer((_) async => http.Response('', 204));
      // Act
      await productsRemoteDataSource.deleteProduct(1);
      // Assert
      verify(
        mockHttpClient.delete(Uri.parse('https://api.example.com/products/1')),
      );
    });

    test(
      'should throw exception if deleteProduct response is not 204',
      () async {
        // Arrange
        when(
          mockHttpClient.delete(
            Uri.parse('https://api.example.com/products/1'),
          ),
        ).thenAnswer((_) async => http.Response('Error', 400));
        // Act & Assert
        expect(
          () => productsRemoteDataSource.deleteProduct(1),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });
}

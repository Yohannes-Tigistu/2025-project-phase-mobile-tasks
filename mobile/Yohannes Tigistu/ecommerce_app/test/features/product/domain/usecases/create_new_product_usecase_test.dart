import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/success/confirmation.dart';
import 'package:ecommerce_app/features/Products/domain/entities/product.dart';
import 'package:ecommerce_app/features/Products/domain/repositories/product_repository.dart';
import 'package:ecommerce_app/features/Products/domain/usecases/create_new_product_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'create_new_product_usecase_test.mocks.dart';

const serverFailureMessage = 'Server Failure';


@GenerateMocks([ProductRepository])
void main() {
  late CreateNewProductUsecase usecase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    usecase = CreateNewProductUsecase(mockProductRepository);
  });

  final testProduct = const Product(
    id: 1,
    name: 'Test Product',
    description: 'A product for testing',
    price: 10.0,
    imageUrl: 'http://example.com/image.png',
    category: 'Electronics'
  );
  final params =  testProduct;
  final confirmation = Confirmation('Product created successfully');

  test('should call repository.createProduct and return Confirmation on success', () async {
    // arrange
    when(mockProductRepository.createProduct(testProduct))
        .thenAnswer((_) async => Right(confirmation));
    // act
    final result = await usecase.call(params);
    // assert
    expect(result, Right(confirmation));
    verify(mockProductRepository.createProduct(testProduct));
    verifyNoMoreInteractions(mockProductRepository);
  });

  test('should return Failure when repository.createProduct fails', () async {
    // arrange
    final failure = ServerFailure(serverFailureMessage);
    when(mockProductRepository.createProduct(testProduct))
        .thenAnswer((_) async => Left(failure));
    // act
    final result = await usecase.call(params);
    // assert
    expect(result, Left(failure));
    verify(mockProductRepository.createProduct(testProduct));
    verifyNoMoreInteractions(mockProductRepository);
  });
}





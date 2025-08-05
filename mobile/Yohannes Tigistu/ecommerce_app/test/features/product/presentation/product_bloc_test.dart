import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/success/confirmation.dart';
import 'package:ecommerce_app/core/usecases/usecase.dart';
import 'package:ecommerce_app/core/utils/input_converter.dart';
import 'package:ecommerce_app/features/Products/domain/entities/product.dart';
import 'package:ecommerce_app/features/Products/domain/usecases/create_new_product_usecase.dart';
import 'package:ecommerce_app/features/Products/domain/usecases/delete_product_usecase.dart';
import 'package:ecommerce_app/features/Products/domain/usecases/update_product_usecase.dart';
import 'package:ecommerce_app/features/Products/domain/usecases/view_all_products_usecase.dart';
import 'package:ecommerce_app/features/Products/domain/usecases/view_specific_product_usecase.dart';
import 'package:ecommerce_app/features/Products/presentation/bloc/product_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_bloc_test.mocks.dart';

// Use the same constants as in the BLoC file
const String kProductCreateSuccess = 'Product created successfully';
const String kProductCreateError = 'Failed to create product';
const String kProductUpdateSuccess = 'Product updated successfully';
const String kProductUpdateError = 'Failed to update product';
const String kProductDeleteSuccess = 'Product deleted successfully';
const String kProductDeleteError = 'Failed to delete product';
const String kProductLoadAllError = 'Failed to load products';
const String kProductLoadByIdError = 'Failed to load product';

@GenerateMocks([
  InputConverter,
  CreateNewProductUsecase,
  DeleteProductUsecase,
  ViewAllProductsUsecase,
  UpdateProductUsecase,
  ViewSpecificProductUsecase,
])
void main() {
  late ProductBloc productBloc;
  late MockInputConverter mockInputConverter;
  late MockCreateNewProductUsecase mockCreateNewProductUsecase;
  late MockDeleteProductUsecase mockDeleteProductUsecase;
  late MockViewAllProductsUsecase mockViewAllProductsUsecase;
  late MockUpdateProductUsecase mockUpdateProductUsecase;
  late MockViewSpecificProductUsecase mockViewSpecificProductUsecase;

  setUp(() {
    mockInputConverter = MockInputConverter();
    mockCreateNewProductUsecase = MockCreateNewProductUsecase();
    mockDeleteProductUsecase = MockDeleteProductUsecase();
    mockViewAllProductsUsecase = MockViewAllProductsUsecase();
    mockUpdateProductUsecase = MockUpdateProductUsecase();
    mockViewSpecificProductUsecase = MockViewSpecificProductUsecase();

    productBloc = ProductBloc(
      createNewProductUsecase: mockCreateNewProductUsecase,
      deleteProductUsecase: mockDeleteProductUsecase,
      viewAllProductsUsecase: mockViewAllProductsUsecase,
      updateProductUsecase: mockUpdateProductUsecase,
      getProductByIdUsecase: mockViewSpecificProductUsecase,
      inputConverter: mockInputConverter,
    );
  });

  final tProduct = const Product(
    id: 1,
    name: 'Test Product',
    description: 'A test product',
    category: 'Test',
    price: 9.99,
    imageUrl: 'test.jpg',
  );

  test("initial state should be ProductInitialState", () {
    expect(productBloc.state, InitialState());
  });

  group('AddProductEvent', () {
    blocTest<ProductBloc, ProductState>(
      'should emit [ProductCreateLoadingState, ProductCreateSuccessState] when product is created successfully',
      build: () {
        when(
          mockCreateNewProductUsecase(any),
        ).thenAnswer((_) async => Right(Confirmation('Success')));
        return productBloc;
      },
      act: (bloc) => bloc.add(CreateProductEvent(product: tProduct)),
      expect: () => [
        CreateProductLoadingState(),
        CreateProductSuccessState(message: kProductCreateSuccess),
      ],
      verify: (_) {
        verify(mockCreateNewProductUsecase(tProduct));
      },
    );

    blocTest<ProductBloc, ProductState>(
      'should emit [ProductCreateLoadingState, ProductCreateErrorState] when product creation fails',
      build: () {
        when(
          mockCreateNewProductUsecase(any),
        ).thenAnswer((_) async => Left(ServerFailure()));
        return productBloc;
      },
      act: (bloc) => bloc.add(CreateProductEvent(product: tProduct)),
      expect: () => [
        CreateProductLoadingState(),
        CreateProductErrorState(message: kProductCreateError),
      ],
      verify: (_) {
        verify(mockCreateNewProductUsecase(tProduct));
      },
    );
  });

  group('UpdateProductEvent', () {
    blocTest<ProductBloc, ProductState>(
      'should emit [ProductUpdateLoadingState, ProductUpdateSuccessState] when product is updated successfully',
      build: () {
        when(
          mockUpdateProductUsecase(any),
        ).thenAnswer((_) async => Right(Confirmation('Success')));
        return productBloc;
      },
      act: (bloc) => bloc.add(UpdateProductEvent(product: tProduct)),
      expect: () => [
        UpdateProductLoadingState(),
        UpdateProductSuccessState(message: kProductUpdateSuccess),
      ],
      verify: (_) {
        verify(mockUpdateProductUsecase(tProduct));
      },
    );

    blocTest<ProductBloc, ProductState>(
      'should emit [ProductUpdateLoadingState, ProductUpdateErrorState] when product update fails',
      build: () {
        when(
          mockUpdateProductUsecase(any),
        ).thenAnswer((_) async => Left(ServerFailure()));
        return productBloc;
      },
      act: (bloc) => bloc.add(UpdateProductEvent(product: tProduct)),
      expect: () => [
        UpdateProductLoadingState(),
        UpdateProductErrorState(message: kProductUpdateError),
      ],
      verify: (_) {
        verify(mockUpdateProductUsecase(tProduct));
      },
    );
  });

  group('DeleteProductEvent', () {
    final tProductId = 1;
    blocTest<ProductBloc, ProductState>(
      'should emit [ProductDeleteLoadingState, ProductDeleteSuccessState] when product is deleted successfully',
      build: () {
        when(
          mockDeleteProductUsecase(any),
        ).thenAnswer((_) async => Right(Confirmation('Success')));
        return productBloc;
      },
      act: (bloc) => bloc.add(DeleteProductEvent(productId: tProductId)),
      expect: () => [
        DeleteProductLoadingState(),
        DeleteProductSuccessState(message: kProductDeleteSuccess),
      ],
      verify: (_) {
        verify(mockDeleteProductUsecase(tProductId));
      },
    );

    blocTest<ProductBloc, ProductState>(
      'should emit [ProductDeleteLoadingState, ProductDeleteErrorState] when product deletion fails',
      build: () {
        when(
          mockDeleteProductUsecase(any),
        ).thenAnswer((_) async => Left(ServerFailure()));
        return productBloc;
      },
      act: (bloc) => bloc.add(DeleteProductEvent(productId: tProductId)),
      expect: () => [
        DeleteProductLoadingState(),
        DeleteProductErrorState(message: kProductDeleteError),
      ],
      verify: (_) {
        verify(mockDeleteProductUsecase(tProductId));
      },
    );
  });

  group('LoadAllProductsEvent', () {
    final tProductList = [tProduct];
    blocTest<ProductBloc, ProductState>(
      'should emit [ProductViewAllLoadingState, ProductViewAllLoadedState] when products are loaded successfully',
      build: () {
        when(
          mockViewAllProductsUsecase(any),
        ).thenAnswer((_) async => Right(tProductList));
        return productBloc;
      },
      act: (bloc) => bloc.add(LoadAllProductsEvent()),
      expect: () => [
        LoadingAllProductsState(),
        LoadedAllProductsState(products: tProductList),
      ],
      verify: (_) {
        verify(mockViewAllProductsUsecase(NoParams()));
      },
    );

    blocTest<ProductBloc, ProductState>(
      'should emit [ProductViewAllLoadingState, ProductViewAllErrorState] when loading products fails',
      build: () {
        when(
          mockViewAllProductsUsecase(any),
        ).thenAnswer((_) async => Left(ServerFailure()));
        return productBloc;
      },
      act: (bloc) => bloc.add(LoadAllProductsEvent()),
      expect: () => [
        LoadingAllProductsState(),
        LoadAllProductsErrorState(message: kProductLoadAllError),
      ],
      verify: (_) {
        verify(mockViewAllProductsUsecase(NoParams()));
      },
    );
  });

  group('LoadProductByIdEvent', () {
    final tProductId = 1;
    blocTest<ProductBloc, ProductState>(
      'should emit [ProductViewAllLoadingState, ProductViewAllLoadedState] when a product is loaded successfully',
      build: () {
        when(
          mockViewSpecificProductUsecase(any),
        ).thenAnswer((_) async => Right(tProduct));
        return productBloc;
      },
      act: (bloc) => bloc.add(GetSingleProductEvent(productId: tProductId)),
      expect: () => [
        LoadingSingleProductState(),
        LoadedSingleProductState(product: tProduct),
      ],
      verify: (_) {
        verify(mockViewSpecificProductUsecase(tProductId));
      },
    );

    blocTest<ProductBloc, ProductState>(
      'should emit [ProductViewAllLoadingState, ProductViewAllErrorState] when loading a product fails',
      build: () {
        when(
          mockViewSpecificProductUsecase(any),
        ).thenAnswer((_) async => Left(ServerFailure()));
        return productBloc;
      },
      act: (bloc) => bloc.add(GetSingleProductEvent(productId: tProductId)),
      expect: () => [
        LoadingSingleProductState(),
        LoadSingleProductErrorState(message: kProductLoadByIdError),
      ],
      verify: (_) {
        verify(mockViewSpecificProductUsecase(tProductId));
      },
    );
  });
}

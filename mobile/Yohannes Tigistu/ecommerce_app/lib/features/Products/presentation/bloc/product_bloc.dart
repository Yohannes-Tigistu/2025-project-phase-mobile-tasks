import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/success/confirmation.dart';
import '../../../../core/utils/input_converter.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/create_new_product_usecase.dart' ;
import '../../domain/usecases/delete_product_usecase.dart' ;
import '../../domain/usecases/update_product_usecase.dart' ;
import '../../domain/usecases/view_all_products_usecase.dart' ;
import '../../domain/usecases/view_specific_product_usecase.dart' ;
import '../../../../core/usecases/usecase.dart';

part 'product_event.dart';
part 'product_state.dart';

const String kProductCreateError = 'Failed to create product';
const String kProductUpdateError = 'Failed to update product';
const String kProductDeleteError = 'Failed to delete product';
const String kProductLoadAllError = 'Failed to load products';
const String kProductLoadByIdError = 'Failed to load product';
const String kProductCreateSuccess = 'Product created successfully';
const String kProductUpdateSuccess = 'Product updated successfully';
const String kProductDeleteSuccess = 'Product deleted successfully';  

class ProductBloc extends Bloc<ProductEvent, ProductState> {

  final ViewAllProductsUsecase viewAllProductsUsecase;
  final CreateNewProductUsecase createNewProductUsecase;
  final UpdateProductUsecase updateProductUsecase;
  final DeleteProductUsecase deleteProductUsecase;
  final ViewSpecificProductUsecase getProductByIdUsecase;
  final InputConverter inputConverter ;
  
  ProductBloc({
    required this.inputConverter,
    required this.createNewProductUsecase,
    required this.deleteProductUsecase,
    required this.viewAllProductsUsecase,
    required this.updateProductUsecase,
    required this.getProductByIdUsecase,
  }):super(InitialState()) {
    on<CreateProductEvent>(_onAddProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
    on<LoadAllProductsEvent>(_onLoadAllProducts);
    on<GetSingleProductEvent>(_onLoadProductById);
  }

  Future<void> _onAddProduct(CreateProductEvent event, Emitter<ProductState> emit) async {
    emit(CreateProductLoadingState());
     final result = await createNewProductUsecase.call(( event.product));
    result.fold(
      (failure) => emit(CreateProductErrorState(message: kProductCreateError)),     
      (confirmation) => emit(CreateProductSuccessState(message: kProductCreateSuccess)),
    );
  }

  Future<void> _onUpdateProduct(UpdateProductEvent event, Emitter<ProductState> emit) async {
    emit(UpdateProductLoadingState());
    final result = await updateProductUsecase.call((event.product));
    result.fold(
      (failure) => emit(UpdateProductErrorState(message: kProductUpdateError)),
      (confirmation) => emit(UpdateProductSuccessState(message: kProductUpdateSuccess)),
    );
  }

  Future<void> _onDeleteProduct(DeleteProductEvent event, Emitter<ProductState> emit) async {
    emit(DeleteProductLoadingState());

    final result = await deleteProductUsecase.call((event.productId));
    result.fold(
        (failure) => emit(DeleteProductErrorState(message: kProductDeleteError)),
        (success) => emit(DeleteProductSuccessState(message: kProductDeleteSuccess)),
      );
    }
  
    Future<void> _onLoadAllProducts(LoadAllProductsEvent event, Emitter<ProductState> emit) async {
      emit(LoadingAllProductsState());

      final result = await viewAllProductsUsecase.call(NoParams());
      result.fold(
        (failure) => emit(LoadAllProductsErrorState(message: kProductLoadAllError)),
        (products) => emit(LoadedAllProductsState(products: products)),
      );
  }

    Future<void> _onLoadProductById(GetSingleProductEvent event, Emitter<ProductState> emit) async {
      // Implementation for loading a product by ID
      emit(LoadingSingleProductState());
      final result = await getProductByIdUsecase.call((event.productId));
      result.fold(
        (failure) => emit(LoadSingleProductErrorState(message: kProductLoadByIdError)),
        (product) => emit(LoadedSingleProductState(product: product)),
      );
    }
  }
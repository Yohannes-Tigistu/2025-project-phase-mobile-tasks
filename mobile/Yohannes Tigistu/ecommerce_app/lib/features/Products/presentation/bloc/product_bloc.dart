import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/utils/input_converter.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/create_new_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../domain/usecases/view_all_products_usecase.dart';
import '../../domain/usecases/view_specific_product_usecase.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {

  final ViewAllProductsUsecase viewAllProductsUsecase;
  final CreateNewProductUsecase createNewProductUsecase;
  final UpdateProductUsecase updateProductUsecase;
  final DeleteProductUsecase deleteProductUsecase;
  final ViewSpecificProductUsecase getProductByIdUsecase;
  final InputConverter inputConverter ;

  ProductBloc({
    required ViewAllProductsUsecase viewall ,
    required CreateNewProductUsecase create,
    required UpdateProductUsecase update,
    required DeleteProductUsecase delete,
    required ViewSpecificProductUsecase getByIdUsecase,
    required this. inputConverter,

  }):
      viewAllProductsUsecase = viewall,
      createNewProductUsecase = create,
      updateProductUsecase = update,
      deleteProductUsecase = delete,
      getProductByIdUsecase = getByIdUsecase,
      super(ProductInitialState()) ;
  @override
  ProductState get initialState => ProductInitialState();
  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
 
  }}
part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}
class CreateProductEvent extends ProductEvent {
  final Product product;

  const CreateProductEvent({required this.product});

  @override
  List<Object> get props => [product];
}
class UpdateProductEvent extends ProductEvent {
  final Product product;

  const UpdateProductEvent({required this.product});

  @override
  List<Object> get props => [product];
}
class DeleteProductEvent extends ProductEvent {
  final int productId;

  const DeleteProductEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}
class LoadAllProductsEvent extends ProductEvent {

}

class GetSingleProductEvent extends ProductEvent {
  final int productId;

  const GetSingleProductEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}

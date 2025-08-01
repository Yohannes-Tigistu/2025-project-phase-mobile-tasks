part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}
class AddProductEvent extends ProductEvent {
  final Product product;

  const AddProductEvent({required this.product});

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
class GetAllProductsEvent extends ProductEvent {
  const GetAllProductsEvent();

  @override
  List<Object> get props => [];
}
class GetProductByIdEvent extends ProductEvent {
  final int productId;

  const GetProductByIdEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}

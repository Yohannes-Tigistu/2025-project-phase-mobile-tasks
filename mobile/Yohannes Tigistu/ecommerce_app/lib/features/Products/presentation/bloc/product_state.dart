part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();
  
  @override
  List<Object> get props => [];
}

final class InitialState extends ProductState {
  const InitialState();
}
final class LoadingAllProductsState extends ProductState {}
final class LoadedAllProductsState extends ProductState {
  final List<Product> products;
  const LoadedAllProductsState({required this.products});

  @override
  List<Object> get props => [products];
}
final class LoadAllProductsErrorState extends ProductState {
  final String message;
  const LoadAllProductsErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
final class LoadingSingleProductState extends ProductState {}
final class LoadedSingleProductState extends ProductState {
  final Product product;
  const LoadedSingleProductState({required this.product});

}
final class LoadSingleProductErrorState extends ProductState {
  final String message;
  const LoadSingleProductErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
final class DeleteProductLoadingState extends ProductState {}
final class DeleteProductSuccessState extends ProductState {
  final String message;
  const DeleteProductSuccessState({required this.message});
  @override
  List<Object> get props => [message];
}
final class DeleteProductErrorState extends ProductState {
  final String message;
  const DeleteProductErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
final class UpdateProductLoadingState extends ProductState {}
final class UpdateProductSuccessState extends ProductState {
  final String message;
  const UpdateProductSuccessState({required this.message});
  @override
  List<Object> get props => [message];

}
final class UpdateProductErrorState extends ProductState {
  final String message;
  const UpdateProductErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

final class CreateProductLoadingState extends ProductState {}
final class CreateProductSuccessState extends ProductState {
  final String message;
  const CreateProductSuccessState({required this.message});
  @override
  List<Object> get props => [message];
}
final class CreateProductErrorState extends ProductState {
  final String message;
  const CreateProductErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
final class ProductErrorState extends ProductState {
  final String message;
  const ProductErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();
  
  @override
  List<Object> get props => [];
}

final class ProductInitialState extends ProductState {}
final class ProductViewAllLoadingState extends ProductState {}
final class ProductViewAllLoadedState extends ProductState {
  final List<Product> products;
  const ProductViewAllLoadedState({required this.products});

  @override
  List<Object> get props => [products];
}
final class ProductDeleteLoadingState extends ProductState {}
final class ProductDeleteSuccessState extends ProductState {
  
}
final class ProductUpdateLoadingState extends ProductState {}
final class ProductUpdateSuccessState extends ProductState {
  final String message;
  const ProductUpdateSuccessState({required this.message}); 
  @override
  List<Object> get props => [message];
}
final class ProductCreateLoadingState extends ProductState {}
final class ProductCreateSuccessState extends ProductState {
  final String message;
  const ProductCreateSuccessState({required this.message});
  @override
  List<Object> get props => [message];
}
final class ProductErrorState extends ProductState {
  final String message;
  const ProductErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
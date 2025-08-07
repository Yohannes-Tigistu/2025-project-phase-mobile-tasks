
import 'package:equatable/equatable.dart';

class Product extends Equatable{
  
  final int id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  // @override
  // String toString() {
  //   return 'Product{id: $id, name: $name, description: $description, price: $price, imageUrl: $imageUrl}';
  // }
  @override
  List<Object> get props => [id, name, description, category, price, imageUrl];     
}

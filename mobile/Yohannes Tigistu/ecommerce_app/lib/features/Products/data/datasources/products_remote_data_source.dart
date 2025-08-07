import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../core/errors/exeption.dart';
import '../models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProductById(int id);
  Future<void> createProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(int id);
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  // This class would implement the methods to interact with a remote API
  // For example, using http package to make network requests
  final http.Client client;

  ProductsRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getAllProducts() async {
    return await _fetchProductsFromUrl(
      'https://g5-flutter-learning-path-be.onrender.com/api/v1/products',
    );
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final products = await _fetchProductsFromUrl(
      'https://g5-flutter-learning-path-be.onrender.com/api/v1/products/$id',
      single: true,
    );
    return products.first;
  }

  Future<List<ProductModel>> _fetchProductsFromUrl(String url, {bool single = false}) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (single) {
        return [ProductModel.fromJson(decoded)];
      } else if (decoded is List) {
        return decoded.map<ProductModel>((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> createProduct(ProductModel product) async {
    final response = await client.post(
      'https://api.example.com/products' as Uri,
      body: json.encode(product.toJson()),
    );
    if (response.statusCode != 201) {
      throw ServerException();
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    final response = await client.put(
      'https://api.example.com/products/${product.id}' as Uri,
      body: json.encode(product.toJson()),
    );
    if (response.statusCode != 200) {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    final response = await client.delete(
      'https://api.example.com/products/$id' as Uri,
    );
    if (response.statusCode != 204) {
      throw ServerException();
    }
  }
}

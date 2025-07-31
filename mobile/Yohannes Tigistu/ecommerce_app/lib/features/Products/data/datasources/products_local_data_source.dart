import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exeption.dart';
import '../models/product_model.dart';

abstract class ProductsLocalDataSource {
  Future<List<ProductModel>> getLastProducts();
  Future<void> cacheProducts(List<ProductModel> products);
  Future<ProductModel> getProductById(int id);
  Future<void> cacheProduct(ProductModel product);
  Future<void> deleteProduct(int id);
  Future<void> updateProduct(ProductModel product);
}
const CACHED_PRODUCTS = 'cached_products';

class ProductsLocalDataSourceImpl implements ProductsLocalDataSource {
  // This class would implement the methods to interact with local storage
  // For example, using shared_preferences or a local database like sqflite
  final SharedPreferences sharedPreferences;

  ProductsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ProductModel>> getLastProducts() {
    // Implementation to fetch last cached products
    final jsonString = sharedPreferences.getString(CACHED_PRODUCTS);

    if (jsonString != null) {
      final List<dynamic> jsonList = jsonString as List<dynamic>;
      return Future.value(jsonList.map((json) => ProductModel.fromJson(json)).toList());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) {
    final jsonString = products.map((product) => product.toJson()).toList();
    sharedPreferences.setString(CACHED_PRODUCTS, jsonString.toString());
    return Future.value();
  }

  @override
  Future<ProductModel> getProductById(int id) {
    // Implementation to get a product by ID
    final jsonString = sharedPreferences.getString(CACHED_PRODUCTS);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonString as List<dynamic>;
      final productJson = jsonList.firstWhere((json) => json['id'] == id, orElse: () => null);
      if (productJson != null) {
        return Future.value(ProductModel.fromJson(productJson));
      } else {
        throw CacheException();
      }
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheProduct(ProductModel product) {
    // Implementation to cache a single product
    final jsonString = product.toJson();
    final cachedProducts = sharedPreferences.getStringList(CACHED_PRODUCTS) ?? [];
    cachedProducts.add(jsonString.toString());
    sharedPreferences.setStringList(CACHED_PRODUCTS, cachedProducts);
    return Future.value();
  }

  @override
  Future<void> deleteProduct(int id) {
    // find and delet the product by id
    final jsonString = sharedPreferences.getString(CACHED_PRODUCTS);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonString as List<dynamic>;
      final updatedList = jsonList.where((json) => json['id'] != id).toList();
      sharedPreferences.setString(CACHED_PRODUCTS, updatedList.toString());
      return Future.value();
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) {
    // should update the product in the cache
    final jsonString = sharedPreferences.getString(CACHED_PRODUCTS);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonString as List<dynamic>;
      final index = jsonList.indexWhere((json) => json['id'] == product.id);
      if (index != -1) {
        jsonList[index] = product.toJson();
        sharedPreferences.setString(CACHED_PRODUCTS, jsonList.toString());
        return Future.value();
      } else {
        throw CacheException();
      }
    } else {
      throw CacheException();
    }
  }
}
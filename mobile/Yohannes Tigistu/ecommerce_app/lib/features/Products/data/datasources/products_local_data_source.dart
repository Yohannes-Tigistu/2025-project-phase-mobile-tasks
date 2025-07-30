import '../models/product_model.dart';

abstract class ProductsLocalDataSource {
  Future<List<ProductModel>> getLastProducts();
  Future<void> cacheProducts(List<ProductModel> products);
  Future<ProductModel> getProductById(int id);
  Future<void> cacheProduct(ProductModel product);
  Future<void> deleteProduct(int id);
  Future<void> updateProduct(ProductModel product);
}

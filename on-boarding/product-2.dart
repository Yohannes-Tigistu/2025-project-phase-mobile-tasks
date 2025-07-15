void main() {}

class Product {
  String? name, description;
  double? price;
}

class ProductManager {
  var products = {};
  void addproduct(Product p) {
    products[p.name] = p;
  }

  void showproducts() {
    print(products);
  }

  Product showSingleProduct(String name) {
    return products[name];
  }

  void editSingleProduct(String name) {
    
  }
  void deleteProduct(String name){
    if (products.containsKey(name)){
      products.remove(name);
      print('Product sucessfully deleted');
    }else {
      print("product deletion Failed: Product doesn't exist");
    }
    
  }
}

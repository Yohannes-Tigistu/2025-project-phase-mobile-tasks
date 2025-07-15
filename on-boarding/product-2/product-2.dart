import 'dart:io';

void main() {
    ProductManager pm = ProductManager();
  while (true) {
    print("Product Manager Menu:");
    print("1. Add Product");
    print("2. Show All Products");
    print("3. Show Single Product");
    print("4. Edit Product");
    print("5. Delete Product");
    print("6. Exit");
    stdout.write("Enter your choice: ");
    var choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        print("Enter product name:");
        String name = stdin.readLineSync() ?? "";
        print("Enter product description:");
        String description = stdin.readLineSync() ?? "";
        print("Enter product price:");
        double? price = double.tryParse(stdin.readLineSync() ?? "");
        if (price == null) {
          print("Invalid price.");
          break;
        }
        Product p = Product();
        p.setName(name);
        p.setDescription(description);
        p.setPrice(price);
        pm.addproduct(p);
        print("Product added successfully.");
        break;
      case '2':
        pm.showproducts();
        break;
      case '3':
        print("Enter product name to show:");
        String name = stdin.readLineSync() ?? "";
        Product? p = pm.showSingleProduct(name);
        if (p != null) {
          print("Name: ${p.getName()}");
          print("Description: ${p.getDescription()}");
          print("Price: ${p.getPrice()}");
        } else {
          print("Product not found.");
        }
        break;
      case '4':
        print("Enter product name to edit:");
        String name = stdin.readLineSync() ?? "";
        pm.editSingleProduct(name);
        break;
      case '5':
        print("Enter product name to delete:");
        String name = stdin.readLineSync() ?? "";
        pm.deleteProduct(name);
        break;
      case '6':
        exit(0);
      default:
        print("Invalid choice. Please try again.");
    }
  }
}

class Product {
  String? name, description;
  double? price;

  void setName(String name) {
    this.name = name;
  }

  void setDescription(String description) {
    this.description = description;
  }

  void setPrice(double price) {
    this.price = price;
  }

  String? getName() {
    return this.name;
  }

  String? getDescription() {
    return this.description;
  }

  double? getPrice() {
    return this.price;
  }
}

class ProductManager {
  Map<String?, Product> products = {};
  void addproduct(Product p) {
    print(p);
    print(p.getName());
    products[p.getName()] = p;
  }

  void showproducts() {
    if (products.length >0){
    for (var product in products.values){
      var name = product.getName();
      var description = product.getDescription();
      var price = product.getPrice();
      print("Name : $name");
      print("Description : $description");
      print("Price: $price");
      print(" ");
    }
    }else{
      print("oops looks like not products here ");
    }
    
  }

  Product? showSingleProduct(String name) {
    return products[name];
  }

  void editSingleProduct(String name) {
    if (products.containsKey(name)) {
      Product p = products[name]!;
      print("Enter new name:");
      p.setName(stdin.readLineSync() ?? "");
      print("Enter new description:");
      p.setDescription(stdin.readLineSync() ?? "");
      print("Enter new price:");
      double? price = double.tryParse(stdin.readLineSync() ?? "");
      if (price != null) {
        p.setPrice(price);
      }
      // Update the product in the map with the new name if changed
      products.remove(name);
      products[p.getName()] = p;
      print('Product successfully updated');
    } else {
      print("Product update failed: Product doesn't exist");
    }
  }

  void deleteProduct(String name) {
    if (products.containsKey(name)) {
      products.remove(name);
      print('Product sucessfully deleted');
    } else {
      print("product deletion Failed: Product doesn't exist");
    }
  }
}

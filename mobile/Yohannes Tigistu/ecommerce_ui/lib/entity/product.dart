import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

import 'package:flutter/material.dart';

class Product {
  String? name, description, catagory;
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

  void setCatagory(String catagory) {
    this.catagory = catagory;
  }

  String? getName() {
    return name;
  }

  String? getDescription() {
    return description;
  }

  double? getPrice() {
    return price;
  }

  String? getCatagory() {
    return catagory;
  }
}

class ProductManager {
  Map<String?, Product> products = {};
  void addproduct(Product p) {
    products[p.getName()] = p;
  }

  Product? showSingleProduct(String name) {
    return products[name];
  }

  void editSingleProduct(String name) {
    if (products.containsKey(name)) {
      Product p = products[name]!;

      // p.setName(stdin.readLineSync() ?? "");

      // p.setDescription(stdin.readLineSync() ?? "");

      // double? price = double.tryParse(stdin.readLineSync() ?? "");
      // if (price != null) {
      //   p.setPrice(price);
      // }
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

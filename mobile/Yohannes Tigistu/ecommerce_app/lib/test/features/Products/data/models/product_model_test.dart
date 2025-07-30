// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';


import 'package:flutter_test/flutter_test.dart';

import '../../../../../features/Products/data/models/product_model.dart';
import '../../../../fixtures/fixture_reader.dart';

void main(){
  final ProductModel productModel = ProductModel(
    id: 1,
    name: 'Test Product',
    description: 'This is a test product',
    category: 'Test Category',
    price: 19.99,
    imageUrl: 'http://example.com/image.jpg',
  );
  group('fromJson', () {
    test('should return a valid model from JSON', () {
      final Map<String, dynamic> jsonMap = json.decode(fixture('product_model.json'));
      final result = ProductModel.fromJson(jsonMap);
      expect(result, productModel);
    });
  });
  group('toJson', () {
    test('should return a JSON map containing the proper data', () {
      final result = productModel.toJson();
      final expectedMap = {
        'id': 1,
        'name': 'Test Product',
        'description': 'This is a test product',
        'category': 'Test Category',
        'price': 19.99,
        'imageUrl': 'http://example.com/image.jpg',
      };
      expect(result, expectedMap);
    });
  } );
}
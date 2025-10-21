import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class ProductsProvider with ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Lorem ipsum dolor sit amet consectetur',
      price: 17.00,
      image: 'assets/images/4AA32357-E9FC-4176-84AF-DF4CA24D9257.png',
    ),
    Product(
      id: '2',
      name: 'Lorem ipsum dolor sit amet consectetur',
      price: 17.00,
      image: 'assets/images/11C75DC3-87F5-4EB0-A41E-E880306250E7.png',
    ),
    Product(
      id: '3',
      name: 'Lorem ipsum dolor sit amet consectetur',
      price: 17.00,
      image: 'assets/images/32EB245A-E30D-4D15-B57A-23A577C43459.png',
    ),
    Product(
      id: '4',
      name: 'Lorem ipsum dolor sit amet consectetur',
      price: 17.00,
      image: 'assets/images/92CAF77E-01B5-48CD-8DC9-DD5D205768ED.png',
    ),
    Product(
      id: '5',
      name: 'Lorem ipsum dolor sit amet consectetur',
      price: 17.00,
      image: 'assets/images/333CBBCA-9390-4C5A-A60A-21E776BF77D2.png',
    ),
    Product(
      id: '6',
      name: 'Lorem ipsum dolor sit amet consectetur',
      price: 17.00,
      image: 'assets/images/2289C231-211F-4850-B7AF-5EF0F942B4F7.png',
    ),
    Product(
      id: '7',
      name: 'Lorem ipsum dolor sit amet consectetur',
      price: 17.00,
      image: 'assets/images/098576F0-C6F3-4E05-8E3F-2D9CD12D2573.png',
    ),
    Product(
      id: '8',
      name: 'Lorem ipsum dolor sit amet consectetur',
      price: 17.00, 
      image: 'assets/images/92265483-9E7E-4FC3-A355-16CCA677C11C.png',
    ),
    Product(
      id: '9',
      name: 'Lorem ipsum dolor sit amet consectetur',
      price: 17.00,
      image: 'assets/images/AB90E177-EBD5-42AF-A94E-05F24787DEE2.png',
    ),
  ];

  List<Product> get products => _products;

  Product getProductById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }
}
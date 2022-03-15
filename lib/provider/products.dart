import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_app/provider/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorites {
    return _items.where((product) => product.isFavorite).toList();
  }

  int itemCount() {
    int count = _items.length;
    print('in item count ${_items.length}');
    return count;
  }

  Product findById(String id) {
    final prod = _items.firstWhere((item) => id == item.id);
    return prod;
  }

  Future<void> addProduct(Product product) async {
    final restApi = Uri.parse(
        'https://flutter-shop-app-853fb-default-rtdb.firebaseio.com/product.json');

    try {
      http.Response response = await http.post(restApi,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'isFavorite': false,
          }));

      Product newProd = Product(
        //id: DateTime.now().toString(),
        id: json.decode(response.body)['name'],
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
        isFavorite: false,
      );

      _items.add(newProd);
      notifyListeners();
    } catch (error) {
      //TODO: is it necesarry throw this error
      throw error;
    }

    // Product existinProduct;
    // if (update) {
    //   existinProduct = findById(product.id);
    // }

    // final restApi = Uri.parse(
    //     'https://flutter-shop-app-853fb-default-rtdb.firebaseio.com/product.jso');
    // return http
    //     .post(restApi,
    //         body: json.encode({
    //           'title': product.title,
    //           'price': product.price,
    //           'description': product.description,
    //           'imageUrl': product.imageUrl,
    //           'isFavorite': update ? existinProduct.isFavorite : false,
    //         }))
    //     .then((value) {
    //   Product newProd = Product(
    //     id: update ? existinProduct.id : json.decode(value.body)['name'],
    //     title: product.title,
    //     price: product.price,
    //     description: product.description,
    //     imageUrl: product.imageUrl,
    //     isFavorite: update ? existinProduct.isFavorite : false,
    //   );

    //   if (update) {
    //     final index = _items.indexOf(existinProduct);
    //     _items.remove(existinProduct);
    //     _items.insert(index, newProd);
    //   } else {
    //     _items.add(newProd);
    //   }
    //   notifyListeners();
    // });
  }

  Future<void> fetchAndSetProducts() async {
    List<Product> products = [];

    final restApi = Uri.parse(
      'https://flutter-shop-app-853fb-default-rtdb.firebaseio.com/product.json',
    );
    try {
      final response = await http.get(restApi);
      final prod = json.decode(response.body) as Map<String, dynamic>;
      prod.forEach((prodId, prodData) {
        products.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
          ),
        );
      });
      _items = products;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(Product product) async {
    Product existinProduct = findById(product.id);
    final restApi = Uri.parse(
        'https://flutter-shop-app-853fb-default-rtdb.firebaseio.com/product/${existinProduct.id}.json');

    await http.patch(restApi,
        body: json.encode({
          'title': product.id,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
        }));

    Product newProd = Product(
      id: existinProduct.id,
      title: product.title,
      price: product.price,
      description: product.description,
      imageUrl: product.imageUrl,
      isFavorite: existinProduct.isFavorite,
    );
    final index = _items.indexOf(existinProduct);
    _items.remove(existinProduct);
    _items.insert(index, newProd);

    notifyListeners();
  }

  Future<void> deleteProduct(Product product) async {
    final restApi = Uri.parse(
        'https://flutter-shop-app-853fb-default-rtdb.firebaseio.com/product/${product.id}.json');

    final index = _items.indexOf(product);
    _items.remove(product);
    notifyListeners();
    final response = await http.delete(restApi);
    print('The response code: ${response.statusCode}');

    if (response.statusCode >= 400) {
      print('The response code: ${response.statusCode}');
      _items.insert(
        index,
        product,
      );
      notifyListeners();
      throw HttpException('Could not delete');
    }
  }
}

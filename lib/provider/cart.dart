import 'package:flutter/foundation.dart';
import 'package:shop_app/provider/product.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String imgUrl;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity,
    @required this.imgUrl,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  String getProdId(CartItem cart) {
    String prod;
    _items.forEach((key, value) {
      if (value == cart) {
        prod = key;
      }
    });
    return prod;
  }

  CartItem singleCart(String productId) {
    if (_items.containsKey(productId)) {
      return _items[productId];
    }
    return null;
  }

  void increaseQuantity(Product prod) {
    CartItem cart;
    _items.forEach((key, value) {
      if (key == prod.id) {
        cart = value;
      }
    });

    if (cart == null) {
      addItems(prod);
    } else {
      _items.forEach((key, value) {
        if (key == prod.id) {
          _items.update(
              key,
              (existingItem) => CartItem(
                    id: existingItem.id,
                    title: existingItem.title,
                    price: existingItem.price,
                    imgUrl: existingItem.imgUrl,
                    quantity: existingItem.quantity + 1,
                  ));
        }
      });
    }
    notifyListeners();
  }

  void decreseQuantity(CartItem cart) {
    if (cart.quantity > 0) {
      _items.forEach((key, value) {
        if (value == cart) {
          _items.update(
              key,
              (existingItem) => CartItem(
                    id: existingItem.id,
                    title: existingItem.title,
                    price: existingItem.price,
                    imgUrl: existingItem.imgUrl,
                    quantity: existingItem.quantity - 1,
                  ));
        }
      });
    }
    notifyListeners();
  }

  double get totalPrice {
    double totalCost = 0;

    _items.forEach((key, value) {
      totalCost += value.price * value.quantity;
    });
    return totalCost;
  }

  int get itemCount {
    return _items.length;
  }

  void addItems(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
          product.id,
          (existingItem) => CartItem(
                id: existingItem.id,
                title: existingItem.title,
                price: existingItem.price,
                imgUrl: existingItem.imgUrl,
                quantity: existingItem.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
          product.id,
          () => CartItem(
              id: DateTime.now().toString(),
              title: product.title,
              price: product.price,
              imgUrl: product.imageUrl,
              quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(CartItem cart) {
    _items.removeWhere((key, value) => value.id == cart.id);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String prodId) {
    final cart = singleCart(prodId);

    if (cart.quantity > 1) {
      decreseQuantity(cart);
    } else {
      removeItem(cart);
    }
    notifyListeners();
  }
}

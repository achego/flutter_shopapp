import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/provider/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> cartItems;
  final DateTime date;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.cartItems,
    @required this.date,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartItems, double amount) async {
    final restApi = Uri.parse(
        'https://flutter-shop-app-853fb-default-rtdb.firebaseio.com/orders.json');
    final time = DateTime.now();
    try {
      final response = await http.post(restApi,
          body: json.encode({
            'amount': amount,
            'date': time.toIso8601String(),
            'products': cartItems
                .map((cartItem) => {
                      'id': cartItem.id,
                      'title': cartItem.title,
                      'price': cartItem.price,
                      'quantity': cartItem.quantity,
                      'imgUrl': cartItem.imgUrl,
                    })
                .toList(),
          }));

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: amount,
          cartItems: cartItems,
          date: time,
        ),
      );
    } catch (e) {
      print(e);
      print('Could not add items to cart');
    }
  }

  Future<void> fetchAndSetProducts() async {
    List<OrderItem> orderItems = [];

    final restApi = Uri.parse(
      'https://flutter-shop-app-853fb-default-rtdb.firebaseio.com/orders.json',
    );
    List<OrderItem> newOrders = [];
    try {
      final response = await http.get(restApi);
      print(response.body);
      final loadedOrders = json.decode(response.body) as Map<String, dynamic>;

      loadedOrders.forEach((orderId, orderData) {
        orderItems.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            date: DateTime.parse(orderData['dateTime']),
            cartItems: (orderData['products'] as List<dynamic>).map(
              (cart) => CartItem(
                id: cart['id'], 
                title: cart['title'],
                price: cart['price'],
                quantity: cart['quantity'],
                imgUrl: cart['imgUrl'],
              ),
            ),
          ),
        );
      });
    } catch (error) {}
  }
}

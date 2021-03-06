import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/orders.dart';
import 'package:shop_app/widgets/my_drawer.dart';
import 'package:shop_app/widgets/order_Item.dart';

class OrdersScreen extends StatelessWidget {
  static String routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: MyDrawer(),
        body: ListView.builder(
          itemCount: orderData.orders.length,
          itemBuilder: (ctx, i) => OrderzItem(
            order: orderData.orders[i],
          ),
        ));
  }
}

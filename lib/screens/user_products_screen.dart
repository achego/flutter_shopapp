import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/provider/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/my_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static String routeName = '/user-products';
  int me;

  Future<void> refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.pushNamed(context, EditProductSreen.routeName),
          )
        ],
      ),
      drawer: MyDrawer(),
      body: RefreshIndicator(
        onRefresh: () => refreshProducts(context),
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     StreamBuilder<List<int>>(
        //         stream: Stream.value([28, 3, 4, 4, 6]),
        //         builder: (ctx, snapShot) {
        //           print('this is the sanpshot ');
        //           print(snapShot.connectionState);
        //           if (snapShot.connectionState == ConnectionState.done) {
        //             print('Connection done');
        //             print('List Lenght ${snapShot.data.length}');
        //             me = snapShot.data.length;
        //           }
        //           print('me $me');
        //           return Text('Hi there $me');
        //         }),
        //     Expanded(
        child: Container(
          margin: EdgeInsets.only(top: 15),
          child: ListView.builder(
              itemBuilder: (ctx, i) => UserProductItem(
                    product: products.items[i],
                  ),
              itemCount: products.items.length),
        ),
      ),
      //     ],
      //   ),
      // ),
    );
  }
}

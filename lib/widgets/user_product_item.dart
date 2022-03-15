import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  const UserProductItem({this.product});
  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return Card(
      margin: EdgeInsets.all(4),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(product.imageUrl),
            ),
            title: Text(product.title),
            trailing: Container(
              width: 96,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        EditProductSreen.routeName,
                        arguments: product,
                      );
                    },
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).errorColor,
                      ),
                      onPressed: () async {
                        try {
                          await Provider.of<Products>(context, listen: false)
                              .deleteProduct(product);
                        } catch (e) {
                          scaffoldMessenger.showSnackBar(SnackBar(
                              content: Text(
                            'Failed to delete',
                            textAlign: TextAlign.center,
                          )));
                        }
                      }),
                ],
              ),
            )),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';

import 'package:shop_app/provider/products.dart';

class CartzItem extends StatelessWidget {
  final CartItem cart;

  const CartzItem(this.cart);

  @override
  Widget build(BuildContext context) {
    final cart2 = Provider.of<Cart>(context, listen: false);

    return Dismissible(
      key: Key(cart.id),
      background: Container(
        color: Colors.black54,
        child: Icon(
          Icons.delete,
          color: Colors.red,
        ),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure ?'),
            content: Text('Do you want to remove item from cart!!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('YES'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('NO'),
              )
            ],
          ),
        );
      },
      onDismissed: (_) => cart2.removeItem(cart),
      child: Card(
        elevation: 10,
        margin: EdgeInsets.all(10),
        child: Row(
          children: [
            ContainerWithImageSrc(cart: cart),
            SizedBox(width: 15),
            ColumnWithTextAndSub(cart: cart),
            SizedBox(width: 17),
            CustomQuantityIncrDecr(
              cart: cart,
              cart2: cart2,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomQuantityIncrDecr extends StatelessWidget {
  final CartItem cart;
  final Cart cart2;

  const CustomQuantityIncrDecr({
    this.cart,
    this.cart2,
  });

  @override
  Widget build(BuildContext context) {
    final prodId = cart2.getProdId(cart);
    final product =
        Provider.of<Products>(context, listen: false).findById(prodId);
    return Card(
      elevation: 10,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            GestureDetector(
                onTap: () {
                  cart2.increaseQuantity(product);
                },
                child: Icon(Icons.add, size: 15)),
            Text('${cart.quantity}'),
            GestureDetector(
              onTap: () => cart2.decreseQuantity(cart),
              child: Icon(Icons.remove, size: 15),
            ),
          ],
        ),
      ),
    );
  }
}

class ColumnWithTextAndSub extends StatelessWidget {
  final CartItem cart;
  const ColumnWithTextAndSub({this.cart});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${cart.title}',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text('sub: ${cart.title}', style: TextStyle(fontSize: 12)),
        SizedBox(
          height: 10,
        ),
        CustomContainer(price: cart.price),
        SizedBox(height: 12),
        Text(
          'Total: \$${(cart.price * cart.quantity)}',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class ContainerWithImageSrc extends StatelessWidget {
  final CartItem cart;
  const ContainerWithImageSrc({this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 80,
      color: Colors.black87,
      child: Image.network(
        cart.imgUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final double price;
  const CustomContainer({@required this.price});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          color: Theme.of(context).accentColor,
          height: 30,
          width: 30,
          child: Padding(
            padding: EdgeInsets.all(2),
            child: FittedBox(
              child: Text(
                '50% \nOFF%',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.headline6.color),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Original Price: \$${(price * 2)}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                fontSize: 12,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              'New Price: \$$price',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        )
      ],
    );
  }
}

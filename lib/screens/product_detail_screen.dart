import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/product.dart';

import 'package:shop_app/provider/products.dart';
import 'package:shop_app/screens/cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  void toogle(Product prod) {
    setState(() {
      prod.toogleFavoriteStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    String id = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(
      context,
      listen: false,
    ).findById(id);
    var singleCart = cart.singleCart(product.id);

    final sizeData = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(220, 220, 220, 1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () => toogle(product),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).accentColor,
      body: Column(
        children: [
          Container(
            height: sizeData.height * 0.58,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Color.fromRGBO(220, 220, 220, 1),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50))),
            child: Column(
              children: [
                Container(
                  height: sizeData.height * 0.3,
                  width: sizeData.width * 0.7,
                  color: Colors.grey,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      customContainerWithText('S'),
                      customContainerWithText('M'),
                      customContainerWithText('L')
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      customContainerWithIncrDcr(
                          product.title,
                          Theme.of(context).accentColor,
                          null,
                          Icons.star,
                          '3.9',
                          null,
                          false),
                      SizedBox(height: 10),
                      Text('Belema\'s Clothing'),
                      SizedBox(height: 10),
                      customContainerWithIncrDcr(
                          '\$${product.price}',
                          Colors.white,
                          () => cart.increaseQuantity(product),
                          Icons.add,
                          singleCart == null
                              ? '0'
                              : singleCart.quantity.toString(),
                          () => cart.decreseQuantity(singleCart),
                          true)
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 5),
          Container(
            margin: EdgeInsets.all(13),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Product Description',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        child: Icon(Icons.more_horiz),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  //height: sizeData.height * 0.15,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),
                        width: 70,
                        height: 60,
                        color: Colors.grey,
                        child: Image.network('src'),
                      ),
                      SizedBox(width: 6),
                      Container(
                        width: sizeData.width - 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Belema\'s Plazza',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              product.description,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2),
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Icon(Icons.location_on, size: 15),
                                ),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    children: [
                                      Icon(Icons.star_half, size: 15),
                                      Text('3.9',
                                          style: TextStyle(fontSize: 11)),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () => Navigator.pushReplacementNamed(
                                      context, CartScreen.routeName),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).accentColor,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      padding: EdgeInsets.all(3),
                                      child: Icon(Icons.arrow_forward)),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container customContainerWithIncrDcr(
      String text,
      Color color,
      Function onTap1,
      IconData icon1,
      String value,
      Function onTap2,
      bool trailing) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            width: 70,
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(onTap: onTap1, child: Icon(icon1, size: 15)),
                Text(value),
                trailing
                    ? GestureDetector(
                        onTap: onTap2,
                        child: Icon(Icons.remove, size: 15),
                      )
                    : Text(' '),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container customContainerWithText(String text) {
    return Container(
      height: 43,
      width: 43,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(text, style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

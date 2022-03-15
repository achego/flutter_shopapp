import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/screens/cart_screen.dart';

import 'package:shop_app/widgets/badge2.dart';
import 'package:shop_app/widgets/my_drawer.dart';

import 'package:shop_app/widgets/product_grid.dart';

enum FavoriteOption { Favourite, All }

bool isFavorite = false;
bool _isInit = false;
bool _isLoading = false;

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  @override
  void initState() {
    _isInit = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          Consumer<Cart>(
            builder: (ctx, cart, ch) => Badge2(
              child: ch,
              value: cart.itemCount,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () => Navigator.pushNamed(
                context,
                CartScreen.routeName,
              ),
            ),
          ),
          PopupMenuButton(
              onSelected: (value) {
                setState(() {
                  if (value == FavoriteOption.Favourite) {
                    isFavorite = true;
                  } else if (value == FavoriteOption.All) {
                    isFavorite = false;
                  }
                });
              },
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Only Favorites'),
                      value: FavoriteOption.Favourite,
                    ),
                    PopupMenuItem(
                      child: Text('All'),
                      value: FavoriteOption.All,
                    ),
                  ])
        ],
      ),
      drawer: MyDrawer(),
      body: _isLoading
          ? Center(
              child: ProductGrid(isFavorite),
            )
          : ProductGrid(isFavorite),
    );
  }
}

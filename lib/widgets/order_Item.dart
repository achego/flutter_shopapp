import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app/provider/orders.dart';
import 'package:intl/intl.dart';

class OrderzItem extends StatefulWidget {
  final OrderItem order;

  const OrderzItem({this.order});

  @override
  _OrderzItemState createState() => _OrderzItemState();
}

class _OrderzItemState extends State<OrderzItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    print((widget.order.cartItems.length * (50 + 10.0)));
    return Card(
      elevation: 20,
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Card(
            elevation: 10,
            color: Theme.of(context).accentColor,
            child: ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle:
                  Text(DateFormat('dd/MM/yy hh:mm').format(widget.order.date)),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
          ),
          if (_expanded)
            Container(
              margin: EdgeInsets.only(right: 10, left: 10, top: 6),
              height: min(100, (widget.order.cartItems.length * (20 + 12.0))),
              child: ListView(
                children: widget.order.cartItems
                    .map((item) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: Text(item.title,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Text('${item.quantity}x'),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  child: Text(
                                    '\$${item.price * item.quantity}',
                                    textAlign: TextAlign.end,
                                  ))
                            ],
                          ),
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}

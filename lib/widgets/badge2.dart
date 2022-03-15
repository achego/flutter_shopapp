import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Badge2 extends StatelessWidget {
  final Widget child;
  final int value;
  final Color color;

  const Badge2({
    Key key,
    this.value = 5,
    this.color,
    this.child,
  }) : super(key: key);

  String get mainValue {
    if (value > 20) {
      return '20+';
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //decoration: BoxDecoration(border: Border.all(width: 1)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          Positioned(
            top: 8,
            left: 0,
            child: Container(
              height: 16,
              constraints: BoxConstraints(minWidth: 16),
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: color != null ? color : Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                mainValue,
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}

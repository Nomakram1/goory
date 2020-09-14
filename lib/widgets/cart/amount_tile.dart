import 'package:flutter/material.dart';

class AmountTile extends StatefulWidget {
  AmountTile({
    Key key,
    this.label,
    this.labelTextStyle,
    this.amount,
    this.amountTextStyle,
  }) : super(key: key);

  final String label;
  final TextStyle labelTextStyle;
  final String amount;
  final TextStyle amountTextStyle;

  @override
  _AmountTileState createState() => _AmountTileState();
}

class _AmountTileState extends State<AmountTile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          widget.label,
          style: widget.labelTextStyle,
        ),
        Text(
          widget.amount,
          style: widget.amountTextStyle,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firestore_example/widget/value_card.dart';

class CardToSpend extends StatefulWidget {
  final double startBudget;
  final double spent;

  const CardToSpend({Key key, this.startBudget, this.spent}) : super(key: key);

  @override
  _CardToSpendState createState() => _CardToSpendState();
}

class _CardToSpendState extends State<CardToSpend> {
  Widget _balanceWidget(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          ValueCard(
            value: widget.startBudget - widget.spent,
            label: "Remaining Balance",
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.startBudget != null && widget.spent != null) {
      return _balanceWidget(context);
    } else {
      return Text('loading');
    }
  }
}

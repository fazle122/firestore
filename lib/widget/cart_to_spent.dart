import 'package:flutter/material.dart';
import 'package:firestore_example/widget/value_card.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';


class CardToSpend extends StatefulWidget {
  final double startBudget;
  final double spent;
  final double left;

  const CardToSpend({Key key, this.startBudget, this.spent,this.left}) : super(key: key);

  @override
  _CardToSpendState createState() => _CardToSpendState();
}

class _CardToSpendState extends State<CardToSpend> {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

    Color dialColor;
    Color labelColor;
    double expense;
    final _chartSize = const Size(150.0, 150.0);

    @override
    void initState(){

      print('st : ' + widget.startBudget.toString());
      print('s : ' + widget.spent.toString());
      print('l : ' + widget.left.toString());

      super.initState();
    }
  

    List<CircularStackEntry> _generateChartData() {
    List<CircularStackEntry> data;
    dialColor = Colors.blueAccent;
    labelColor = Colors.blueAccent;

      expense =
          (widget.left * 100) / widget.startBudget;

    if (expense < 20) {
      setState(() {
        dialColor = Colors.red;
      });
    }

    data = [
      new CircularStackEntry([new CircularSegmentEntry(expense, dialColor)])
    ];

    if (_chartKey.currentState != null) {
      _chartKey.currentState.updateData(data);
    }
    return data;
  }


  Widget _balanceWidget(BuildContext context) {
    TextStyle _labelStyle = Theme.of(context)
        .textTheme
        .title
        .merge(new TextStyle(color: labelColor));
    return Center(
      child: Column(
        children: <Widget>[
          AnimatedCircularChart(
                      key: _chartKey,
                      size: _chartSize,
                      initialChartData: _generateChartData(),
                      chartType: CircularChartType.Radial,
                      edgeStyle: SegmentEdgeStyle.round,
                      percentageValues: true,
                      holeLabel: expense.toStringAsPrecision(4) + '%',
                      labelStyle: _labelStyle,
                    ),
          ValueCard(
            value: widget.left,
            label: "Remaining Balance",
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
      return _balanceWidget(context);
    
  }
}

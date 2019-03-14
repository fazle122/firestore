import 'package:flutter/material.dart';

class ValueCard extends StatelessWidget{
  final double value;
  final String label;

  const ValueCard({Key key,this.value,this.label}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Card(
      
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(value.toString(),
              style: Theme.of(context).textTheme.display1,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(label),
          ),
        ],
      ),
    );
  }

}
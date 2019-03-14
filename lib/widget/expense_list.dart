import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firestore_example/services/crud.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

CrudMedthods crudObj = new CrudMedthods();
Stream s;
Iterable<DocumentSnapshot> doc;

class ExpenseList extends StatelessWidget {
  final expence;
  final month;
  final year;
  const ExpenseList({Key key, this.expence, this.month,this.year}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return StreamBuilder<QuerySnapshot>(
        stream: expence,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            doc = snapshot.data.documents.where((data) =>
                formatDate(data['date'], [MM]) == month &&
                formatDate(data['date'], [yyyy]) == year);
            return ListView.builder(
              itemCount: doc.length,
              padding: EdgeInsets.all(5.0),
              itemBuilder: (context, i) {
                return Dismissible(
                  onDismissed: (_) =>
                      crudObj.deleteData(doc.elementAt(i).documentID),
                  key: Key(doc.elementAt(i).documentID),
                  child: Card(
                    
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: ListTile(
                      title: Text(
                          doc.elementAt(i).data['expenseValue'].toString()),
                      subtitle: Text(doc.elementAt(i).data['expenseTitle']),
                      trailing: Text(
                        DateFormat('EEE, d MMMM',
                                Localizations.localeOf(context).toString())
                            .format(doc.elementAt(i).data['date']),
                      ),

                    ),
                  ),
                );
              },
            );
          } else {
            return Text('Loading, ..');
          }
        },
      );
    // } else {
    //   return Text('Loading, Please wait..');
    // }
  }
}

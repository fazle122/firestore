import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firestore_example/services/crud.dart';
import 'package:firestore_example/widget/expense_list.dart';
import 'package:firestore_example/widget/cart_to_spent.dart';
import 'package:firestore_example/widget/value_card.dart';
import 'package:firestore_example/widget/make_expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firestore_example/login.dart';
import 'package:firestore_example/services/api.dart';

class DashboardPage extends StatefulWidget {
  final user;
  const DashboardPage({Key key, this.user}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  Stream<QuerySnapshot> expence;
  String month;
  String year;
  double startBudget = 0;
  double spent = 0;
  var startBudgetId;
  CrudMedthods crudObj = new CrudMedthods();
  FBApi fbApi = FBApi(user);

  double range;

  @override
  void initState() {
    month = formatDate(DateTime.now(), [MM]);
    year = formatDate(DateTime.now(), [yyyy]);
    print(widget.user.uid);

    _expenseData();
    _startBudget();
    _spentMoney();

    crudObj
        .getMonthlyData(this.month, widget.user.uid)
        .then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        setState(() {
          startBudget = docs.documents[0].data['monthlyBudget'];
          print('in setState : ' + startBudget.toString());
        });
        print('out setState : ' + startBudget.toString());
      }
    });

    print('in initState : ' + startBudget.toString());

    setState(() {
     range =startBudget -spent;
      
    });

    super.initState();
  }

  double get left => (startBudget - spent) ?? 0.0;

  _expenseData() {
    crudObj.getExpanseData(widget.user.uid).then((results) {
      setState(() {
        expence = results;
      });
    });
  }

  _startBudget() {
    crudObj
        .getMonthlyData(this.month, widget.user.uid)
        .then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        setState(() {
          startBudget = docs.documents[0].data['monthlyBudget'];
          startBudgetId = docs.documents[0].documentID;
          // print(startBudget.toString());
        });
      } else {
        startBudget = 0.0;
      }
    });
  }

  _spentMoney() {
    Firestore.instance
        .collection("testcrud")
        .where('uid', isEqualTo: widget.user.uid)
        .snapshots()
        .listen((value) {
      setState(() {
        spent = value.documents
            .where((data) =>
                formatDate(data['date'], [MM]) == this.month &&
                formatDate(data['date'], [yyyy]) ==
                    formatDate(DateTime.now(), [yyyy]))
            .fold(0, (sum, d) => sum + d.data['expenseValue']);
        // print(spent.toString());
      });
    });
  }

  Future<Null> _signOut() async {
    fbApi.signOut();
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Firestore.instance
              //     .collection('testcrud')
              //     .where('uid', isEqualTo: widget.user.uid)
              //     .snapshots()
              //     .listen((doc) {
              //   if (doc.documents.isNotEmpty) {
              //     doc.documents.forEach((value) {
              //       suggestions.add(value.data['expenseTitle'].toString());
              //       suggestions.forEach((data) => print(data.toString()));
              //     });
              //   } else {
              //     print('suggestion item not found');
              //   }
              // });
            },
          ),
          PopupMenuButton<String>(
            onSelected: (val) {
              switch (val) {
                case 'SIGN_OUT':
                  _signOut();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  PopupMenuItem<String>(
                    value: 'SIGN_OUT',
                    child: Text('Sign Out'),
                  ),
                ],
          ),
        ],
      ),
      body: Builder(
        
          builder: (context) => Padding(
                padding: EdgeInsets.all(0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[

                          CardToSpend(
                            startBudget: startBudget,
                            spent: spent,
                            left:left,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: GestureDetector(
                                  child: ValueCard(
                                    value: startBudget,
                                    label: "starting budget",
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ValueCard(
                                  value: spent,
                                  label: "spent",
                                ),
                              )
                            ],
                          ),
                          AddExpanse(user: widget.user),
                          Expanded(
                            child: ExpenseList(
                              expence: expence,
                              month: month,
                              year: year,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
    );
  }
}

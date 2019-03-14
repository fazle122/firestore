import 'package:flutter/material.dart';
import 'package:firestore_example/services/crud.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddExpanse extends StatelessWidget {
  final user;
  AddExpanse({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: SizedBox(
                height: 40.0,
                child: RaisedButton(
                  padding: EdgeInsets.all(0.0),
                  child: Text('Make new Expense'),
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return MyDialogContent(user: user);
                        });
                  },
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyDialogContent extends StatefulWidget {
  final user;
  const MyDialogContent({Key key, this.user}) : super(key: key);

  @override
  _MyDialogContentState createState() => new _MyDialogContentState();
}

class _MyDialogContentState extends State<MyDialogContent> {
  String expenseTitle;
  String expenseCategory;
  double expenseValue;
  double totalExpense;
  DateTime date = DateTime.now();
  List<String> titleList;
  List<String> categoryList;
  final TextEditingController _controller = new TextEditingController();

  CrudMedthods crudObj = new CrudMedthods();
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  @override
  void initState() {
    super.initState();
    titleList = [];
    categoryList = [];

    List<String> cList = [];
    List<String> tList = [];

    Firestore.instance
        .collection('testcrud')
        .where('uid', isEqualTo: widget.user.uid)
        .snapshots()
        .listen((doc) {
      if (doc.documents.isNotEmpty) {
        doc.documents.forEach((value) {
          if (value.data['expenseCategory'] != null) {
            cList.add(value.data['expenseCategory']);
          }
        });
      }
      categoryList.addAll(cList.toSet().toList());
        categoryList.forEach((data) => print('Category item : ' + data));
    });

    Firestore.instance
        .collection('testcrud')
        .where('uid', isEqualTo: widget.user.uid)
        .snapshots()
        .listen((doc) {
      if (doc.documents.isNotEmpty) {
        doc.documents.forEach((value) {
          if (value.data['expenseTitle'] != null) {
            tList.add(value.data['expenseTitle']);
          }
        });
        titleList.addAll(tList.toSet().toList());
        titleList.forEach((data) => print('list item ' + data));
      }
    });
  }

  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2018),
      lastDate: DateTime(2021),
    );
    if (picked != null && picked != date) {
      setState(() {
        print(picked);
        date = picked;
        print(date);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Expense', style: TextStyle(fontSize: 15.0)),
      content: Container(
        height: 185.0,
        // width: 150.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Expense Category'),
                    keyboardType: TextInputType.text,
                    onChanged: (value){
                      this.expenseCategory = value;
                    },
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.arrow_drop_down),
                  onSelected: (String value) {
                    this.expenseCategory = value;
                      _controller.text = value;

                  },
                  itemBuilder: (BuildContext context) {
                    return categoryList
                        .map<PopupMenuItem<String>>((String value) {
                      return new PopupMenuItem(
                          child: new Text(value), value: value);
                    }).toList();
                  },
                ),
              ],
            ),

            SimpleAutoCompleteTextField(
              key: key,
              suggestions: titleList,
              decoration:
                  InputDecoration(hintText: 'Expense title'),
                  
              clearOnSubmit: false,
              textChanged: (text) => this.expenseTitle = text,
              textSubmitted: (text) => setState(() {
                    this.expenseTitle = text;
                  }),
            ),
            // SizedBox(height: 5.0),
            TextField(
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(
                hintText: 'Expense value',
              ),
              onChanged: (value) {
                this.expenseValue = double.parse(value);
              },
            ),
            // SizedBox(height: 5.0),
            Row(
              children: <Widget>[
                Container(
                  width: 140.0,
                  child: Text(
                    DateFormat('EEE, d MMMM',
                            Localizations.localeOf(context).toString())
                        .format(date),
                  ),
                ),
                RaisedButton(
                  child: Icon(Icons.date_range),
                  onPressed: () {
                    selectDate(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        FlatButton(
          child: Text('Add'),
          textColor: Colors.blue,
          onPressed: () {
            Navigator.of(context).pop();
            crudObj.addData({
              'searchKey': expenseTitle.substring(0, 1).toUpperCase(),
              'expenseCategory': expenseCategory ?? 'Others',
              'expenseTitle': expenseTitle.substring(0, 1).toUpperCase() +
                      expenseTitle.substring(1) ??
                  'test',
              'expenseValue': expenseValue ?? 0.0,
              'date': date,
              'uid': widget.user.uid,
            }).catchError((e) {
              print(e);
            });
          },
        )
      ],
    );
  }
}

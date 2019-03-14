import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_example/services/api.dart';


Firestore  db = Firestore.instance;

CollectionReference expenseRef = db.collection('testcrud');

class CrudMedthods {

  Future<bool> login() async {
    final api = await FBApi.signInWithGoogle();
    if (api != null) {
      return true;
    } else {
      return false;
    }
  }


   Future<void> addData(expenseData) async {
    Firestore.instance.collection('testcrud').add(expenseData).catchError((e) {
      print(e);
    });

  }


  Future<QuerySnapshot> getMonthlyData(String mName,String uid) async{
    return  await Firestore.instance
        .collection('monthdata')
        .where('monthName', isEqualTo: mName)
        .where('uid',isEqualTo:uid)
        .getDocuments();
  }

  

  Future getExpanseData(String uid) async {
    var data = Firestore.instance
                  .collection('testcrud')
                  .where('uid',isEqualTo: uid)
                  .snapshots();
    return  data;
  }


  deleteData(docId) {
    Firestore.instance
        .collection('testcrud')
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

}

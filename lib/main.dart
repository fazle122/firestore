import 'package:flutter/material.dart';

import 'package:firestore_example/dashboard.dart';
import 'package:firestore_example/login.dart';
import 'package:firestore_example/services/api.dart';
import 'package:firestore_example/services/crud.dart';

CrudMedthods crd = CrudMedthods();
var user;
    


void main() async {
  Widget _defaultHome = LoginPage();
  final api = await FBApi.signInWithGoogle();
  user = api.firebaseUser;

  bool result = await crd.login();
  if (result) {
    _defaultHome = DashboardPage(user:user);
  }

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Expense Management',
    home: _defaultHome,
    // home: DashboardPage(user:user),
    routes: <String, WidgetBuilder>{
      "home-page": (context) => DashboardPage(user:user),
      "login-page": (context) => LoginPage(),
    },
  ));
}
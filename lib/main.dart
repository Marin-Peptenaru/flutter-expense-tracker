import 'package:flutter/material.dart';

import 'domain/expense.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Expense Tracker Application'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String _title;
  final List<Expense> expenses = [
    Expense(id: 1, title: 'New game', amount: 20.0, date: DateTime.now()),
    Expense(id: 2, title: 'Milk', amount: 6.5, date: DateTime.now()),
    Expense(id: 3, title: 'Pizza', amount: 15.0, date: DateTime.now()),
  ];

  MyHomePage({@required String title}) : _title = title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                width: double.infinity,
                child: Card(
                    color: Colors.blue, child: Text('Chart'), elevation: 5)),
            Column(
              children: [
                ...expenses
                    .map((expense) => Card(child: Text(expense.title)))
                    .toList(),
              ],
            )
          ],
        ));
  }
}

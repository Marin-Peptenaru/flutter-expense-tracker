import 'dart:math';

import 'package:expense_tracker/services/expense_manager.dart';
import 'package:expense_tracker/utils/expense_type_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/route_names.dart';
import './expense_chart.dart';
import './expense_list.dart';
import './expense_form.dart';
import './expense_bar.dart';

class HomePageScreen extends StatelessWidget with PageRouter{
  final String _title;

  HomePageScreen({required String title}) : _title = title;

  //Note to self:
  //Make sure that if show forms or text fields in modal bottom sheets like here
  //they are put in a STATEFUL WIDGET, even if you are not having any kind of
  //actual state in there. It is simply needed because flutter treats stateless
  // widgets differently when rebuilding and you will lose the text input from
  // the text fields. The reason this does not happen with stateful widgets is
  // because you keep the fields in the State object, which internally is stored
  // separately from the StatefulWidget object

  void _showAddExpenseForm(BuildContext context) {
    var expenseManager = Provider.of<ExpenseManager>(context, listen: false);
    showModalBottomSheet(
        context: context,
        builder: (buildContext) {
          return GestureDetector(
            onTap: () {},
            child: ExpenseForm(expenseManager),
            // IMPORTANT
            // this and the onTap handler are necessary to make sure that tap events are not
            // handled by the parent ModalBottomSheet and that the sheet does not close when tapping on it
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      title: Text(_title),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _showAddExpenseForm(context),
        )
      ],
    );

    final _bottomBar = BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.assessment_outlined),
              onPressed: () => Navigator.of(context).pushNamed(statistics),
            ),
          ],
        ));

    final _drawer = Drawer(
      child: ListView(
        children: [
          ListTile(leading: Icon(Icons.settings), title: Text('Settings'), onTap: (){
            Navigator.of(context).pushNamed(settings);
          },),
        ],
      )
    );

    var mediaQuery = MediaQuery.of(context);
    var availableContentHeight = (mediaQuery.size.height -
        mediaQuery.padding.top -
        _appBar.preferredSize.height);



    return Scaffold(
      bottomNavigationBar: _bottomBar,
      appBar: _appBar,
      drawer: _drawer,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              height: availableContentHeight * 0.3, child: ExpenseChart()),
          Container(
              height: availableContentHeight * 0.1,
              child: Consumer<ExpenseManager>(
                  builder: (context, expenseManager, _) => ExpenseBar(
                      value: expenseManager.amountSpent,
                      capacity: expenseManager.budgetCap,
                      color:
                          expenseManager.amountSpent > expenseManager.budgetCap
                              ? Colors.red
                              : Colors.greenAccent))),
          Container(
              height: availableContentHeight * 0.5,
              child: Consumer<ExpenseManager>(
                builder: (context, expenseManager, _) =>
                    ExpenseList(expenseManager.allExpenses),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        backgroundColor: Colors.greenAccent,
        child: Icon(Icons.add),
        onPressed: () => _showAddExpenseForm(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

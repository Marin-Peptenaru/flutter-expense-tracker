import 'package:expense_tracker/services/expense_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './expense_chart.dart';
import './expense_list.dart';
import './expense_form.dart';

class MyHomePage extends StatelessWidget {
  final String _title;

  MyHomePage({required String title}) : _title = title;

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
            onTap: () {}, child: ExpenseForm(expenseManager),
            // IMPORTANT
            // this and the onTap handler are necessary to make sure that tap events are not
            // handled by the parent ModalBottomSheet and that the sheet does not close when tapping on it
            behavior: HitTestBehavior.opaque,);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddExpenseForm(context),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExpenseChart(),
          ExpenseList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        backgroundColor: Colors.greenAccent,
        child: Icon(Icons.add),
        onPressed: () => _showAddExpenseForm(context),
      ),
    );
  }
}

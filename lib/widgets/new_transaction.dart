// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class NewTransaction extends StatelessWidget {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final Function addNewTransaction;

  NewTransaction(this.addNewTransaction);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              //onChanged: (val) {
              //  titleInput=val;
              //},
              controller: titleController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              //onChanged: (val) {
              //  amountInput=val;
              //},
              controller: amountController,
            ),
            TextButton(
              onPressed: () {
                addNewTransaction(
                    titleController.text, double.parse(amountController.text));
              },
              child: Text(
                'Add Transaction',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: TextButton.styleFrom(
                primary: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

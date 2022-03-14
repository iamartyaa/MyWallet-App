// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewTransaction;

  NewTransaction(this.addNewTransaction);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  late DateTime pickedDate;
  final amountController = TextEditingController();
  bool isLoading = false;

  void submitData() {
    setState(() {
      isLoading = true;
    });

    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredAmount <= 0 || enteredTitle.isEmpty) {
      return;
    }
    if (pickedDate == null) {
      return;
    }

    widget
        .addNewTransaction(
      enteredTitle,
      enteredAmount,
      pickedDate,
    )
        .catchError((error) {
      return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text('An error occured!'),
              content: Text(error.toString()),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Okay'))
              ],
            );
          }).then((_) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }).then((_) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      });
  }

  int d = 0;
  void _presentDatePicker() {
    showRoundedDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
      borderRadius: 16,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        d = 1;
        pickedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Card(
              elevation: 5,
              child: Container(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      //onChanged: (val) {
                      //  titleInput=val;
                      //},
                      controller: titleController,
                      onSubmitted: (val) => submitData(),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Amount'),
                      //onChanged: (val) {
                      //  amountInput=val;
                      //},
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (val) => submitData(),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              d == 0
                                  ? 'No Date Chosen'
                                  : 'Picked Date: ${DateFormat.yMMMd().format(pickedDate)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          OutlineButton(
                            textColor: Theme.of(context).primaryColor,
                            onPressed: _presentDatePicker,
                            child: Text(
                              'Chose Date',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'OpenSans'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => submitData(),
                      child: Text(
                        'Add Transaction',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mywallet/models/transaction.dart';
//

class TransactionList extends StatelessWidget {  
  final List<Transaction> _userTransactions;

  TransactionList(this._userTransactions);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
              children: _userTransactions.map((tx) {
                return Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.purple,
                        width: 2,
                      )),
                      child: Text(
                        //+ tx.amount.toString()
                        'Rs ${tx.amount}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          // DateFormat('dd-MM-yyyy EEEE').format(tx.date)
                          DateFormat.yMMMd().add_jm().format(tx.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ],
                );
              }).toList(),
            ),
    );
  }
}
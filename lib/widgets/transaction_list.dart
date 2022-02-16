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
      height: 500,
      child: _userTransactions.isEmpty
          ? Column(
              children: [
                SizedBox(
                  height: 35,
                ),
                Container(
                  height: 250,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'No Transactions yet!',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      )),
                      child: Text(
                        //+ tx.amount.toString()
                        'Rs ${_userTransactions[index].amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userTransactions[index].title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          // DateFormat('dd-MM-yyyy EEEE').format(tx.date)
                          DateFormat.yMMMd()
                              .add_jm()
                              .format(_userTransactions[index].date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ],
                );
              },
              itemCount: _userTransactions.length,
            ),
    );
  }
}

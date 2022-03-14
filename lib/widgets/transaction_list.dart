// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mywallet/models/transaction.dart';
//

class TransactionList extends StatefulWidget {
  final List<Transaction> _userTransactions;
  final Function deleteTransaction;
  final bool isLoading;
  final Function fetchTransations;
  TransactionList(this._userTransactions, this.deleteTransaction,
      this.isLoading, this.fetchTransations);

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  int c = 0;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      if (c == 0) {
        widget.fetchTransations();
      }
      setState(() {
        c = 1;
      });
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return widget.isLoading
        ? Center(child: CircularProgressIndicator())
        : LayoutBuilder(builder: ((context, constraints) {
            return Container(
              child: widget._userTransactions.isEmpty
                  ? Column(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          height: constraints.maxHeight * 0.5,
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
                        return Card(
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                          elevation: 5,
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              child: Padding(
                                padding: EdgeInsets.all(6),
                                child: FittedBox(
                                    child: Text(
                                        'Rs ${widget._userTransactions[index].amount}')),
                              ),
                            ),
                            title: Text(
                              widget._userTransactions[index].title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            subtitle: Text(DateFormat.yMMMd()
                                .format(widget._userTransactions[index].date)),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                widget.deleteTransaction(
                                    widget._userTransactions[index].id);
                              },
                              color: Theme.of(context).errorColor,
                            ),
                          ),
                        );
                      },
                      itemCount: widget._userTransactions.length,
                    ),
            );
          }));
  }
}
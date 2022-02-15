// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:mywallet/widgets/user_transactions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Wallet',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  //late String titleInput;
  //late String amountInput;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wallet'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              height: 50,
              child: Card(
                child: Text('Chart'),
                elevation: 15,
                color: Colors.blue,
              ),
            ),
            UserTransactions(),
          ],
        ),
      ),
    );
  }
}

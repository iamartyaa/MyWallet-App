// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:mywallet/widgets/chart.dart';
import 'package:mywallet/widgets/new_transaction.dart';
import 'package:mywallet/widgets/transaction_list.dart';
import 'package:mywallet/models/transaction.dart';

void main() {
  
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Wallet',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.amber,
        errorColor: Colors.red,
        fontFamily: 'OpenSans',
        textTheme: TextTheme(
          titleMedium: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w700,
            color: Colors.deepPurple,
          ),
        ),
        // appBarTheme: AppBarTheme(
        //   textTheme: ThemeData.light().textTheme.copyWith(
        //         headline6: TextStyle(
        //           fontFamily: 'OpenSans',
        //           fontSize: 18,
        //           fontWeight: FontWeight.w700,
        //         ),
        //       ),
        // ),
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //late String titleInput;
  final List<Transaction> _userTransactions = [
    
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx)  {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7),),);
    } ).toList();
  }


  void _addNewTransaction(String txtitle, double txamount,DateTime d) {
    final tx = Transaction(
      title: txtitle,
      amount: txamount,
      date: d,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(tx);
    });
  }

  void _deleteTransaction(String id){
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });

  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        return GestureDetector(
          child: NewTransaction(_addNewTransaction),
          onTap: () {},
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar=AppBar(
        title: Text(
          'My Wallet',
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _startAddNewTransaction(context),
            icon: Icon(Icons.add),
          ),
        ],
      );
    
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: (MediaQuery.of(context).size.height-appBar.preferredSize.height -MediaQuery.of(context).padding.top)*0.3,
              child: Chart(_recentTransactions)),
            Container(
              height: (MediaQuery.of(context).size.height-appBar.preferredSize.height-MediaQuery.of(context).padding.top)*0.7,              
              child: TransactionList(_userTransactions,_deleteTransaction)),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}

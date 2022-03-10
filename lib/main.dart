// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_key_in_widget_constructors
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mywallet/widgets/chart.dart';
import 'package:mywallet/widgets/new_transaction.dart';
import 'package:mywallet/widgets/transaction_list.dart';
import 'package:mywallet/models/transaction.dart';

import 'package:http/http.dart' as http;

void main() {
  // To set orientation for our app
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
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
  final List<Transaction> _userTransactions = [];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  Future<void> _addNewTransaction(String txtitle, double txamount, DateTime d) {
    var url = Uri.https(
        'mywallet-4401d-default-rtdb.firebaseio.com', '/transactions.json');
    return http
        .post(url,
            body: jsonEncode({
              "title": txtitle,
              "amount": txamount,
              "date": d.toString(),
            }))
        .then((value) {
      final tx = Transaction(
        title: txtitle,
        amount: txamount,
        date: d,
        id: jsonDecode(value.body)['name'],
      );

      setState(() {
        _userTransactions.add(tx);
      });
    });
  }

  void _deleteTransaction(String id) {
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

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('My Wallet'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
          ) as PreferredSizeWidget
        : AppBar(
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

    final chartContainer = Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.6,
        child: Chart(_recentTransactions));
    final listContainer = Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));
    // SafeArea widget for managing space on iOS
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Show Chart',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Switch.adaptive(
                      activeColor: Theme.of(context).accentColor,
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      }),
                ],
              ),
            if (!isLandscape)
              Container(
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.3,
                  child: Chart(_recentTransactions)),
            if (!isLandscape) listContainer,
            if (isLandscape)
              _showChart == true ? chartContainer : listContainer,
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(child: pageBody)
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}

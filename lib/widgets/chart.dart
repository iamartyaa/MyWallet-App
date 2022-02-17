// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:mywallet/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:mywallet/widgets/chart_bar.dart';
class Chart extends StatelessWidget {
  
  final List<Transaction> recentTransaction;

  Chart(this.recentTransaction);

  List<Map<String,Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay=DateTime.now().subtract(Duration(days : index,),);
      double totalSum=0;
      for(int i=0; i<recentTransaction.length ; i++){
        if(recentTransaction[i].date.day==weekDay.day && 
        recentTransaction[i].date.month==weekDay.month && 
        recentTransaction[i].date.year==weekDay.year)
        {
          totalSum+=recentTransaction[i].amount;
        }
      }
      return {'day': DateFormat.E().format(weekDay).substring(0,1), 'amount': totalSum};
  }).reversed.toList();
  }

  double get maxSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum+(item['amount'] as double);
    });
  }
    
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
          return Flexible(                    //Expanded
            fit: FlexFit.tight,
            child: ChartBar(data['day'].toString(), data['amount'] as double , maxSpending==0.0? 0.0 : (data['amount'] as double)/ (maxSpending)));
        }).toList(),),
      ),
    );
  }
}
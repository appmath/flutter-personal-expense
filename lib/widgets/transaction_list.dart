import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/models/transaction.dart';
import 'package:personal_expenses/widgets/transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  final Function deleteTransactionHandler;

  TransactionList(
      {required this.transactions, required this.deleteTransactionHandler});

  @override
  Widget build(BuildContext context) {
    print('build() TransactionList');

    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                Text('No Transactions added yet!',
                    style: Theme.of(context).textTheme.headline6),
                SizedBox(height: 20),
                Container(
                  height: 200,
                  child: Image.asset('assets/images/waiting.png'),
                )
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (context, index) {
              final tx = transactions[index];
              return TransactionItem(
                key: ValueKey(tx.id),
                tx: tx,
                deleteTransactionHandler: deleteTransactionHandler,
              );
            },
            itemCount: transactions.length,
          );
  }
}

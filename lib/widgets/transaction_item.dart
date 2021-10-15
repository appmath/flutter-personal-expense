import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    required Key key,
    required this.tx,
    required this.deleteTransactionHandler,
  }) : super(key: key);

  final Transaction tx;
  final Function deleteTransactionHandler;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  late Color _bgColor;

  @override
  void initState() {
    super.initState();
    const availableColors = [
      Colors.red,
      Colors.blue,
      Colors.black,
      Colors.blueGrey,
    ];

    var index = Random().nextInt(availableColors.length);
    _bgColor = availableColors[index];
    print('-- -- TransactionItem initState: ${widget.tx.id}, color: $index');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _bgColor,
            radius: 30,
            child: Padding(
              child: FittedBox(child: Text('\$${widget.tx.amount}')),
              padding: const EdgeInsets.all(6.0),
            ),
          ),
          title: Text(widget.tx.title,
              style: Theme.of(context).textTheme.headline6),
          subtitle: Text(
            DateFormat.yMMMd().format(widget.tx.date),
          ),
          trailing: MediaQuery.of(context).size.width > 460
              ? FlatButton.icon(
                  onPressed: () =>
                      widget.deleteTransactionHandler(widget.tx.id),
                  icon: Icon(Icons.delete),
                  label: Text('Delete'),
                  textColor: Theme.of(context).errorColor,
                )
              : IconButton(
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                  onPressed: () =>
                      widget.deleteTransactionHandler(widget.tx.id),
                )),
    );
  }
}

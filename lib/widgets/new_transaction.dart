import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'adpative_button.dart';

class NewTransaction extends StatefulWidget {
  final Function newTransactionHandler;

  NewTransaction({required this.newTransactionHandler}) {
    print('Constructor NewTransaction');
  }

  @override
  State<NewTransaction> createState() {
    print('CreateState NewTransaction');

    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  // final titleController = TextEditingController(text: "Groceries");
  // final amountController = TextEditingController(text: "12.0");

  final _titleController = TextEditingController(text: 'Yogurt');
  var _amountController = TextEditingController(text: '8.5');
  DateTime? _selectedDate;
  var _enteredAmount = 0.0;

  _NewTransactionState() {
    print('Constructor NewTransaction STATE');
  }

  @override
  void initState() {
    print('InitState() in NewTransaction');
    super.initState();
  }

  @override
  void didUpdateWidget(NewTransaction oldWidget) {
    print('didUpdateWidget() in NewTransaction');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    print('dispose() in NewTransaction');

    super.dispose();
  }

  void _submitData() {
    print('_submitData called');
    print('_amountController.text: $_amountController.text');
    _amountController =
        TextEditingController(text: getRandomAmount().toString());
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    try {
      _enteredAmount = double.parse(_amountController.text);
    } catch (e) {
      print(e);
    }
    if (enteredTitle.isNotEmpty &&
        _enteredAmount > 0 &&
        _selectedDate != null) {
      widget.newTransactionHandler(enteredTitle, _enteredAmount, _selectedDate);
      Navigator.of(context).pop();
    }
  }

  double getRandomAmount() => Random(5).nextInt(40).toDouble();

  Future<void> _presentDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                  // primary: Theme.of(context).colorScheme.secondary,
                  primary: Theme.of(context).primaryColor,

                  // header background color
                  onPrimary: Colors.white, // header text color
                  onSurface: Colors.black,
                  primaryVariant: Colors.amber // body text color
                  ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.black, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime.now());
    if (pickedDate != null) {
      print('pickedDate: $pickedDate');
      print('_enteredAmount: $_enteredAmount');

      // if (_enteredAmount <= 0) {
      //   return;
      // }
      setState(() {
        _selectedDate = pickedDate;
        print('setState selectedDate: $_selectedDate');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        // color: Colors.black,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),

                keyboardType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                onSubmitted: (_) => _submitData(),
                // onChanged: (val) => amountInput = val,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No date chosen'
                            : 'Picked date: ${DateFormat.yMd().format(_selectedDate!)}',
                      ),
                    ),
                    AdaptiveFlatButton(
                        label: 'Choose Date',
                        presentDatePicker: _presentDatePicker),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.secondary,
                    onPrimary: Colors.white),
                label: Text('Add Transaction',
                    style: TextStyle(
                      color: Colors.black,
                    )),
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                // onPressed: () => print('Buy'),
                onPressed: () => _submitData(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

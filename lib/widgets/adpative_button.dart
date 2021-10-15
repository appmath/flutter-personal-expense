import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final VoidCallback presentDatePicker;
  final String label;

  AdaptiveFlatButton({required this.label, required this.presentDatePicker});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            color: Colors.blue,
            child: Text(
              label,
              style: TextStyle(
                  // color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700),
            ),
            onPressed: presentDatePicker,
          )
        : FlatButton(
            child: Text(
              label,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700),
            ),
            onPressed: presentDatePicker,
          );
  }
}

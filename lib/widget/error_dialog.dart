import 'package:flutter/material.dart';

/// error dialog
Future<void> showMyDialog(
    BuildContext context, String title, String text, String text2) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext allertcontext) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(text),
              Text(text2),
            ],
          ),
        ),
      );
    },
  );
}

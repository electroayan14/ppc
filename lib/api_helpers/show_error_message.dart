import 'package:flutter/material.dart';

void showSnackBarMessage(BuildContext context, {required String message}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

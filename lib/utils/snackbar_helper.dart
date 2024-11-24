import 'package:flutter/material.dart';

//Display an error message as a red snackbar
void showErrorMessage(
  BuildContext context, {
  required String message,
}) {
  //snackbar gives visual feedback to the user
      final snackBar = SnackBar(
        content:Text(
          message,       
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.red,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

//Display a success message as a default snackbar
void showSuccessMessage(
  BuildContext context, {
  required String message,
}) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

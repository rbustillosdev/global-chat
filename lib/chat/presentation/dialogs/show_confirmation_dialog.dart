import 'package:flutter/material.dart';

Future<bool> showConfirmationDialog(BuildContext context, String message) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Hold on"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text("Yes, continue"),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  ) ?? false;
}
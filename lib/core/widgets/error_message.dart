import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, String message) async {
  await showDialog(context: context, builder: (BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.error_outline_rounded, color: Colors.red, size: 90,),
      content: Text(message),
      actions: [
        TextButton(onPressed: (){
          Navigator.of(context).pop(true);
        }, child: const Text('Got it'))
      ],
    );
  });
}
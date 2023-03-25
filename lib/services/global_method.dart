
import 'package:flutter/material.dart';

class GlobalMethod {
  static void showErrorDialog({
    required String error, required BuildContext ctx})

  {
    showDialog<void>(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(padding: EdgeInsets.all(8),
                child: Icon(Icons.logout, color: Colors.grey, size: 35,),
                ),
                Padding(padding: EdgeInsets.all(8),
                child: Text('Error Occurred'),
                )
              ],
            ),
            content: Text(
              '$error',
              style: TextStyle(
                color: Colors.black54,
                fontStyle: FontStyle.italic,
                fontSize: 20
              ),
            ),
            actions: [
              TextButton(onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              }, child: Text(
                'Ok',
                style: TextStyle(color: Colors.redAccent),
              ))
            ],
          );
    }
    );
  }
}
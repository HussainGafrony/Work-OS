import 'package:flutter/material.dart';
import 'package:workos/widget/constants.dart';

class GlobalMethods {
  static void showErrorDialog({required context, required error}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/4457/4457164.png',
                    height: 30,
                    width: 30,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Error occured'),
                ),
              ],
            ),
            content: Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                error,
                style: TextStyle(
                    color: Constants.darkBlue,
                    fontSize: 20,
                    fontStyle: FontStyle.italic),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Text('ok',
                    style: TextStyle(color: Colors.red, fontSize: 20)),
              ),
            ],
          );
        });
  }
}

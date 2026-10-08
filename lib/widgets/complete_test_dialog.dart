import 'package:flutter/material.dart';

void showDialogForCompletedTest(BuildContext context, DateTime date) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Ya has completado este test'),
        content: Text('Podrás realizarlo nuevamente el ${_getNextDate(date)}'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}

String _getNextDate(DateTime date) {
  // Add 15 days to the date
  final nextDate = date.add(const Duration(days: 15));
  // Return the next date in this format: 'dd/MM/yyyy'
  return '${nextDate.day}/${nextDate.month}/${nextDate.year}';
}

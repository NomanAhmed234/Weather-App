import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentDateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current date
    DateTime now = DateTime.now();

    // Format the date as needed
    String formattedDate = DateFormat('dd, MMM yyyy').format(now);

    return Text(
      '$formattedDate',
      style: TextStyle(fontSize: 18, color: Colors.green),
    );
  }
}

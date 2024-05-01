import 'package:flutter/material.dart';

class CurrentTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current time
    DateTime now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text('Current Time'),
      ),
      body: Center(
        child: Text(
          'Current Time: ${now.hour}:${now.minute}:${now.second}',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

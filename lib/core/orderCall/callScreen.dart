/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'OrderCall.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Call Manager')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async => await CallManager().endCall(),
              child: const Text('End Current Call'),
            ),
            ElevatedButton(
              onPressed: () async {
                final data = CallManager().getCurrentCallData();
                print('Current Call Data: $data');
              },
              child: const Text('Get Current Call Data'),
            ),
          ],
        ),
      ),
    );
  }
}
*/

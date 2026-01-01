/*
// call_events_listener.dart
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';



class CallEventsListener {
  static final CallEventsListener _instance = CallEventsListener._internal();
  factory CallEventsListener() => _instance;
  CallEventsListener._internal();

  void startListening() {
    FlutterCallkitIncoming.onEvent.listen((event) {
      final name = event!.body;
      final data = event.body;
      print('Call Event: $name, Data: $data');

      switch (name) {
        case CallEvent().:
          _onAccept();
          break;
        case CallEvent.ACTION_CALL_DECLINE:
          _onDecline();
          break;
        case CallEvent.ACTION_CALL_MUTED:
          _onMute();
          break;
      }
    });
  }

  void _onAccept() {
    print('Call accepted');
  }

  void _onDecline() {
    print('Call declined');
  }

  void _onMute() {
    print('Call muted');
  }
}


*/

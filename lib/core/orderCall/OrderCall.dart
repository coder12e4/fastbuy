// call_manager.dart
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

class CallManager {
  static final CallManager _instance = CallManager._internal();
  factory CallManager() => _instance;
  CallManager._internal();

  String? _currentCallId;
  Map<String, dynamic>? _currentCallData;

  Future<void> showIncomingCall(Map<String, dynamic> data) async {
    final callUUID = DateTime.now().millisecondsSinceEpoch.toString();
    final params = CallKitParams(
      id: callUUID,
      nameCaller: data['caller_name'] ?? 'Unknown Caller',
      handle: data['caller_number'] ?? 'Unknown Number',
      type: 0, // 0 = audio, 1 = video
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Reject',
      extra: data,
      android: const AndroidParams(
        isCustomNotification: true,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        backgroundUrl: 'system_background_default',
        actionColor: '#4CAF50',
      ),
    );

    _currentCallId = callUUID;
    _currentCallData = data;

    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  Future<void> endCall() async {
    if (_currentCallId != null) {
      await FlutterCallkitIncoming.endCall(_currentCallId!);
      _currentCallId = null;
      _currentCallData = null;
    }
  }

  Map<String, dynamic>? getCurrentCallData() => _currentCallData;
}

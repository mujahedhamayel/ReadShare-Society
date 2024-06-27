import 'package:flutter/services.dart';

class ZoomService {
  static const MethodChannel _channel = MethodChannel('com.yourpackage/zoom');

  static Future<String?> createZoomMeeting() async {
    final String? meetingLink =
        await _channel.invokeMethod('createZoomMeeting');
    return meetingLink;
  }
}

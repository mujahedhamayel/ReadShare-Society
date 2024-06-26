package com.example.bookv_app

import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.yourpackage/zoom"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "createZoomMeeting") {
                val meetingLink = createZoomMeeting()
                result.success(meetingLink)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun createZoomMeeting(): String {
        // Your Zoom SDK integration code to create a meeting
        // Return the meeting link
        return "https://zoom.us/j/meeting_id"
    }
}

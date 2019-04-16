package com.prijindal.fastter_todo

import android.content.Intent
import android.os.Bundle

import java.nio.ByteBuffer

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.ActivityLifecycleListener
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  private var sharedText : String = "";

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    var intent : Intent = getIntent()
    var action = intent.getAction()
    var type = intent.getType()

    if (Intent.ACTION_SEND.equals(action) && type != null) {
      if ("text/plain".equals(type)) {
        handleSendText(intent)
      }
    }

    val channel = MethodChannel(flutterView, "app.channel.shared.data")

    channel.setMethodCallHandler { call, result ->
      when (call.method) {
          "getSharedText" -> result.success(sharedText)
        }
    }
  }

  fun handleSendText(intent : Intent) {
    sharedText = intent.getStringExtra(Intent.EXTRA_TEXT)
  }
}

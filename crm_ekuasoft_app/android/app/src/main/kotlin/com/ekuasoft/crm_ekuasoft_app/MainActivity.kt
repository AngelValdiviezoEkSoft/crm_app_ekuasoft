package com.ekuasoft.crm_ekuasoft_app


import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "call_channel"
    private val EMAILCHANNEL = "email_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "makePhoneCall") {
                val phoneNumber = call.argument<String>("phone") ?: ""
                val intent = Intent(Intent.ACTION_DIAL, Uri.parse("tel:$phoneNumber"))
                startActivity(intent)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, EMAILCHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "openEmailApp") {
                val email = call.argument<String>("email") ?: ""
                val intent = Intent(Intent.ACTION_SENDTO).apply {
                    data = Uri.parse("mailto:$email") // Abre la app de correos con la dirección prellenada
                }
                try {
                    startActivity(intent)
                    result.success(null)
                } catch (e: Exception) {
                    result.error("UNAVAILABLE", "No se pudo abrir la aplicación de correo", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
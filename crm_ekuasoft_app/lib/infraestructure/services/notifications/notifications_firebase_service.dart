import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class NotificationFirebaseService {

  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> messageString = StreamController.broadcast();
  static Stream<String> get messagesStream => messageString.stream;
    
  static final _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> init() async {    
    requestPermission();

    // Obtener token del dispositivo
    final token = await _firebaseMessaging.getToken();
    //print('🔑 Token FCM: $token');

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler); 
    FirebaseMessaging.onMessage.listen(_onMessageHandler); 
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
    
  }

  static Future _backgroundHandler (RemoteMessage message) async { 
    messageString.sink.add(message.data['llamada'] ?? 'No hay titulo' );
    cantNotificaciones += 1;
  }

  static Future _onMessageHandler (RemoteMessage message) async { 
    
    Future.delayed(const Duration(seconds: 10), () {
      if(contextPrincipalGen != null) {
        Navigator.push(
          contextPrincipalGen!,
          MaterialPageRoute(
            builder: (_) => NotificationDetailView(
              title: message.notification?.title,
              body: message.notification?.body,
              data: message.data,
            ),
          ),
        );
      }
    });
    //cantNotificaciones += 1;
    messageString.sink.add(message.data['llamada'] ?? 'No hay data' );
  }

  static Future _onMessageOpenApp (RemoteMessage message) async { 
    if(contextPrincipalGen != null) {
      Navigator.push(
        contextPrincipalGen!,
        MaterialPageRoute(
          builder: (_) => NotificationDetailView(
            title: message.notification?.title,
            body: message.notification?.body,
            data: message.data,
          ),
        ),
      );
    }
    cantNotificaciones += 1;
    messageString.sink.add(message.data['llamada'] ?? 'No hay data' );
  }

  static closeStreams() {
    messageString.close();
  }

  static requestPermission() async {

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true
    );

    //print('User push notification status ${ settings.authorizationStatus }');

  }
}

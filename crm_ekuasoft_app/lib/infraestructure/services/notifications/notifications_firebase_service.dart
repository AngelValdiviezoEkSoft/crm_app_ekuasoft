import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';

class NotificationFirebaseService {

  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> messageString = StreamController.broadcast();
  static Stream<String> get messagesStream => messageString.stream;
    
  static final _firebaseMessaging = FirebaseMessaging.instance;
  //static final _localNotifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Solicitar permisos
    //await _firebaseMessaging.requestPermission();
    requestPermission();

    // Inicializar notificaciones locales
    //const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    //const initSettings = InitializationSettings(android: androidInit);
    //await _localNotifications.initialize(initSettings);

    // Obtener token del dispositivo
    final token = await _firebaseMessaging.getToken();
    print('🔑 Token FCM: $token');

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler); 
    FirebaseMessaging.onMessage.listen(_onMessageHandler); 
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
    
  }

  static Future _backgroundHandler (RemoteMessage message) async { 
    messageString.sink.add(message.data['producto'] ?? 'No hay titulo' );
  }

  static Future _onMessageHandler (RemoteMessage message) async { 
    print('HOLAAA: $message');
    messageString.sink.add(message.data['producto'] ?? 'No hay data' );
  }

  static Future _onMessageOpenApp (RemoteMessage message) async { 
    messageString.sink.add(message.data['producto'] ?? 'No hay data' );
  }

  static closeStreams() {
    messageString.close();
  }

  static requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true
    );

    print('User push notification status ${ settings.authorizationStatus }');

  }
}

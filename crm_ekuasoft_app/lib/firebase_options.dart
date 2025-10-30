import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // (Opcional) Configuración web
      throw UnsupportedError('FirebaseOptions no configurado para Web');
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      // ✅ Configuración para Android
      return const FirebaseOptions(
        apiKey: 'AIzaSyCVeoar3sOYf-j2fAmrH5R1UrhGN_zIkPY',
        appId: '1:811143346495:android:166f0ac710777cedb87b8a',
        messagingSenderId: '811143346495',
        projectId: 'notificaciones-cve-test',
        storageBucket: 'notificaciones-cve-test.firebasestorage.app',
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      // (Opcional) Configuración iOS/macOS
      throw UnsupportedError('FirebaseOptions no configurado para iOS/macOS');
    } else {
      throw UnsupportedError(
        'DefaultFirebaseOptions no está configurado para esta plataforma.',
      );
    }
  }
}

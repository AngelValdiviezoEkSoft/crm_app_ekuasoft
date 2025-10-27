import 'dart:convert';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:http/http.dart' as http;


class NotificationService {
  static const String baseUrl = "https://tu-api.com/api";

  static Future<List<NotificationModel>> fetchNotifications() async {
    final response = await http.get(Uri.parse('$baseUrl/notifications'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => NotificationModel.fromJson(e)).toList();
    } else {
      //throw Exception('Error al cargar notificaciones');
      /* 
      [
  {
    "id": 1,
    "title": "Nueva actualización",
    "message": "Ya está disponible la versión 2.0",
    "date": "2025-10-27T09:30:00",
    "icon": "system_update_alt"
  },
  {
    "id": 2,
    "title": "Recordatorio",
    "message": "Tienes una reunión hoy a las 15:00",
    "date": "2025-10-27T08:00:00",
    "icon": "alarm"
  }
]

      */

      final List<dynamic> data = jsonDecode('[{"id": 1,"title": "Nueva actualización","message": "Ya está disponible la versión 2.0","date": "2025-10-27T09:30:00","icon": "system_update_alt"},{"id": 2,"title": "Recordatorio","message": "Tienes una reunión hoy a las 15:00","date": "2025-10-27T08:00:00","icon": "alarm"}]');
      return data.map((e) => NotificationModel.fromJson(e)).toList();

      //throw Exception('No existen notificaciones');
    }
  }

  static Future<bool> deleteNotification(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/notifications/$id'));
    return response.statusCode == 200;
  }
}

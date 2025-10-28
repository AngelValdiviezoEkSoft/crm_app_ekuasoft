import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';


class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<NotificationModel>> _futureNotifications;
  final DateFormat formatter = DateFormat('dd MMM, HH:mm');

  @override
  void initState() {
    super.initState();
    _futureNotifications = NotificationService.fetchNotifications();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureNotifications = NotificationService.fetchNotifications();
    });
  }

  void _deleteNotification(int id) async {
    final success = await NotificationService.deleteNotification(id);
    if (success) {
      //ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Notificación eliminada")),
      );
      _refresh();
    } else {
      //ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al eliminar notificación")),
      );
    }
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'alarm':
        return Icons.alarm;
      case 'message':
        return Icons.message;
      case 'system_update_alt':
        return Icons.system_update_alt;
      case 'info':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        centerTitle: true,
        elevation: 2,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 19,),
            onPressed: () {
              //ignore: use_build_context_synchronously
              FocusScope.of(context).unfocus();
              context.pop();
            },
          ),
          
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<NotificationModel>>(
          future: _futureNotifications,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No hay notificaciones',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            final notifications = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final n = notifications[index];
                return Dismissible(
                  key: Key(n.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.redAccent,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _deleteNotification(n.id),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(_getIcon(n.icon), color: Colors.blue),
                      ),
                      title: Text(
                        n.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(n.message),
                          const SizedBox(height: 4),
                          Text(
                            formatter.format(n.date),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

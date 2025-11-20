import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationDetailScreen extends StatelessWidget {
  final String? title;
  final String? body;
  final Map<String, dynamic>? data;

  const NotificationDetailScreen({
    super.key,
    this.title,
    this.body,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Detalle de Notificación', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? 'Sin título',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  body ?? 'Sin contenido',
                  style: const TextStyle(fontSize: 16),
                ),
                const Divider(height: 30),
                if (data != null && data!.isNotEmpty)
                  Expanded(
                    child: ListView(
                      children: data!.entries.map((entry) {
                        return ListTile(
                          title: Text('Tipo de actividad: ${entry.key}', style: const TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Text(entry.value.toString()),
                        );
                      }).toList(),
                    ),
                  )
                else
                  const Text(
                    'No hay datos adicionales.',
                    style: TextStyle(color: Colors.grey),
                  ),
                
                if (data != null && data!.isNotEmpty)
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Cierre Actividad"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

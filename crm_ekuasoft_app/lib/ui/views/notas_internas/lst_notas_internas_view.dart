import 'package:flutter/material.dart';

class ListaNotasInternasView extends StatelessWidget {
  const ListaNotasInternasView({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de ejemplo
    final List<String> items = [
      'Nota 1',
      'Nota 2',
      'Nota 3',
      'Nota 4',
      'Nota 5',
    ];

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(
                '${index + 1}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(items[index]),
            subtitle: const Text('Descripción del elemento'),
            //trailing: const Icon(Icons.arrow_forward_ios, size: 18),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tocaste: ${items[index]}')),
              );
            },
          ),
        );
      },
    );
  }
}

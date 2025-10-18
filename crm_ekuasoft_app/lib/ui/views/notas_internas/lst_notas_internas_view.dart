import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:crm_ekuasoft_app/ui/screens/prospectos/listado_prospectos_screen.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ListaNotasInternasView extends StatefulWidget {
  const ListaNotasInternasView({super.key});

  @override
  State<ListaNotasInternasView> createState() => ListaNotasInternasViewState();
}

class ListaNotasInternasViewState extends State<ListaNotasInternasView> {
  
  @override
  void initState() {
    super.initState();    
  }

  Future<List<MessageData>> _consultarNotas() async {
    return await NotasInternasService().getNotasInternas(objDatumCrmLead?.id ?? 0);
  }

  void _mostrarHtmlEnModal(BuildContext context, String htmlContent) {

    var msmFinal = htmlContent.split('<p>');
    var msmFinal2 = msmFinal[1].split('</p>');
    var msmFinal3 = msmFinal2[0];

    final htmlConEstilo = '''
  <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style>
        body {
          font-size: 18px;
          font-family: Arial, Helvetica, sans-serif;
          color: #333;
          padding: 16px;
          line-height: 1.6;
          background-color: #fafafa;
        }
        p {
          margin-bottom: 12px;
        }
        h1, h2, h3 {
          color: #1e88e5;
        }
        a {
          color: #1976d2;
          text-decoration: none;
        }
      </style>
    </head>
    <body>
      $msmFinal3
    </body>
  </html>
  ''';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          height: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Detalle de la nota',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                  child: WebViewWidget(
                    controller: WebViewController()
                      ..setJavaScriptMode(JavaScriptMode.unrestricted)
                      ..loadHtmlString(htmlConEstilo),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: ElevatedButton.icon(
                  onPressed: () { 
                    FocusScope.of(context).unfocus();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close, color: Colors.white,),
                  label: const Text('Cerrar', style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final bool tecladoVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    if (tecladoVisible) {
      FocusScope.of(context).unfocus();
    }

    return FutureBuilder<List<MessageData>>(
      future: _consultarNotas(),
      builder: (context, snapshot) {
        // 🔹 Estado de carga
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 🔹 Manejo de error
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Ocurrió un error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        // 🔹 Datos obtenidos
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final notas = snapshot.data!;
          return ListView.builder(
            itemCount: notas.length,
            itemBuilder: (context, index) {
              final nota = notas[index];
              final fecha = nota.createDate != null
                  ? nota.createDate!
                  : 'Sin fecha';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(                  
                  title: Text(
                    nota.description?.replaceAll(RegExp(r'<[^>]*>'), '') ??'(Sin descripción)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text('Creado en $fecha'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                    onPressed: () => _mostrarHtmlEnModal(
                      context,
                      nota.body ?? '<p>Sin contenido</p>',
                    ),
                  ),
                ),
              );
            },
          );
        }

        return const Center(
          child: Text('No hay notas registradas.'),
        );
      },
    );
  }
}

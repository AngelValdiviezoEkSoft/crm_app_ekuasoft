import 'package:crm_ekuasoft_app/config/config.dart';
import 'package:crm_ekuasoft_app/main.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';

class FrmNotasInternasView extends StatefulWidget {
  const FrmNotasInternasView({super.key});

  @override
  State<FrmNotasInternasView> createState() => _FrmNotasInternasViewState();
}

class _FrmNotasInternasViewState extends State<FrmNotasInternasView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _observacionesController = TextEditingController();

  @override
  void dispose() {
    _observacionesController.dispose();
    super.dispose();
  }

  void _guardarObservacion() {
    if (_formKey.currentState!.validate()) {
      final observacion = _observacionesController.text.trim();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Observación guardada: $observacion')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Notas Internas:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              
              SizedBox(height: size.height * 0.02),

              TextFormField(
                controller: _observacionesController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Escribe tus notas aquí...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa una observación';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: size.height * 0.03),

              ElevatedButton.icon(
                onPressed: _guardarObservacion,
                icon: const Icon(Icons.save, color: Colors.white,),
                label: const Text('Guardar', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            
              SizedBox(height: size.height * 0.03),

              Container(
                color: Colors.transparent,
                height: rutaActualGen == objRutas.rutaEditProsp ?
                size.height * 0.25
                :
                size.height * 0.35,
                width: size.width * 0.9,
                child: const ListaNotasInternasView(),
              )
            ],
          ),
        ),
      );
  }
}

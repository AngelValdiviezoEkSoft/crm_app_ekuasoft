import 'package:crm_ekuasoft_app/config/config.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:crm_ekuasoft_app/main.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FrmNotasInternasView extends StatefulWidget {
  const FrmNotasInternasView({super.key});

  @override
  State<FrmNotasInternasView> createState() => _FrmNotasInternasViewState();
}

class _FrmNotasInternasViewState extends State<FrmNotasInternasView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _observacionesController = TextEditingController();

  final GlobalKey<ListaNotasInternasViewState> _listaNotasKey = GlobalKey<ListaNotasInternasViewState>();


  @override
  void dispose() {
    _observacionesController.dispose();
    super.dispose();
  }

  void _guardarObservacion() async {
    FocusScope.of(context).unfocus();
    
    if (_formKey.currentState!.validate()) {

      showDialog(
        //ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: false,
        builder: (context) => SimpleDialog(
          alignment: Alignment.center,
          children: [
            SimpleDialogCargando(
              null,
              mensajeMostrar: 'Estamos registrando',
              mensajeMostrarDialogCargando: 'la nota interna.',
            ),
          ]
        ),
      );

      FocusScope.of(context).unfocus();

      ActivitiesTypeRequestModel objReqst = ActivitiesTypeRequestModel(
        active: true,
        createDate: DateTime.now(),//DateTime.parse(fechaActividadContTxtAct.text),
        createUid: 0,
        displayName: objDatumCrmLead?.contactName ?? '',
        previousActivityTypeId: 0,
        note: descripcionActTxtAct.text,
        activityTypeId: 0,
        dateDeadline: DateTime.now(),//objDatumCrmLead?.dateDeadline ?? DateTime.now(),
        userId: objDatumCrmLead?.userId!.id ?? 0,
        userCreateId: objDatumCrmLead?.userId!.id ?? 0,
        resId: objDatumCrmLead?.id ?? 0,
        actId: 0,
        workingTime: 0,
        summary: '',
        leadName: objDatumCrmLead?.name ?? '',
        leadPhone: objDatumCrmLead?.phone ?? '',                                                      
        contactName: objDatumCrmLead?.contactName ?? '',
        leadEmail: objDatumCrmLead?.emailFrom ?? ''
      );

      await NotasInternasService().registroNotasInternas(objReqst, _observacionesController.text);

      _observacionesController.text = '';

      //ignore: use_build_context_synchronously
      context.pop();

      _listaNotasKey.currentState!.setState(() {
        
      });

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
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
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
                child: ListaNotasInternasView(key: _listaNotasKey,),
              )
            ],
          ),
        ),
      );
  }
}

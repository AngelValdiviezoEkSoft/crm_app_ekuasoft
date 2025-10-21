import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

bool _isButtonPressed = false;
String tradeNameProsp = '';
String channelProsp = '';
String ciudadPrsp = '';
String cantonPrsp = '';
String regionPrsp = '';
String sectorPrsp = '';
String clasificacionPrsp = '';
bool seleccionaTodasActividades = false;
bool seleccionaUnaActividad = false;
int activitySelected = 0;
List<MailActivityTypeDatumAppModel> actividadesFilAgendaPlanAct = [];
List<String> lstTipoActividades = [];
List<String> lstMotivoPerdida = [];
int idProspectoAct = 0;
Timer? _timerAct;
int _segundosAct = 0;
bool _corriendoAct = false;
String motPerdSelect = '';
String terminoBusquedaActiv = '';
bool actualizaListaActiv= false;
int contLstActiv = 0;
//import 'package:one_clock/one_clock.dart';
String actPlanSelectAct = '';
String tipoActividadEscogida = '';

late TextEditingController fechaActividadContTxtAct;
late TextEditingController horaActividadContTxtAct;
late TextEditingController descripcionActTxtAct;

int tabAccionesAct = 0;
late TextEditingController notasActTxtAct;

List<DatumActivitiesResponse> actividadesFiltradasAct = [];
List<DatumActivitiesResponse> lstActividadesDiariasByProspecto = [];
List<CrmLostReasonData> motivosPerdida = [];

class PlanificacionActividadesConActividadScreen extends StatefulWidget {
  const PlanificacionActividadesConActividadScreen(Key? key) : super (key: key);
  @override
  State<PlanificacionActividadesConActividadScreen> createState() => PlanActivState();
}

class PlanActivState extends State<PlanificacionActividadesConActividadScreen> {

  final GlobalKey<ListaProspectosScreenState> listaProspectosKey =  GlobalKey<ListaProspectosScreenState>();
  String paisSelect = 'Ecuador';
  String campSelect = '';
  String mediaSelect = '';
  String originSelect = '';
  TimeOfDay? horaSeleccionada;
  double horaGuardarAct = 0;
  final TextEditingController motivoPerdidaTxtController = TextEditingController();
  bool muestraMotivoPerdida = false;
  int prioridadPrsp = 0;

  @override
  void initState() {
    super.initState();
    motivosPerdida = [];
    
    if(objDatumCrmLead != null && objDatumCrmLead!.priority.isNotEmpty){
      prioridadPrsp = int.parse(objDatumCrmLead!.priority);
    }
    
    _isButtonPressed = false;
    muestraMotivoPerdida = false;
    motPerdSelect = '';
    tradeNameProsp = '-----';
    contLstActiv = 0;
    notasActTxtAct = TextEditingController();
    fechaActividadContTxtAct = TextEditingController();
    horaActividadContTxtAct = TextEditingController();
    descripcionActTxtAct = TextEditingController();
    terminoBusquedaActiv = '';
    actualizaListaActiv= false;
    actividadesFiltradasAct = [];
    idProspectoAct = 0;
    _segundosAct = 0;
    _corriendoAct = false;
    actividadesFilAgendaPlanAct = [];
    lstActividadesDiariasByProspecto = [];
    tipoActividadEscogida = '';
    seleccionaTodasActividades = false;
    seleccionaUnaActividad = false;
    channelProsp = '-----';
    tabAccionesAct = 0;
    clasificacionPrsp = '-----';
    ciudadPrsp = '-----';
    cantonPrsp = '-----';
    regionPrsp = '-----';
    sectorPrsp = '-----';
    horaGuardarAct = 0;
    //prioridadPrsp = 0;
  }

  @override
  void dispose(){
    super.dispose();
  }

  Future<void> actualizaActividadesByCliente() async {
    try {
      lstActividadesDiariasByProspecto = [];
      ActivitiesPageModel? objRspFinal = await ActivitiesService().getActivitiesDiariasByProspecto( null, objDatumCrmLead?.id ?? 0);
      
      if(objRspFinal != null){
        lstActividadesDiariasByProspecto = objRspFinal.activities.data;        
      }
      
      if(lstActividadesDiariasByProspecto.isNotEmpty){
        for(int i = 0; i < lstActividadesDiariasByProspecto.length; i++){
          lstActividadesDiariasByProspecto[i].cerrado = false;
        }
      }

      setState(() {
        
      });
      
    } catch (_) {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    final planActiv = BlocProvider.of<GenericBloc>(context);

    return BlocBuilder<GenericBloc, GenericState>(
        builder: (context,state) {

          double probCalculada = 0;

          if(objDatumCrmLead != null && objDatumCrmLead!.probability != null){
            probCalculada = objDatumCrmLead!.probability! * 100;
          }
        
          return WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  objDatumCrmLead?.contactName ?? '-- Sin nombre --',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.blue.shade800,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
            
                    if(_segundosAct > 0){
                      
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Registro de salida'),
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '¿Está seguro de realizar esta acción?',
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  context.pop();
                                  //Navigator.pop(context);
                                  //ignore:use_build_context_synchronously
                                  //context.push(objRutasGen.rutaListaProspectos);
                                },
                                child: Text(
                                  'NO',
                                  style: TextStyle(color: Colors.blue[200]),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Sí',
                                  style: TextStyle(color: Colors.blue[200]),
                                ),
                              ),
                            ],
                          );
                        },
                      );
            
                      return;
                    }
                    else {
                      context.pop();
                      //ignore:use_build_context_synchronously
                      //context.push(objRutasGen.rutaListaProspectos);
                    }
            
                  },
                ),
                actions: [
                  GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.06),
                            ),
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext bc) {
                              return BlocBuilder<GenericBloc, GenericState>(
                                builder: (context, state) {
                                  return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                      color: Colors.transparent,
                                      width: size.width,
                                      height: size.height * state.heightModalPlanAct, //0.57,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: AppSpacing.space03(),
                                            ),
                                            SizedBox(
                                              width: size.width * 0.15,
                                              child: Image.asset(
                                                'assets/images/ic_horizontalLine.png',
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            SizedBox(
                                              height: AppSpacing.space03(),
                                            ),
                                            const Text(
                                              'Registrar actividad',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'En esta interfaz es posible registrar las actividades que serán realizadas con los prospectos/leads asignados',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[700]
                                              ),
                                            ),

                                            const SizedBox(height: 24),
                                            
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              child: DropdownButtonFormField<String>(
                                                decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Seleccione el tipo de actividad...',
                                                ),
                                                //value: campSelect,
                                                items: lstTipoActividades.map((activityPrsp) =>
                                                  DropdownMenuItem(
                                                      value: activityPrsp,
                                                      child: Text(activityPrsp, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 12),),                                              
                                                    )
                                                  )
                                                .toList(),
                                                onChanged: (String? newValue) {                        
                                                  setState(() {
                                                    campSelect = newValue ?? '';
                                                  });
                                                },
                                              ),
                                            ),
                                            
                                            const SizedBox(height: 16),
                                            
                                            Row(
                                              children: [
                                                Container(
                                                  color: Colors.transparent,
                                                  width: size.width * 0.45,
                                                  child: TextFormField(
                                                    controller: fechaActividadContTxtAct,
                                                    readOnly: true,
                                                    decoration: const InputDecoration(
                                                      labelText: 'Fecha actividad',
                                                      border: OutlineInputBorder(),
                                                      suffixIcon: Icon(Icons.calendar_today),
                                                    ),
                                                    onTap: () async {
                                                      DateTime? pickedDate = await showDatePicker(
                                                        context: context,
                                                        initialDate: DateTime.now(),
                                                        firstDate: DateTime.now(),//DateTime(2020),
                                                        lastDate: DateTime(DateTime.now().year + 1),
                                                      );
                                                      
                                                      if (pickedDate != null) {
                                                        fechaActividadContTxtAct.text = DateFormat('yyyy-MM-dd', 'es').format(pickedDate);                                                        
                                                      }
                                                    },
                                                  ),
                                                ),
                                                SizedBox(width: size.width * 0.02,),
                                                Container(
                                                  color: Colors.transparent,
                                                  width: size.width * 0.45,
                                                  child: TextFormField(
                                                    controller: horaActividadContTxtAct,
                                                    readOnly: true,
                                                    decoration: const InputDecoration(
                                                      labelText: 'Hora actividad',
                                                      border: OutlineInputBorder(),
                                                      suffixIcon: Icon(Icons.work_history_rounded),
                                                    ),
                                                    onTap: () async {
                                                      final TimeOfDay? hora = await showTimePicker(
                                                        context: context,
                                                        initialTime: horaSeleccionada ?? TimeOfDay.now(),
                                                      );
                                                      
                                                      if (hora != null) {
                                                        horaSeleccionada = hora;

                                                        horaGuardarAct = (hora.minute / 60) + hora.hour;

                                                        String conversionTmp = horaGuardarAct.toStringAsFixed(4);

                                                        horaGuardarAct = double.parse(conversionTmp);

                                                        //ignore: use_build_context_synchronously
                                                        horaActividadContTxtAct.text = hora.format(context);

                                                      }
                                                  
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            
                                            const SizedBox(height: 16),
                                            TextFormField(
                                              controller: descripcionActTxtAct,
                                              onChanged: (value) {
                                                planActiv.setHeightModalPlanAct(0.92);
                                              },
                                              onTap: () {
                                                planActiv.setHeightModalPlanAct(0.92);
                                              },
                                              onEditingComplete: () {
                                                planActiv.setHeightModalPlanAct(0.65);
                                                FocusScope.of(context).unfocus();
                                              },
                                              onTapOutside: (event) {
                                                planActiv.setHeightModalPlanAct(0.65);
                                                FocusScope.of(context).unfocus();
                                              },
                                              maxLines: 4,
                                              decoration: const InputDecoration(
                                                labelText: 'Ingrese su descripción...',
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                            SizedBox(height: size.height * 0.035),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    context.pop();
                                                  },
                                                  
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: ColorsApp().celeste,
                                                  ),
                                                  child: const Text(
                                                    'Cerrar',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
            
                                                    if(fechaActividadContTxtAct.text.isEmpty){
                                                      showDialog(
                                                        barrierDismissible: false,
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return ContentAlertDialog(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            onPressedCont: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            tipoAlerta: TipoAlerta().alertAccion,
                                                            numLineasTitulo: 2,
                                                            numLineasMensaje: 2,
                                                            titulo: 'Error',
                                                            mensajeAlerta: 'Ingrese la fecha de la actividad.'
                                                          );
                                                        },
                                                      );
                                    
                                                      return;
                                                    }
            
                                                    if(descripcionActTxtAct.text.isEmpty){
                                                      showDialog(
                                                        barrierDismissible: false,
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return ContentAlertDialog(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            onPressedCont: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            tipoAlerta: TipoAlerta().alertAccion,
                                                            numLineasTitulo: 2,
                                                            numLineasMensaje: 2,
                                                            titulo: 'Error',
                                                            mensajeAlerta: 'Ingrese la descripción de la actividad.'
                                                          );
                                                        },
                                                      );
                                    
                                                      return;
                                                    }

                                                    if(horaActividadContTxtAct.text.isEmpty){
                                                      showDialog(
                                                        barrierDismissible: false,
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return ContentAlertDialog(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            onPressedCont: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            tipoAlerta: TipoAlerta().alertAccion,
                                                            numLineasTitulo: 2,
                                                            numLineasMensaje: 2,
                                                            titulo: 'Error',
                                                            mensajeAlerta: 'Selecciona hora para la actividad.'
                                                          );
                                                        },
                                                      );
                                    
                                                      return;
                                                    }
            
                                                    int activityTypeIdFrm = 0;
            
                                                    for(int i = 0; i < actividadesFilAgendaPlanAct.length; i++){
                                                      if(campSelect == actividadesFilAgendaPlanAct[i].name){
                                                        activityTypeIdFrm = actividadesFilAgendaPlanAct[i].id ?? 0;
                                                      }
                                                    }
                                                    
                                                    if(activityTypeIdFrm == 0){
                                                      showDialog(
                                                        barrierDismissible: false,
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return ContentAlertDialog(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            onPressedCont: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            tipoAlerta: TipoAlerta().alertAccion,
                                                            numLineasTitulo: 2,
                                                            numLineasMensaje: 2,
                                                            titulo: 'Error',
                                                            mensajeAlerta: 'Seleccione el tipo de actividad.'
                                                          );
                                                        },
                                                      );
                                    
                                                      return;
                                                    }
            
                                                    double tiempo = double.parse(_segundosAct.toString());

                                                    ActivitiesTypeRequestModel objReqst = ActivitiesTypeRequestModel(
                                                      active: true,
                                                      createDate: DateTime.now(),//DateTime.parse(fechaActividadContTxtAct.text),
                                                      createUid: 0,
                                                      displayName: objDatumCrmLead?.contactName ?? '',
                                                      previousActivityTypeId: 0,
                                                      note: descripcionActTxtAct.text,
                                                      activityTypeId: activityTypeIdFrm,
                                                      dateDeadline: DateTime.parse(fechaActividadContTxtAct.text),//objDatumCrmLead?.dateDeadline ?? DateTime.now(),
                                                      userId: objDatumCrmLead?.userId!.id ?? 0,
                                                      userCreateId: objDatumCrmLead?.userId!.id ?? 0,
                                                      resId: objDatumCrmLead?.id ?? 0,
                                                      actId: 0,
                                                      workingTime: tiempo,
                                                      summary: '',
                                                      leadName: objDatumCrmLead?.name ?? '',
                                                      leadPhone: objDatumCrmLead?.phone ?? '',                                                      
                                                      contactName: objDatumCrmLead?.contactName ?? '',
                                                      leadEmail: objDatumCrmLead?.emailFrom ?? '',
                                                      scheduleTime: horaGuardarAct
                                                    );
            
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
                                                            mensajeMostrarDialogCargando: 'la nueva actividad para el prospecto.',
                                                          ),
                                                        ]
                                                      ),
                                                    );
                                    
                                                    ActividadRegistroResponseModel? objResp = await ActivitiesService().registroActividades(objReqst);

                                                    if(objResp != null){
                                                      String respuestaReg = objResp.result.mensaje;
                                                      int estado = objResp.result.estado;
                                                      String gifRespuesta = '';
              
                                                      //ignore: use_build_context_synchronously
                                                      context.pop();
              
                                                      if(estado == 200){
                                                        gifRespuesta = 'assets/gifs/exito.gif';
                                                      } else {
                                                        gifRespuesta = 'assets/gifs/gifErrorBlanco.gif';
                                                      }
              
                                                      //ignore:use_build_context_synchronously
                                                      context.pop();                                                      

                                                      showDialog(
                                                        //ignore:use_build_context_synchronously
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Container(
                                                              color: Colors.transparent,
                                                              height: size.height * 0.17,
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  
                                                                  Container(
                                                                    color: Colors.transparent,
                                                                    height: size.height * 0.09,
                                                                    child: Image.asset(gifRespuesta),
                                                                  ),
                                      
                                                                  Container(
                                                                    color: Colors.transparent,
                                                                    width: size.width * 0.95,
                                                                    height: size.height * 0.08,
                                                                    alignment: Alignment.center,
                                                                    child: AutoSizeText(
                                                                      respuestaReg,
                                                                      maxLines: 2,
                                                                      minFontSize: 2,
                                                                    ),
                                                                  )
                                                                ],
                                                              )
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    
                                                      //POR AQUÍ AEVG
                                                      //ignore:use_build_context_synchronously
                                                      context.pop();

                                                      //ignore:use_build_context_synchronously
                                                      context.pop();

                                                      //ignore:use_build_context_synchronously
                                                      context.push(objRutasGen.rutaPlanActivConActiv);
                                                    }
                                                    else{
                                                      //ignore:use_build_context_synchronously
                                                      context.pop();                                                      

                                                      showDialog(
                                                        //ignore:use_build_context_synchronously
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Container(
                                                              color: Colors.transparent,
                                                              height: size.height * 0.17,
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  
                                                                  Container(
                                                                    color: Colors.transparent,
                                                                    height: size.height * 0.09,
                                                                    child: Image.asset('assets/gifs/gifErrorBlanco.gif'),
                                                                  ),
                                      
                                                                  Container(
                                                                    color: Colors.transparent,
                                                                    width: size.width * 0.95,
                                                                    height: size.height * 0.08,
                                                                    alignment: Alignment.center,
                                                                    child: const AutoSizeText(
                                                                      'Error al crear una nueva actividad',
                                                                      maxLines: 2,
                                                                      minFontSize: 2,
                                                                    ),
                                                                  )
                                                                ],
                                                              )
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: ColorsApp().celeste,
                                                  ),
                                                  child: const Text(
                                                    'Crear Actividad',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            });
                      },
                      child: const Icon(
                        Icons.document_scanner_sharp,
                        color: Colors.white,
                        size: 24,
                      )
                    ),
                  SizedBox(
                    width: size.width * 0.04,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (_isButtonPressed) return;

                      //ignore:use_build_context_synchronously
                      context.pop();
/*
                      try{
                        //ignore:use_build_context_synchronously
                        context.pop();
                      }
                      catch(_){
                        var sfs =0;
                      }
                      */

                      //ignore:use_build_context_synchronously
                      context.push(objRutasGen.rutaPlanActivConActiv);
                    },
                    child: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 23,
                    )
                  ),
                  SizedBox(
                    width: size.width * 0.04,
                  ),

                  Tooltip(
                    message: 'Regresar al prospecto anterior',
                    child: GestureDetector(
                      onTap: () async {
                        if(objDatumCrmLead == null) return;
                        
                        var lstProspStr = await ProspectoTypeService().getProspectos();
                        var objLogDecode = json.decode(lstProspStr);
                    
                        ProspectoResponseModel apiResponse = ProspectoResponseModel.fromJson(objLogDecode);
                    
                        List<DatumCrmLead> prospectosFiltradosNext = apiResponse.result.data.crmLead.data;                      
                    
                        for(int i = 0; i < prospectosFiltradosNext.length; i++){
                          if(prospectosFiltradosNext[i].id == objDatumCrmLead!.id) {
                            try{
                              objDatumCrmLead = prospectosFiltradosNext[i - 1];
                            }
                            catch(_){
                              objDatumCrmLead = prospectosFiltradosNext[prospectosFiltradosNext.length - 1];
                            }
                    
                            //ignore:use_build_context_synchronously
                            context.pop();
                    
                            //ignore:use_build_context_synchronously
                            context.push(objRutasGen.rutaPlanActivConActiv);
                    
                            return;
                          }
                        }
                    
                      },
                      child: const Icon(
                        Icons.keyboard_double_arrow_left_sharp,
                        color: Colors.white,
                        size: 23,
                      )
                    ),
                  ),

                  SizedBox(
                    width: size.width * 0.025,
                  ),

                  Tooltip(
                    message: 'Ir al siguiente prospecto',
                    child: GestureDetector(
                      onTap: () async {
                        if(objDatumCrmLead == null) return;
                        
                        var lstProspStr = await ProspectoTypeService().getProspectos();
                        var objLogDecode = json.decode(lstProspStr);
                    
                        ProspectoResponseModel apiResponse = ProspectoResponseModel.fromJson(objLogDecode);
                    
                        List<DatumCrmLead> prospectosFiltradosNext = apiResponse.result.data.crmLead.data;                      
                    
                        for(int i = 0; i < prospectosFiltradosNext.length; i++){
                          if(prospectosFiltradosNext[i].id == objDatumCrmLead!.id) {
                            try{
                              objDatumCrmLead = prospectosFiltradosNext[i + 1];
                            }
                            catch(_){
                              objDatumCrmLead = prospectosFiltradosNext[0];
                            }
                    
                            //ignore:use_build_context_synchronously
                            context.pop();
                    
                            //ignore:use_build_context_synchronously
                            context.push(objRutasGen.rutaPlanActivConActiv);
                    
                            return;
                          }
                        }
                    
                      },
                      child: const Icon(
                        Icons.keyboard_double_arrow_right_sharp,
                        color: Colors.white,
                        size: 25,
                      )
                    ),
                  ),

                  SizedBox(
                    width: size.width * 0.04,
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.blue.shade800,
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(width: size.width * 0.015),
                          Row(
                            children: [

                              RatingStarsWidget(
                                initialRating: prioridadPrsp,//aquí reemplazar con valor dinámico
                                onRatingChanged: (valor) async {

                                  prioridadPrsp = valor;
                                  objDatumCrmLead!.priority = '$valor';

                                  for(int i = 0; i < prospectosFiltrados.length; i++){
                                    if(prospectosFiltrados[i].id == objDatumCrmLead!.id){
                                      prospectosFiltrados[i].priority = '$valor';
                                    }                                    
                                  }

                                  showDialog(
                                    //ignore: use_build_context_synchronously
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => SimpleDialog(
                                      alignment: Alignment.center,
                                      children: [
                                        SimpleDialogCargando(
                                          null,
                                          mensajeMostrar: 'Estamos cambiando',
                                          mensajeMostrarDialogCargando: 'la prioridad del prospecto',
                                        ),
                                      ]
                                    ),
                                  );
                          
                                  ResponseGenericModel? objResp = await ProspectoTypeService().editaPrioridadProspecto(valor, objDatumCrmLead?.id ?? 0);
                                  
                                  if(objResp != null){
                                    String respuestaReg = objResp.result.mensaje;
                                    int estado = objResp.result.estado;
                                    String gifRespuesta = '';

                                    if(estado == 200){
                                      gifRespuesta = 'assets/gifs/exito.gif';
                                    } else {
                                      gifRespuesta = 'assets/gifs/gifErrorBlanco.gif';
                                    }

                                    //ignore:use_build_context_synchronously
                                    context.pop();

                                    showDialog(
                                      //ignore:use_build_context_synchronously
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Container(
                                            color: Colors.transparent,
                                            height: size.height * 0.17,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                
                                                Container(
                                                  color: Colors.transparent,
                                                  height: size.height * 0.09,
                                                  child: Image.asset(gifRespuesta),
                                                ),
                    
                                                Container(
                                                  color: Colors.transparent,
                                                  width: size.width * 0.95,
                                                  height: size.height * 0.08,
                                                  alignment: Alignment.center,
                                                  child: AutoSizeText(
                                                    respuestaReg,
                                                    maxLines: 2,
                                                    minFontSize: 2,
                                                  ),
                                                )
                                              ],
                                            )
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                context.pop();
                                                
                                                listaProspectosKey.currentState?.refreshDataProsp();
                                                /*
                                                listaProspectosKey.currentState!.setState(() {
        
                                                });
                                                */
                                              },
                                              child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  
                                  }
                                  else{
                                    //ignore:use_build_context_synchronously
                                    context.pop();

                                    showDialog(
                                      //ignore:use_build_context_synchronously
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Container(
                                            color: Colors.transparent,
                                            height: size.height * 0.17,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                
                                                Container(
                                                  color: Colors.transparent,
                                                  height: size.height * 0.09,
                                                  child: Image.asset('assets/gifs/gifErrorBlanco.gif'),
                                                ),
                    
                                                Container(
                                                  color: Colors.transparent,
                                                  width: size.width * 0.95,
                                                  height: size.height * 0.08,
                                                  alignment: Alignment.center,
                                                  child: const AutoSizeText(
                                                    'Error al crear una nueva actividad',
                                                    maxLines: 2,
                                                    minFontSize: 2,
                                                  ),
                                                )
                                              ],
                                            )
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                              
                              SizedBox(width: size.width * 0.267),

                              Container(
                                color: Colors.transparent,
                                width: size.width * 0.35,
                                height: size.height * 0.07,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    if(objDatumCrmLead != null && objDatumCrmLead!.stageId.name.toLowerCase() != 'ganado')
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
  
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
                                                  mensajeMostrarDialogCargando: 'motivo de pérdida del prospecto.',
                                                ),
                                              ]
                                            ),
                                          );
                          

                                          ResponseGenericModel? objResp = await ProspectoTypeService().editaEstadoProspecto(false, true, 0, objDatumCrmLead?.id ?? 0);

                                          if(objResp != null){
                                            String respuestaReg = objResp.result.mensaje;
                                            int estado = objResp.result.estado;
                                            String gifRespuesta = '';
    
                                            //ignore: use_build_context_synchronously
                                            context.pop();
    
                                            if(estado == 200){
                                              gifRespuesta = 'assets/gifs/exito.gif';
                                            } else {
                                              gifRespuesta = 'assets/gifs/gifErrorBlanco.gif';
                                            }
    
                                            //ignore:use_build_context_synchronously
                                            context.pop();                                                      

                                            showDialog(
                                              //ignore:use_build_context_synchronously
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Container(
                                                    color: Colors.transparent,
                                                    height: size.height * 0.17,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        
                                                        Container(
                                                          color: Colors.transparent,
                                                          height: size.height * 0.09,
                                                          child: Image.asset(gifRespuesta),
                                                        ),
                            
                                                        Container(
                                                          color: Colors.transparent,
                                                          width: size.width * 0.95,
                                                          height: size.height * 0.08,
                                                          alignment: Alignment.center,
                                                          child: AutoSizeText(
                                                            respuestaReg,
                                                            maxLines: 2,
                                                            minFontSize: 2,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          
                                            //POR AQUÍ AEVG
                                            //ignore:use_build_context_synchronously
                                            context.pop();

                                            try {
                                              //ignore:use_build_context_synchronously
                                            context.pop();
                                            }
                                            catch(_){}

                                            //ignore:use_build_context_synchronously
                                            context.push(objRutasGen.rutaPlanActivConActiv);
                                          }
                                          else{
                                            //ignore:use_build_context_synchronously
                                            context.pop();                                                      

                                            showDialog(
                                              //ignore:use_build_context_synchronously
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Container(
                                                    color: Colors.transparent,
                                                    height: size.height * 0.17,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        
                                                        Container(
                                                          color: Colors.transparent,
                                                          height: size.height * 0.09,
                                                          child: Image.asset('assets/gifs/gifErrorBlanco.gif'),
                                                        ),
                            
                                                        Container(
                                                          color: Colors.transparent,
                                                          width: size.width * 0.95,
                                                          height: size.height * 0.08,
                                                          alignment: Alignment.center,
                                                          child: const AutoSizeText(
                                                            'Error al crear una nueva actividad',
                                                            maxLines: 2,
                                                            minFontSize: 2,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
/*
                                          FocusScope.of(context).unfocus();
                                          Navigator.pop(context);
                                          */
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text(
                                          'Ganado',
                                          style: TextStyle(fontSize: 16, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    
                                    SizedBox(width: size.width * 0.015),
                                    
                                    if(objDatumCrmLead != null && objDatumCrmLead!.stageId.name.toLowerCase() != 'perdido')
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          muestraMotivoPerdida = false;

                                          motPerdSelect = lstMotivoPerdida.first;

                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return StatefulBuilder(
                                                builder: (context, setStateDialog) => Dialog(
                                                  insetPadding: const EdgeInsets.all(20),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(16),
                                                  ),
                                                  child: SizedBox(
                                                    width: size.width * 0.92,
                                                    height: !muestraMotivoPerdida
                                                        ? size.height * 0.28
                                                        : size.height * 0.38,
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
                                                                'Registra pérdida del prospecto',
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        SizedBox(height: size.height * 0.02),

                                                        Container(
                                                          color: Colors.transparent,
                                                          width: size.width * 0.92,
                                                          height: size.height * 0.1,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Container(
                                                                color: Colors.transparent,
                                                                width: size.width * 0.82,
                                                                height: size.height * 0.1,
                                                                child: DropdownButtonFormField<String>(
                                                                  decoration: const InputDecoration(
                                                                    border: OutlineInputBorder(),
                                                                    labelText: 'Seleccione motivo de pérdida...',
                                                                  ),
                                                                  value: motPerdSelect.isEmpty ? null : motPerdSelect,
                                                                  items: lstMotivoPerdida
                                                                      .map(
                                                                        (activityPrsp) => DropdownMenuItem(
                                                                          value: activityPrsp,
                                                                          child: Text(
                                                                            activityPrsp,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            maxLines: 1,
                                                                            style: const TextStyle(fontSize: 12),
                                                                          ),
                                                                        ),
                                                                      )
                                                                      .toList(),
                                                                  onChanged: (String? newValue) {
                                                                    setStateDialog(() {
                                                                      if (newValue != null &&
                                                                          newValue.toLowerCase() == 'otros') {
                                                                        muestraMotivoPerdida = true;
                                                                      } else {
                                                                        muestraMotivoPerdida = false;
                                                                      }
                                                                      motPerdSelect = newValue ?? '';
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        if (muestraMotivoPerdida)
                                                          Container(
                                                            color: Colors.transparent,
                                                            width: size.width * 0.92,
                                                            height: size.height * 0.1,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Container(
                                                                  color: Colors.transparent,
                                                                  width: size.width * 0.82,
                                                                  height: size.height * 0.1,
                                                                  child: TextFormField(
                                                                    controller: motivoPerdidaTxtController,
                                                                    maxLines: 5,
                                                                    onTapOutside: (event) {
                                                                      FocusScope.of(context).unfocus();
                                                                    },
                                                                    decoration: InputDecoration(
                                                                      hintText: 'Escribe el motivo aquí...',
                                                                      border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      filled: true,
                                                                      fillColor: Colors.transparent,
                                                                    ),
                                                                    validator: (value) {
                                                                      if (value == null || value.trim().isEmpty) {
                                                                        return 'Por favor ingresa una observación';
                                                                      }
                                                                      return null;
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                        SizedBox(height: size.height * 0.01),

                                                        Container(
                                                          color: Colors.transparent,
                                                          width: size.width * 0.9,
                                                          height: size.height * 0.07,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                                                child: ElevatedButton.icon(
                                                                  onPressed: () {
                                                                    FocusScope.of(context).unfocus();
                                                                    Navigator.pop(context);
                                                                  },
                                                                  icon: const Icon(
                                                                    Icons.close,
                                                                    color: Colors.white,
                                                                  ),
                                                                  label: const Text(
                                                                    'Cerrar',
                                                                    style: TextStyle(color: Colors.white),
                                                                  ),
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: Colors.grey,
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                                                child: ElevatedButton.icon(
                                                                  onPressed: () async {
                            
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
                                                                            mensajeMostrarDialogCargando: 'motivo de pérdida del prospecto.',
                                                                          ),
                                                                        ]
                                                                      ),
                                                                    );
                                                    
                                                                    int idMotPerd = 0;

                                                                    for(int i = 0; i < motivosPerdida.length; i++){
                                                                      if(motPerdSelect == motivosPerdida[i].name){
                                                                        idMotPerd = motivosPerdida[i].id;
                                                                        break;
                                                                      }
                                                                    }

                                                                    ResponseGenericModel? objResp = await ProspectoTypeService().editaEstadoProspecto(false, false, idMotPerd, objDatumCrmLead?.id ?? 0);

                                                                    if(objResp != null){
                                                                      String respuestaReg = objResp.result.mensaje;
                                                                      int estado = objResp.result.estado;
                                                                      String gifRespuesta = '';
                              
                                                                      //ignore: use_build_context_synchronously
                                                                      context.pop();
                              
                                                                      if(estado == 200){
                                                                        gifRespuesta = 'assets/gifs/exito.gif';
                                                                      } else {
                                                                        gifRespuesta = 'assets/gifs/gifErrorBlanco.gif';
                                                                      }
                              
                                                                      //ignore:use_build_context_synchronously
                                                                      context.pop();                                                      

                                                                      showDialog(
                                                                        //ignore:use_build_context_synchronously
                                                                        context: context,
                                                                        builder: (BuildContext context) {
                                                                          return AlertDialog(
                                                                            title: Container(
                                                                              color: Colors.transparent,
                                                                              height: size.height * 0.17,
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  
                                                                                  Container(
                                                                                    color: Colors.transparent,
                                                                                    height: size.height * 0.09,
                                                                                    child: Image.asset(gifRespuesta),
                                                                                  ),
                                                      
                                                                                  Container(
                                                                                    color: Colors.transparent,
                                                                                    width: size.width * 0.95,
                                                                                    height: size.height * 0.08,
                                                                                    alignment: Alignment.center,
                                                                                    child: AutoSizeText(
                                                                                      respuestaReg,
                                                                                      maxLines: 2,
                                                                                      minFontSize: 2,
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              )
                                                                            ),
                                                                            actions: [
                                                                              TextButton(
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                  //ignore:use_build_context_synchronously
                                                                                  context.pop();
                                                                                },
                                                                                child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      );                                                                    

                                                                    }
                                                                    else{
                                                                      //ignore:use_build_context_synchronously
                                                                      context.pop();                                                      

                                                                      showDialog(
                                                                        //ignore:use_build_context_synchronously
                                                                        context: context,
                                                                        builder: (BuildContext context) {
                                                                          return AlertDialog(
                                                                            title: Container(
                                                                              color: Colors.transparent,
                                                                              height: size.height * 0.17,
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  
                                                                                  Container(
                                                                                    color: Colors.transparent,
                                                                                    height: size.height * 0.09,
                                                                                    child: Image.asset('assets/gifs/gifErrorBlanco.gif'),
                                                                                  ),
                                                      
                                                                                  Container(
                                                                                    color: Colors.transparent,
                                                                                    width: size.width * 0.95,
                                                                                    height: size.height * 0.08,
                                                                                    alignment: Alignment.center,
                                                                                    child: const AutoSizeText(
                                                                                      'Error al crear una nueva actividad',
                                                                                      maxLines: 2,
                                                                                      minFontSize: 2,
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              )
                                                                            ),
                                                                            actions: [
                                                                              TextButton(
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
                                                                    }

                                                                  },
                                                                  icon: const Icon(
                                                                    Icons.save,
                                                                    color: Colors.white,
                                                                  ),
                                                                  label: const Text(
                                                                    'Confirmar',
                                                                    style: TextStyle(color: Colors.white),
                                                                  ),
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: Colors.blueAccent,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );

                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text(
                                          'Perdido',
                                          style: TextStyle(fontSize: 16, color: Colors.white),
                                        ),
                                      ),
                                    ),

                                    if(objDatumCrmLead != null && objDatumCrmLead!.stageId.name.toLowerCase() == 'perdido')
                                    Container(
                                      width: size.width * 0.165,
                                      height: size.height * 0.062,
                                      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 15),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent, // Background color
                                        borderRadius: BorderRadius.circular(10.0), // Rounded corners
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      child: GestureDetector(
                                        onTap: () async {
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
                                                  mensajeMostrarDialogCargando: 'motivo de pérdida del prospecto.',
                                                ),
                                              ]
                                            ),
                                          );
                          
                                          ResponseGenericModel? objResp = await ProspectoTypeService().editaEstadoProspecto(true, false, 0, objDatumCrmLead?.id ?? 0);

                                          if(objResp != null){
                                            String respuestaReg = objResp.result.mensaje;
                                            int estado = objResp.result.estado;
                                            String gifRespuesta = '';
    
                                            //ignore: use_build_context_synchronously
                                            context.pop();
    
                                            if(estado == 200){
                                              gifRespuesta = 'assets/gifs/exito.gif';
                                            } else {
                                              gifRespuesta = 'assets/gifs/gifErrorBlanco.gif';
                                            }
    
                                            //ignore:use_build_context_synchronously
                                            context.pop();                                                      

                                            showDialog(
                                              //ignore:use_build_context_synchronously
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Container(
                                                    color: Colors.transparent,
                                                    height: size.height * 0.17,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        
                                                        Container(
                                                          color: Colors.transparent,
                                                          height: size.height * 0.09,
                                                          child: Image.asset(gifRespuesta),
                                                        ),
                            
                                                        Container(
                                                          color: Colors.transparent,
                                                          width: size.width * 0.95,
                                                          height: size.height * 0.08,
                                                          alignment: Alignment.center,
                                                          child: AutoSizeText(
                                                            respuestaReg,
                                                            maxLines: 2,
                                                            minFontSize: 2,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                        //ignore:use_build_context_synchronously
                                                        context.pop();
                                                      },
                                                      child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );                                                                    

                                          }
                                          else{
                                            //ignore:use_build_context_synchronously
                                            context.pop();                                                      

                                            showDialog(
                                              //ignore:use_build_context_synchronously
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Container(
                                                    color: Colors.transparent,
                                                    height: size.height * 0.17,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        
                                                        Container(
                                                          color: Colors.transparent,
                                                          height: size.height * 0.09,
                                                          child: Image.asset('assets/gifs/gifErrorBlanco.gif'),
                                                        ),
                            
                                                        Container(
                                                          color: Colors.transparent,
                                                          width: size.width * 0.95,
                                                          height: size.height * 0.08,
                                                          alignment: Alignment.center,
                                                          child: const AutoSizeText(
                                                            'Error al crear una nueva actividad',
                                                            maxLines: 2,
                                                            minFontSize: 2,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: const Text(
                                          'Recuperar',
                                          style: TextStyle(fontSize: 12, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  color: tabAccionesAct == 0
                                      ? Colors.white
                                      : Colors.blue.shade800,
                                  child: Center(
                                    child: TextButton(
                                      onPressed: () {
                                        tabAccionesAct = 0;
                                        setState(() {});
                                      },
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            color: tabAccionesAct == 0
                                                ? Colors.blue.shade800
                                                : Colors.white,
                                          ),
                                          Text(
                                            'Acciones',
                                            style: TextStyle(
                                              color: tabAccionesAct == 0
                                                  ? Colors.blue.shade800
                                                  : Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: tabAccionesAct == 1
                                      ? Colors.white
                                      : Colors.blue.shade800,
                                  child: Center(
                                    child: TextButton(
                                      onPressed: () async {
                                        tabAccionesAct = 1;

                                        if(objDatumCrmLead != null){
                                          try{
                                            const storage = FlutterSecureStorage();

                                            String resPartner = await storage.read(key: 'RespuestaClientes') ?? '';

                                            String ekClasifProspStr = await storage.read(key: 'EkClasifProsp') ?? '';
                                            String ekResCountryCantonStr = await storage.read(key: 'EkResCountryCantonProsp') ?? '';
                                            String ekResRegionStr = await storage.read(key: 'EkResRegionProsp') ?? '';
                                            String ekResSectorStr = await storage.read(key: 'EkResSectorProsp') ?? '';
                                            String ekResCityStr = await storage.read(key: 'EkResCountryCityProsp') ?? '';

                                            ResPartnerAppModel apiResponse = ResPartnerAppModel.fromRawJson(resPartner);
                                            EkClassification  ekClassificationFin = EkClassification.fromRawJson(ekClasifProspStr);
                                            CantonModel  ekCantonFin = CantonModel.fromRawJson(ekResCountryCantonStr);
                                            RegionModel  ekRegionModelFin = RegionModel.fromRawJson(ekResRegionStr);
                                            SectorModel  ekSectorFin = SectorModel.fromRawJson(ekResSectorStr);
                                            CountryCity  ekCityFin = CountryCity.fromRawJson(ekResCityStr);
                                            
                                            var objFiltrado = apiResponse.data.firstWhere((x) => x.id == objDatumCrmLead!.partnerId.id,);
                                            var objClasif = ekClassificationFin.data.firstWhere((x) => x.id == objFiltrado.ekClasificationId.id);
                                            var objCiudad = ekCityFin.data.firstWhere((x) => x.id == objFiltrado.cityId.id);
                                            var objCanton = ekCantonFin.data.firstWhere((x) => x.id == objFiltrado.ekResCountryCantonId.id);
                                            var objRegion = ekRegionModelFin.data.firstWhere((x) => x.id == objFiltrado.ekResRegionId.id);
                                            var objSector = ekSectorFin.data.firstWhere((x) => x.id == objFiltrado.ekResSectorId.id);

                                            channelProsp = objFiltrado.channelId.name ?? '';

                                            clasificacionPrsp = objClasif.name ?? '';
                                            ciudadPrsp = objCiudad.name ?? '';
                                            regionPrsp = objRegion.name ?? '';
                                            cantonPrsp = objCanton.name ?? '';
                                            sectorPrsp = objSector.name ?? '';
                                            tradeNameProsp = objFiltrado.tradeName ?? '';
                                          }
                                          catch(_){

                                          }
                                        }

                                        setState(() {});
                                      },
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.grid_on_outlined,
                                            color: tabAccionesAct == 1
                                                ? Colors.blue.shade800
                                                : Colors.white,
                                          ),
                                          Text(
                                            'Detalles',
                                            style: TextStyle(
                                              //color: Colors.purple.shade700,
                                              color: tabAccionesAct == 1
                                                  ? Colors.blue.shade800
                                                  : Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: tabAccionesAct == 2
                                      ? Colors.white
                                      : Colors.blue.shade800,
                                  child: Center(
                                    child: TextButton(
                                      onPressed: () async {
                                        tabAccionesAct = 2;

                                        if(objDatumCrmLead != null){
                                          try{
                                            const storage = FlutterSecureStorage();

                                            String resPartner = await storage.read(key: 'RespuestaClientes') ?? '';

                                            String ekClasifProspStr = await storage.read(key: 'EkClasifProsp') ?? '';
                                            String ekResCountryCantonStr = await storage.read(key: 'EkResCountryCantonProsp') ?? '';
                                            String ekResRegionStr = await storage.read(key: 'EkResRegionProsp') ?? '';
                                            String ekResSectorStr = await storage.read(key: 'EkResSectorProsp') ?? '';
                                            String ekResCityStr = await storage.read(key: 'EkResCountryCityProsp') ?? '';

                                            ResPartnerAppModel apiResponse = ResPartnerAppModel.fromRawJson(resPartner);
                                            EkClassification  ekClassificationFin = EkClassification.fromRawJson(ekClasifProspStr);
                                            CantonModel  ekCantonFin = CantonModel.fromRawJson(ekResCountryCantonStr);
                                            RegionModel  ekRegionModelFin = RegionModel.fromRawJson(ekResRegionStr);
                                            SectorModel  ekSectorFin = SectorModel.fromRawJson(ekResSectorStr);
                                            CountryCity  ekCityFin = CountryCity.fromRawJson(ekResCityStr);
                                            
                                            var objFiltrado = apiResponse.data.firstWhere((x) => x.id == objDatumCrmLead!.partnerId.id,);
                                            var objClasif = ekClassificationFin.data.firstWhere((x) => x.id == objFiltrado.ekClasificationId.id);
                                            var objCiudad = ekCityFin.data.firstWhere((x) => x.id == objFiltrado.cityId.id);
                                            var objCanton = ekCantonFin.data.firstWhere((x) => x.id == objFiltrado.ekResCountryCantonId.id);
                                            var objRegion = ekRegionModelFin.data.firstWhere((x) => x.id == objFiltrado.ekResRegionId.id);
                                            var objSector = ekSectorFin.data.firstWhere((x) => x.id == objFiltrado.ekResSectorId.id);

                                            channelProsp = objFiltrado.channelId.name ?? '';

                                            clasificacionPrsp = objClasif.name ?? '';
                                            ciudadPrsp = objCiudad.name ?? '';
                                            regionPrsp = objRegion.name ?? '';
                                            cantonPrsp = objCanton.name ?? '';
                                            sectorPrsp = objSector.name ?? '';
                                            tradeNameProsp = objFiltrado.tradeName ?? '';
                                          }
                                          catch(_){

                                          }
                                        }

                                        setState(() {});
                                      },
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.book,
                                            color: tabAccionesAct == 2
                                                ? Colors.blue.shade800
                                                : Colors.white,
                                          ),
                                          Text(
                                            'Notas Int.',
                                            style: TextStyle(
                                              //color: Colors.purple.shade700,
                                              color: tabAccionesAct == 2
                                                  ? Colors.blue.shade800
                                                  : Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: tabAccionesAct == 3
                                      ? Colors.white
                                      : Colors.blue.shade800,
                                  child: Center(
                                    child: TextButton(
                                      onPressed: () async {
                                        tabAccionesAct = 3;

                                        if(objDatumCrmLead != null){
                                          try{
                                            const storage = FlutterSecureStorage();

                                            String resPartner = await storage.read(key: 'RespuestaClientes') ?? '';

                                            String ekClasifProspStr = await storage.read(key: 'EkClasifProsp') ?? '';
                                            String ekResCountryCantonStr = await storage.read(key: 'EkResCountryCantonProsp') ?? '';
                                            String ekResRegionStr = await storage.read(key: 'EkResRegionProsp') ?? '';
                                            String ekResSectorStr = await storage.read(key: 'EkResSectorProsp') ?? '';
                                            String ekResCityStr = await storage.read(key: 'EkResCountryCityProsp') ?? '';

                                            ResPartnerAppModel apiResponse = ResPartnerAppModel.fromRawJson(resPartner);
                                            EkClassification  ekClassificationFin = EkClassification.fromRawJson(ekClasifProspStr);
                                            CantonModel  ekCantonFin = CantonModel.fromRawJson(ekResCountryCantonStr);
                                            RegionModel  ekRegionModelFin = RegionModel.fromRawJson(ekResRegionStr);
                                            SectorModel  ekSectorFin = SectorModel.fromRawJson(ekResSectorStr);
                                            CountryCity  ekCityFin = CountryCity.fromRawJson(ekResCityStr);
                                            
                                            var objFiltrado = apiResponse.data.firstWhere((x) => x.id == objDatumCrmLead!.partnerId.id,);
                                            var objClasif = ekClassificationFin.data.firstWhere((x) => x.id == objFiltrado.ekClasificationId.id);
                                            var objCiudad = ekCityFin.data.firstWhere((x) => x.id == objFiltrado.cityId.id);
                                            var objCanton = ekCantonFin.data.firstWhere((x) => x.id == objFiltrado.ekResCountryCantonId.id);
                                            var objRegion = ekRegionModelFin.data.firstWhere((x) => x.id == objFiltrado.ekResRegionId.id);
                                            var objSector = ekSectorFin.data.firstWhere((x) => x.id == objFiltrado.ekResSectorId.id);

                                            channelProsp = objFiltrado.channelId.name ?? '';

                                            clasificacionPrsp = objClasif.name ?? '';
                                            ciudadPrsp = objCiudad.name ?? '';
                                            regionPrsp = objRegion.name ?? '';
                                            cantonPrsp = objCanton.name ?? '';
                                            sectorPrsp = objSector.name ?? '';
                                            tradeNameProsp = objFiltrado.tradeName ?? '';
                                          }
                                          catch(_){

                                          }
                                        }

                                        setState(() {});
                                      },
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.history,
                                            color: tabAccionesAct == 3
                                                ? Colors.blue.shade800
                                                : Colors.white,
                                          ),
                                          Text(
                                            'Histórico',
                                            style: TextStyle(
                                              //color: Colors.purple.shade700,
                                              color: tabAccionesAct == 3
                                                  ? Colors.blue.shade800
                                                  : Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (tabAccionesAct == 0) const PlanActiv(null),
                    if (tabAccionesAct == 1)
                      sectionTitle(Icons.info, "Información General"),
                    if (tabAccionesAct == 1) infoRowAct("Razón Social", objDatumCrmLead?.partnerId.name ?? '-----', size),
                    if (tabAccionesAct == 1)
                      infoRowAct("Nombre Comercial", tradeNameProsp, size),
                    if (tabAccionesAct == 1) infoRowAct("Clasificación", clasificacionPrsp, size),
                    if (tabAccionesAct == 1) infoRowAct("Canal", channelProsp, size),
                    if (tabAccionesAct == 1) infoRowAct("Dirección", objDatumCrmLead?.street != null && objDatumCrmLead?.street2 != null ? '${objDatumCrmLead?.street} ${objDatumCrmLead?.street2}' : objDatumCrmLead?.street != null ? '${objDatumCrmLead?.street}' : '-----', size),
                    if (tabAccionesAct == 1)
                      sectionTitleAct(Icons.place, "Territorio"),
                    if (tabAccionesAct == 1) infoRowAct("Estado", objDatumCrmLead?.stageId.name ?? '-----', size),
                    if (tabAccionesAct == 1) infoRowAct("Ciudad", ciudadPrsp, size),
                    if (tabAccionesAct == 1) infoRowAct("Cantón", cantonPrsp, size),
                    if (tabAccionesAct == 1) infoRowAct("Región", regionPrsp, size),
                    if (tabAccionesAct == 1) infoRowAct("Sector", sectorPrsp, size),
                    if (tabAccionesAct == 1)
                      sectionTitleAct(Icons.monetization_on, "Precios y Ventas"),
                    if (tabAccionesAct == 1) infoRowAct("Ingreso esperado", "\$${objDatumCrmLead?.expectedRevenue.toStringAsFixed(2)}", size),
                    if (tabAccionesAct == 1) infoRowAct("Probabilidad", "${probCalculada.toStringAsFixed(0)}%", size),
                    if(tabAccionesAct == 2) const FrmNotasInternasView(),
                    if (tabAccionesAct == 3) const HistoricoActByProspView(null),                    
                  ],
                ),
              ),
            ),
          );
      
      }
    );
    
  }
}

Widget sectionTitleAct(IconData icon, String title) {
  return Container(
    padding: const EdgeInsets.all(10.0),
    color: Colors.blue.shade900,
    width: double.infinity,
    child: Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget infoRowAct(String label, String value, Size size) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: size.width * 0.45,
          height: size.height * 0.04,
          color: Colors.transparent,
          alignment: Alignment.centerLeft,
          child: Text(
            "$label:",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Container(
          width: size.width * 0.43,
          height: size.height * 0.04,
          color: Colors.transparent,
          alignment: Alignment.centerRight,
          child: Text(value, style: const TextStyle(fontSize: 16, ), overflow: TextOverflow.ellipsis, maxLines: 1,)
        ),
      ],
    ),
  );
}

class PlanActiv extends StatefulWidget {

  const PlanActiv(Key? key) : super(key: key);

  @override
  PlanActivStateTwo createState() => PlanActivStateTwo();
}

class PlanActivStateTwo extends State<PlanActiv> {

  static const platformPhone = MethodChannel('call_channel');

  static const platformEmail = MethodChannel('email_channel');

  bool muestraActividadesDiarias = true;

  void iniciarCronometro() {
    if (!_corriendoAct) {
      _corriendoAct = true;
      _timerAct = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _segundosAct++;
        });
      });
    }
  }

  void detenerCronometro() {
    if (_corriendoAct) {
      _timerAct?.cancel();
      _corriendoAct = false;
    }
  }

  void reiniciarCronometro() {
    _timerAct?.cancel();
    setState(() {
      _segundosAct = 0;
      _corriendoAct = false;
    });
  }

  ColorsApp objColorsApp = ColorsApp();

  @override
  void initState() {
    super.initState();    
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      
      await cargaActividadesByCliente();
      await cargaTipoActividades();
      await cargaMotivosPerdida();

      //ignore: use_build_context_synchronously
      final gnrBloc = Provider.of<GenericBloc>(context, listen: false);
      gnrBloc.setMuestraCarga(false);

    });

  }

  Future<void> cargaActividadesByCliente() async {
    try {
      if(muestraActividadesDiarias){
        final gnrBloc = Provider.of<GenericBloc>(context, listen: false);
        gnrBloc.setIniciaCarga(true);
        //lstTipoActividades = [];
        lstActividadesDiariasByProspecto = [];
        actividadesFilAgendaPlanAct = [];
        
        ActivitiesPageModel? objRspFinal = await ActivitiesService().getActivitiesDiariasByProspecto(null, objDatumCrmLead?.id ?? 0);

        if(objRspFinal != null){
          lstActividadesDiariasByProspecto = objRspFinal.activities.data;
          actividadesFilAgendaPlanAct = objRspFinal.objMailAct.data;
          
          objDatumCrmLead = objRspFinal.lead;        
        }

        gnrBloc.setIniciaCarga(false);
      }
      else{
        final gnrBloc = Provider.of<GenericBloc>(context, listen: false);
        gnrBloc.setIniciaCarga(true);

        DateTime now = DateTime.now();

        // Primer día del mes actual
        DateTime firstDay = DateTime(now.year, now.month, 1);

        // Último día del mes actual
        DateTime lastDay = DateTime(now.year, now.month + 1, 0);

        // Lista con ambos registros
        List<DateTime> fechas = [firstDay, lastDay];
        
        ActivitiesPageModel? objRspFinal = await ActivitiesService().getActivitiesDiariasByProspecto(fechas, objDatumCrmLead?.id ?? 0);

        if(objRspFinal != null){
          lstActividadesDiariasByProspecto = [];
          actividadesFilAgendaPlanAct = [];
          
          lstActividadesDiariasByProspecto = objRspFinal.activities.data;
          actividadesFilAgendaPlanAct = objRspFinal.objMailAct.data;          
        }

        gnrBloc.setIniciaCarga(false);
      }
    } catch (_) {
      
    }
  }

  Future<void> cargaTipoActividades() async {
    try {
      final gnrBloc = Provider.of<GenericBloc>(context, listen: false);
      gnrBloc.setIniciaCarga(true);

      MailActivityTypeAppModel? objRspFinalTpAct;
      //lstMotivoPerdida = [];

      if(lstTipoActividades.isEmpty){
        objRspFinalTpAct = await ActivitiesService().getTipoActividadesMemoria();
      }
      else {
        lstTipoActividades = [];

        objRspFinalTpAct = await ActivitiesService().getTipoActividades();
      }

      if(objRspFinalTpAct != null){
        for(int i = 0; i < objRspFinalTpAct.data.length; i++){
          lstTipoActividades.add(objRspFinalTpAct.data[i].name ?? '');
        }

        if(actPlanSelectAct.isEmpty && lstTipoActividades.isNotEmpty){
          actPlanSelectAct = lstTipoActividades.first;
        }

        actividadesFilAgendaPlanAct = objRspFinalTpAct.data;
      }

      //lstMotivoPerdida.add('Otros');
      
      gnrBloc.setIniciaCarga(false);
      
    } catch (_) {
      
    }
  }


  Future<void> cargaMotivosPerdida() async {
    try {
      
      final gnrBloc = Provider.of<GenericBloc>(context, listen: false);
      gnrBloc.setIniciaCarga(true);

      CrmLostReasonResponse? objRspFinalTpAct;
      //lstMotivoPerdida = [];

      if(lstMotivoPerdida.isEmpty){
        objRspFinalTpAct = await ProspectoTypeService().getMotivoPerdidaProspectoMemoria();
      }
      else {
        lstMotivoPerdida = [];

        objRspFinalTpAct = await ProspectoTypeService().getMotivoPerdidaProspecto();
      }

      if(objRspFinalTpAct != null){
        motivosPerdida = objRspFinalTpAct.data;

        for(int i = 0; i < objRspFinalTpAct.data.length; i++){
          lstMotivoPerdida.add(objRspFinalTpAct.data[i].name);
        }

        if(motPerdSelect.isEmpty && lstMotivoPerdida.isNotEmpty){
          motPerdSelect = lstMotivoPerdida.first;
        }
      }

      //lstMotivoPerdida.add('Otros');
      
      gnrBloc.setIniciaCarga(false);
      
    } catch (_) {
      
    }
  }

  @override
  void dispose(){    
    muestraActividadesDiarias = true;
    super.dispose();
  }

    void makePhoneCall(String cell) async {    
    try {
      await platformPhone.invokeMethod('makePhoneCall', {'phone': cell});
    } on PlatformException catch (_) {
      //print("Error al abrir la app de llamada: ${e.message}");      
    }        
  }

  void openEmailApp(String email) async {   
    try {
      await platformEmail.invokeMethod('openEmailApp', {'email': email});
    } on PlatformException catch (_) {
      //print("Error al abrir la app de correos: ${e.message}");
    }    
  }

/*
  Future<void> abrirWhatsapp(String numeroCelular, Size size, {String? mensaje}) async {
    final String url = mensaje != null
        ? 'https://wa.me/$numeroCelular?text=${Uri.encodeComponent(mensaje)}'
        : 'https://wa.me/$numeroCelular';

    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
              color: Colors.transparent,
              height: size.height * 0.17,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  
                  Container(
                    color: Colors.transparent,
                    height: size.height * 0.09,
                    child: Image.asset('assets/gifs/gifErrorBlanco.gif'),
                  ),

                  Container(
                    color: Colors.transparent,
                    width: size.width * 0.95,
                    height: size.height * 0.08,
                    alignment: Alignment.center,
                    child: const AutoSizeText(
                      'No se pudo abrir WhatsApp. Asegúrese de tenerlo instalado.',
                      maxLines: 2,
                      minFontSize: 2,
                    ),
                  )
                ],
              )
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
              ),
            ],
          );
        },
      );
    }
  }
*/

  Future<void> abrirWhatsapp(String phoneNumber, Size size,{
    String message = ''
    //required String phoneNumber, // Ejemplo: '5215512345678' (con código de país, sin '+' ni espacios)
    //String message = '',
    //bool isBusiness = false, // Puedes usar esto si quieres una lógica más específica
  }) async {
    // Asegúrate de que el número no tenga el signo '+' inicial
    final String cleanedNumber = phoneNumber.replaceAll('+', '').replaceAll(' ', '');

    // Usamos el enlace universal (wa.me) que es el más compatible
    final String urlString = 'https://wa.me/$cleanedNumber?text=${Uri.encodeComponent(message)}';
    final Uri url = Uri.parse(urlString);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      launchWhatsAppBusinessOnly(size, phoneNumber: phoneNumber, message: message);
/*
      //throw 'No se pudo abrir WhatsApp. Asegúrate de que la URL: $urlString sea correcta y que la app esté instalada.';
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
              color: Colors.transparent,
              height: size.height * 0.17,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  
                  Container(
                    color: Colors.transparent,
                    height: size.height * 0.09,
                    child: Image.asset('assets/gifs/gifErrorBlanco.gif'),
                  ),

                  Container(
                    color: Colors.transparent,
                    width: size.width * 0.95,
                    height: size.height * 0.08,
                    alignment: Alignment.center,
                    child: const AutoSizeText(
                      'No se pudo abrir WhatsApp. Asegúrese de tenerlo instalado.',
                      maxLines: 2,
                      minFontSize: 2,
                    ),
                  )
                ],
              )
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
              ),
            ],
          );
        },
      );
    */
    }
  }

  Future<void> launchWhatsAppBusinessOnly(Size size,{
    required String phoneNumber,
    String message = '',
  }) async {
    // Para Business en Android, usa el paquete específico
    // 'com.whatsapp.w4b' en el Intent (aunque url_launcher lo hace más fácil).
    // La mejor práctica es usar wa.me. Si necesitas el URI scheme directo (solo Android):
    final String androidBusinessUrl = 'whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}';
    final Uri url = Uri.parse(androidBusinessUrl);

    // NOTA: En la práctica, el enlace wa.me es el que mejor funciona y deja que el sistema operativo
    // decida si abrirlo con la versión normal o Business si ambas están instaladas.
    if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // Fallback a wa.me o a un mensaje de error
      final Uri fallbackUrl = Uri.parse('https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');
      if (await canLaunchUrl(fallbackUrl)) {
          await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
      } else {
        //throw 'No se pudo abrir WhatsApp Business ni el enlace universal.';
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Container(
                color: Colors.transparent,
                height: size.height * 0.17,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    Container(
                      color: Colors.transparent,
                      height: size.height * 0.09,
                      child: Image.asset('assets/gifs/gifErrorBlanco.gif'),
                    ),

                    Container(
                      color: Colors.transparent,
                      width: size.width * 0.95,
                      height: size.height * 0.08,
                      alignment: Alignment.center,
                      child: const AutoSizeText(
                        'No se pudo abrir WhatsApp. Asegúrese de tenerlo instalado.',
                        maxLines: 2,
                        minFontSize: 2,
                      ),
                    )
                  ],
                )
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                ),
              ],
            );
          },
        );
      
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final gnrBloc = Provider.of<GenericBloc>(context);
    gnrBloc.setMuestraCarga(true);
    final themeProvider = Provider.of<ThemeProvider>(context);
  
    return BlocBuilder<GenericBloc, GenericState>(
      builder: (context,state) {

        if(!state.inicioCarga){
          gnrBloc.setMuestraCarga(false);
        }

        String formatearTiempo(int segundos) {
          int horas = segundos ~/ 3600;
          int minutos = (segundos % 3600) ~/ 60;
          int segs = segundos % 60;
          return '${horas.toString().padLeft(2, '0')}:${minutos.toString().padLeft(2, '0')}:${segs.toString().padLeft(2, '0')}';
        }

        return !state.muestraCarga 
        ? 
        Column(
            children: [
              Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                
                    //if(lstActividadesDiariasByProspecto.isNotEmpty && !state.muestraCarga)
                    Container(
                      width: size.width * 0.85,
                      height: size.height * 0.05,
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Container(
                            width: size.width * 0.055,
                            height: size.height * 0.07,
                            color: Colors.transparent,
                            alignment: Alignment.centerLeft,
                            child: Checkbox(
                              onChanged: (value) {
                                
                                muestraActividadesDiarias = !muestraActividadesDiarias;
                            
                                cargaActividadesByCliente();
                            
                                setState(() {});
                            
                              },
                              value: muestraActividadesDiarias,
                              checkColor: Colors.green,
                              activeColor: Colors.white,
                              //focusColor: Colors.red,
                            ),
                          ),

                          SizedBox(width: size.width * 0.025,),
                                  
                          Container(
                            width: size.width * 0.75,
                            height: size.height * 0.07,
                            color: Colors.transparent,
                            alignment: Alignment.centerLeft,
                            child: const Text('Agendadas para hoy', style: TextStyle(color: Colors.green, fontSize: 25, fontWeight: FontWeight.bold),),
                          ),
                        ],
                      ),
                    ),

                    if(lstActividadesDiariasByProspecto.isNotEmpty && !state.muestraCarga)
                    Container(
                      color: Colors.transparent,
                      width: size.width * 0.95,
                      height: size.height * 0.07,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: size.width * 0.35,
                            height: size.height * 0.07,
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: const Text('Seleccionar todas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          ),

                          Container(
                            width: size.width * 0.25,
                            height: size.height * 0.07,
                            color: Colors.transparent,
                            child: Checkbox(
                              onChanged: (value) {
                                seleccionaTodasActividades = !seleccionaTodasActividades;
                                seleccionaUnaActividad = seleccionaTodasActividades;
                                if(lstActividadesDiariasByProspecto.isNotEmpty){
                                  for(int i = 0; i < lstActividadesDiariasByProspecto.length; i++){
                                    lstActividadesDiariasByProspecto[i].cerrado = seleccionaTodasActividades;
                                  }
                                }

                                setState(() {
                                  
                                });
                                
                              },
                              value: seleccionaTodasActividades,//lstActividadesDiariasByProspecto[index].cerrado,
                              checkColor: Colors.green,
                              activeColor: Colors.white,
                            ),
                          ),

                        ],
                      ),
                    ),
                
                    if(lstActividadesDiariasByProspecto.isNotEmpty && !state.muestraCarga)
                    Container(
                      color: Colors.transparent,
                      width: size.width,
                      height: size.height * 0.28,//isSelected[1] ? size.height * 0.53 : size.height * 0.33,
                      child: ListView.builder(
                        //controller: scrollListaClt,
                        itemCount: lstActividadesDiariasByProspecto.length,
                        itemBuilder: ( _, int index ) {
                              
                          return Slidable(
                            key: ValueKey(lstActividadesDiariasByProspecto[index].id),                                
                            child:  Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                              child: Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: lstActividadesDiariasByProspecto[index].cerrado ? Colors.grey[300] : Colors.white,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: lstActividadesDiariasByProspecto[index].cerrado ? Colors.black45 : Colors.grey[300],
                                    child: Stack(
                                        children: [
                                          if(lstActividadesDiariasByProspecto[index].activityCategory != null 
                                          && lstActividadesDiariasByProspecto[index].activityCategory!.toLowerCase() != 'whatsapp'
                                          && lstActividadesDiariasByProspecto[index].activityCategory!.toLowerCase() != 'phonecall'
                                          && (lstActividadesDiariasByProspecto[index].activityCategory!.toLowerCase() != 'email' || lstActividadesDiariasByProspecto[index].leadEmail == null || lstActividadesDiariasByProspecto[index].leadEmail!.isEmpty))
                                          const Icon(Icons.person, color: Colors.black,),

                                          if(lstActividadesDiariasByProspecto[index].activityCategory != null && lstActividadesDiariasByProspecto[index].activityCategory!.toLowerCase() == 'phonecall')
                                          GestureDetector(
                                            onTap: () {
                                              makePhoneCall(lstActividadesDiariasByProspecto[index].leadPhone!);                                                        
                                            },
                                            child: const Icon(Icons.call, size: 22, color: Colors.black,)
                                          ),

                                          if(lstActividadesDiariasByProspecto[index].activityCategory != null && lstActividadesDiariasByProspecto[index].activityCategory!.toLowerCase() == 'email' && lstActividadesDiariasByProspecto[index].leadEmail != null && lstActividadesDiariasByProspecto[index].leadEmail!.isNotEmpty)
                                          GestureDetector(
                                            onTap: () {
                                              openEmailApp(lstActividadesDiariasByProspecto[index].leadEmail!);                                                        
                                            },
                                            child: const Icon(Icons.email, color: Colors.white, size: 22,)
                                          ),

                                          if(lstActividadesDiariasByProspecto[index].activityCategory != null && lstActividadesDiariasByProspecto[index].activityCategory!.toLowerCase() == 'whatsapp')
                                          GestureDetector(
                                            onTap: () {
                                              abrirWhatsapp(lstActividadesDiariasByProspecto[index].leadPhone!, size);
                                            },
                                            child: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green, size: 22,)
                                          ),

                                          if(!lstActividadesDiariasByProspecto[index].cerrado && DateFormat('yyyy-MM-dd', 'es').format(lstActividadesDiariasByProspecto[index].dateDeadline) == DateFormat('yyyy-MM-dd', 'es').format(DateTime.now()))
                                          Positioned(
                                            top: size.height * 0.01,
                                            left: size.width * 0.02,
                                            child: Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.05,
                                              height: size.height * 0.02,
                                              child: const IndicatorPointWidget(null)
                                            ),
                                          )
                                        ]
                                      ),
                                  ),
                                  title: GestureDetector(
                                    onTap: () {
                                      tipoActividadEscogida = lstActividadesDiariasByProspecto[index].summary ?? '';

                                      setState(() {
                                        
                                      });
                                    },
                                    child: Text(lstActividadesDiariasByProspecto[index].summary ?? '')
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                                                      
                                      Row(
                                        children: [
                                          Container(
                                            color: Colors.transparent,
                                            width: size.width * 0.42,
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: 'Tipo de actividad: ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: lstActividadesDiariasByProspecto[index].activityTypeId.name,                                                  
                                                    style: const TextStyle(
                                                      overflow: TextOverflow.ellipsis,
                                                      color: Colors.blueGrey,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          SizedBox(width: size.width * 0.04,),
                                          
                                        ],
                                      ),
                                      
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'Fecha planificada:',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                            TextSpan(
                                              text: DateFormat('dd/MM/yyyy', 'es').format(lstActividadesDiariasByProspecto[index].dateDeadline),
                                              style: const TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'Hora planificada: ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                            TextSpan(
                                              text: lstActividadesDiariasByProspecto[index].scheduledTimeFormula,
                                              style: const TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'Creado en: ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                            TextSpan(
                                              text: lstActividadesDiariasByProspecto[index].dateCreate != null ? DateFormat('dd/MM/yyyy HH:MM:SS', 'es').format(lstActividadesDiariasByProspecto[index].dateCreate!) : "",
                                              style: const TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    
                                    ],
                                  ),
                                  trailing: Container(
                                    color: Colors.transparent, 
                                    width: size.width * 0.08,
                                    child: Checkbox(
                                      onChanged: (value) {
                                        setState(() {
                                          lstActividadesDiariasByProspecto[index].cerrado = !lstActividadesDiariasByProspecto[index].cerrado;

                                          if(!lstActividadesDiariasByProspecto[index].cerrado){
                                            seleccionaTodasActividades = false;
                                          }
                                          
                                          tipoActividadEscogida = lstActividadesDiariasByProspecto[index].summary ?? '';

                                          int contCerradas = 0;
                                            
                                          for(int i = 0; i < lstActividadesDiariasByProspecto.length; i++){
                                            if(lstActividadesDiariasByProspecto[i].cerrado){
                                              contCerradas += 1;
                                            }
                                          }

                                          if(contCerradas == lstActividadesDiariasByProspecto.length){
                                            seleccionaTodasActividades = true;
                                          }

                                          if(contCerradas >= 1){
                                            seleccionaUnaActividad = true;
                                          }
                                          else{
                                            seleccionaUnaActividad = false;
                                          }

                                        });
                                      },
                                      value: lstActividadesDiariasByProspecto[index].cerrado,
                                      checkColor: Colors.green,
                                      activeColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          );
                        
                        },
                      ),
                    ),
                
                    if(lstActividadesDiariasByProspecto.isNotEmpty && !state.muestraCarga)
                    Container(
                      width: size.width * 0.99,
                      color: Colors.transparent,
                      child: Center(
                        child: Container(
                          width: size.width * 0.95,
                          height: size.height * 0.11,
                          color: Colors.transparent,
                          child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    formatearTiempo(_segundosAct),                                                                  
                                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                                  ),
                                
                                ],
                              ),
                            ),
                        )
                      ),
                    ),
                
                    if(lstActividadesDiariasByProspecto.isNotEmpty && !state.muestraCarga)
                    Container(
                      color: Colors.transparent,
                      width: size.width * 0.92,
                      child: TextFormField(
                        inputFormatters: [
                          EmojiInputFormatter()
                        ],
                        cursorColor: AppLightColors().primary,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: AppTextStyles.bodyRegular(
                          width: size.width,
                          color: themeProvider.themeMode.index == 0 || themeProvider.themeMode.index == 1 ? Colors.black : Colors.white
                        ),
                        decoration: const InputDecoration(
                          label: Text('Notas'),
                          border: OutlineInputBorder(),
                          hintText: 'Notas de la visita o llamada para registrar la acción realizada.',
                        ),                                              
                        controller: notasActTxtAct,
                        autocorrect: false,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 4,
                        autofocus: false,
                        textAlign: TextAlign.left,
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                        onChanged: (value) {
                          
                        },
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  
                    if(lstActividadesDiariasByProspecto.isNotEmpty && !state.muestraCarga)
                    SizedBox(height: size.height * 0.035),

                    if(lstActividadesDiariasByProspecto.isNotEmpty && !state.muestraCarga
                    && (seleccionaTodasActividades || seleccionaUnaActividad))
                    Container(
                      width: size.width * 0.95,
                      height: size.height * 0.07,
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              iniciarCronometro();
                            },
                            child: Container(
                              width: size.width * 0.45,
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                              decoration: BoxDecoration(
                                color: Colors.indigo, // Color similar al de la imagen
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.login, color: Colors.white),
                                  SizedBox(width: size.width * 0.01),
                                  const Text(
                                    "Llegada",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: size.width * 0.115),
                                  const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                                ],
                              ),
                            ),
                          ),
                
                          GestureDetector(
                            onTap: () {

                              if(_segundosAct == 0){
                                showDialog(
                                  //ignore:use_build_context_synchronously
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Container(
                                        color: Colors.transparent,
                                        height: size.height * 0.17,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            
                                            Container(
                                              color: Colors.transparent,
                                              height: size.height * 0.09,
                                              child: Image.asset('assets/gifs/gifErrorBlanco.gif'),
                                            ),
                
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.95,
                                              height: size.height * 0.08,
                                              alignment: Alignment.center,
                                              child: const AutoSizeText(
                                                'Debe marcar la llegada de la actividad.',
                                                maxLines: 2,
                                                minFontSize: 2,
                                              ),
                                            )
                                          ],
                                        )
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                return;
                              }

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Registro de salida'),
                                    content: const Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Desea registrar la salida y cerrar la'
                                          ' visita de este cliente?',
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          //context.pop();
                                          Navigator.pop(context);                                              
                                        },
                                        child: Text(
                                          'NO',
                                          style: TextStyle(color: Colors.blue[200]),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                
                                          if(_segundosAct == 0){
                                            showDialog(
                                            //ignore:use_build_context_synchronously
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Container(
                                                  color: Colors.transparent,
                                                  height: size.height * 0.17,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      
                                                      Container(
                                                        color: Colors.transparent,
                                                        height: size.height * 0.09,
                                                        child: Image.asset('assets/gifs/gifErrorBlanco.gif'),
                                                      ),
                          
                                                      Container(
                                                        color: Colors.transparent,
                                                        width: size.width * 0.95,
                                                        height: size.height * 0.08,
                                                        alignment: Alignment.center,
                                                        child: const AutoSizeText(
                                                          'Debe marcar la llegada de la actividad.',
                                                          maxLines: 2,
                                                          minFontSize: 2,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                            return;
                                          }
                
                                          int idACt = 0;
                
                                          for(int i = 0; i < actividadesFilAgendaPlanAct.length; i++){
                                            if(actPlanSelectAct == actividadesFilAgendaPlanAct[i].name){
                                              idACt = actividadesFilAgendaPlanAct[i].id ?? 0;
                                            }
                                          }
                
                                          Navigator.of(context).pop();
                                            
                                          detenerCronometro();
                
                                          double tiempo = double.parse(_segundosAct.toString());

                                          List<ActivitiesTypeRequestModel> lstRqst = [];

                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) => SimpleDialog(
                                              alignment: Alignment.center,
                                              children: [
                                                SimpleDialogCargando(
                                                  null,
                                                  mensajeMostrar: 'Estamos registrando',
                                                  mensajeMostrarDialogCargando: 'la nueva actividad para el prospecto.',
                                                ),
                                              ]
                                            ),
                                          );

                                          for(int i = 0; i < lstActividadesDiariasByProspecto.length; i++){
                                            if(lstActividadesDiariasByProspecto[i].cerrado){
                                              lstRqst.add(
                                                ActivitiesTypeRequestModel(
                                                  active: true,
                                                  createDate: DateTime.now(),//DateTime.parse(fechaActividadContTxtAct.text),
                                                  createUid: 0,
                                                  displayName: objDatumCrmLead?.contactName ?? '',
                                                  previousActivityTypeId: 0,
                                                  note: descripcionActTxtAct.text,
                                                  activityTypeId: idACt,
                                                  dateDeadline: DateTime.now(),
                                                  userId: objDatumCrmLead?.userId!.id ?? 0,
                                                  userCreateId: objDatumCrmLead?.userId!.id ?? 0,
                                                  resId: objDatumCrmLead?.id ?? 0,
                                                  actId: lstActividadesDiariasByProspecto[i].id,
                                                  workingTime: tiempo,
                                                  summary: '',
                                                  leadName: lstActividadesDiariasByProspecto[i].leadName ?? '',
                                                  leadPhone: objDatumCrmLead?.phone ?? '',
                                                  contactName: objDatumCrmLead?.contactName ?? '',
                                                  leadEmail: objDatumCrmLead?.emailFrom ?? '',
                                                  scheduleTime: 0
                                                )
                                              );
                                            }
                                          }
                          
                                          ActividadRegistroResponseModel? objResp = await ActivitiesService().cierreActividadesXIdLista(lstRqst);
                
                                          if(objResp != null){
                                            String respuestaReg = objResp.result.mensaje;
                                            int estado = objResp.result.estado;
                                            String gifRespuesta = '';
                  
                                            if(estado == 200){
                                              gifRespuesta = 'assets/gifs/exito.gif';
                                            } else {
                                              gifRespuesta = 'assets/gifs/gifErrorBlanco.gif';
                                            }

                                            //ignore:use_build_context_synchronously
                                            Navigator.of(contextPrincipalGen!).pop();
                            
                                            showDialog(
                                              //ignore:use_build_context_synchronously
                                              context: contextPrincipalGen!,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Container(
                                                    color: Colors.transparent,
                                                    height: size.height * 0.17,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        
                                                        Container(
                                                          color: Colors.transparent,
                                                          height: size.height * 0.09,
                                                          child: Image.asset(gifRespuesta),
                                                        ),
                            
                                                        Container(
                                                          color: Colors.transparent,
                                                          width: size.width * 0.95,
                                                          height: size.height * 0.08,
                                                          alignment: Alignment.center,
                                                          child: AutoSizeText(
                                                            respuestaReg,
                                                            maxLines: 2,
                                                            minFontSize: 2,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        //Navigator.of(contextPrincipalGen!).pop();
                                                        Navigator.of(contextPrincipalGen!).pop();
                                                        Navigator.of(contextPrincipalGen!).pop();
                                                      },
                                                      child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          
                                          }
                                          else{
                                            //ignore:use_build_context_synchronously
                                            Navigator.of(contextPrincipalGen!).pop();
                            
                                            showDialog(
                                              //ignore:use_build_context_synchronously
                                              context: contextPrincipalGen!,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Container(
                                                    color: Colors.transparent,
                                                    height: size.height * 0.17,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        
                                                        Container(
                                                          color: Colors.transparent,
                                                          height: size.height * 0.09,
                                                          child: Image.asset('assets/gifs/gifErrorBlanco.gif'),
                                                        ),
                            
                                                        Container(
                                                          color: Colors.transparent,
                                                          width: size.width * 0.95,
                                                          height: size.height * 0.08,
                                                          alignment: Alignment.center,
                                                          child: const AutoSizeText(
                                                            'Error de conversión',
                                                            maxLines: 2,
                                                            minFontSize: 2,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        //Navigator.of(contextPrincipalGen!).pop();
                                                        Navigator.of(contextPrincipalGen!).pop();
                                                        Navigator.of(contextPrincipalGen!).pop();
                                                      },
                                                      child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                        
                                          }
                
                                          
                                        },
                                        child: Text(
                                          'Sí',
                                          style: TextStyle(color: Colors.blue[200]),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: size.width * 0.45,
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                              decoration: BoxDecoration(
                                color: Colors.indigo, // Color similar al de la imagen
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.logout, color: Colors.white),
                                  SizedBox(width: size.width * 0.01),
                                  const Text(
                                    "Salida",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: size.width * 0.14),
                                  const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                
                    if(lstActividadesDiariasByProspecto.isNotEmpty && !state.muestraCarga)
                    SizedBox(height: size.height * 0.009),
                
                    if(lstActividadesDiariasByProspecto.isEmpty && !state.muestraCarga)
                    SizedBox(height: size.height * 0.15),
                    
                    if(lstActividadesDiariasByProspecto.isEmpty && !state.muestraCarga)
                    Container(
                      color: Colors.transparent,
                      width: size.width * 0.95,
                      height: size.height * 0.11,
                      alignment: Alignment.topCenter,
                      child: const AutoSizeText('No existen actividades agendadas', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,), maxLines: 3,  presetFontSizes: [50, 48, 46, 42,40,38,36,34,32,30,28,26,24,22,20,18,16,14,12,10]),
                    ),
                  ],
                ),
              ),
            ),
            ],
          )
        :
        Center(
            child: Image.asset(
              "assets/gifs/gif_carga.gif",
              height: size.width * 0.85,//150.0,
              width: size.width * 0.85,//150.0,
            ),
          );
    
      }
    );
  }
}

class BtnSlidableActionActiv extends StatefulWidget {
  const BtnSlidableActionActiv(Key? key) : super (key: key);
  @override
  State<BtnSlidableActionActiv> createState() => BtnSlidableActionActivState();
}

class BtnSlidableActionActivState extends State<BtnSlidableActionActiv> {

  ColorsApp objColorsApp = ColorsApp();

  void iniciarCronometro() {
    if (!_corriendoAct) {
      _corriendoAct = true;
      _timerAct = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _segundosAct++;
        });
      });
    }
  }

  void detenerCronometro() {
    if (_corriendoAct) {
      _timerAct?.cancel();
      _corriendoAct = false;
    }
  }

  void reiniciarCronometro() {
    _timerAct?.cancel();
    setState(() {
      _segundosAct = 0;
      _corriendoAct = false;
    });
  }

  String formatearTiempo(int segundos) {
    int horas = segundos ~/ 3600;
    int minutos = (segundos % 3600) ~/ 60;
    int segs = segundos % 60;
    return '${horas.toString().padLeft(2, '0')}:${minutos.toString().padLeft(2, '0')}:${segs.toString().padLeft(2, '0')}';
  }

  
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SlidableAction(
      onPressed: (context) {
        
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Registro detalle de actividad"),
              content: Form(
                //key: _formKey,
                child: Container(
                  color: Colors.transparent,
                  height: size.height * 0.3,
                  child: Column(
                    children: [
                      
                      Container(
                        width: size.width * 0.99,
                        color: Colors.transparent,
                        child: Center(
                          child: Container(
                            width: size.width * 0.95,
                            height: size.height * 0.11,
                            color: Colors.transparent,
                            child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      formatearTiempo(_segundosAct),
                                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                                    ),
                                  
                                  ],
                                ),
                              ),
                          )
                        ),
                      ),
                  
                      Container(
                        color: Colors.transparent,
                        width: size.width * 0.92,
                        child: TextFormField(     
                                    
                          inputFormatters: [
                            EmojiInputFormatter()
                          ],
                          cursorColor: AppLightColors().primary,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: AppTextStyles.bodyRegular(
                            width: size.width,
                            color: themeProvider.themeMode.index == 0 || themeProvider.themeMode.index == 1 ? Colors.black : Colors.white
                          ),
                          decoration: const InputDecoration(
                            label: Text('Notas'),
                            border: OutlineInputBorder(),
                            hintText: 'Notas de la visita o llamada para registrar la acción realizada.',
                          ),
                  
                          controller: notasActTxtAct,
                          autocorrect: false,
                          keyboardType: TextInputType.text,
                          minLines: 1,
                          maxLines: 4,
                          autofocus: false,
                          maxLength: 150,
                          textAlign: TextAlign.left,
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                          },
                          onChanged: (value) {
                            
                          },
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                    
                    
                    ],
                  ),
                )
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    
                    if(_segundosAct == 0){
                      showDialog(
                        //ignore:use_build_context_synchronously
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Container(
                              color: Colors.transparent,
                              height: size.height * 0.17,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  
                                  Container(
                                    color: Colors.transparent,
                                    height: size.height * 0.09,
                                    child: Image.asset('assets/gifs/gifErrorBlanco.gif'),
                                  ),
      
                                  Container(
                                    color: Colors.transparent,
                                    width: size.width * 0.95,
                                    height: size.height * 0.08,
                                    alignment: Alignment.center,
                                    child: const AutoSizeText(
                                      'Debe marcar la llegada de la actividad.',
                                      maxLines: 2,
                                      minFontSize: 2,
                                    ),
                                  )
                                ],
                              )
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Registro de salida'),
                          content: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Desea registrar la salida y cerrar la'
                                ' visita del cliente',
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                //context.pop();
                                Navigator.pop(context);
                                
                                //Navigator.of(context).pop();
                              },
                              child: Text(
                                'NO',
                                style: TextStyle(color: Colors.blue[200]),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Acción para solicitar revisión
                                Navigator.of(context).pop();
                                  
                                //detenerCronometro();
                                
                                
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Sí',
                                style: TextStyle(color: Colors.blue[200]),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  
                  },
                  child: const Text("Salida"),
                ),
                ElevatedButton(
                  onPressed: () {
                    iniciarCronometro();
                  },
                  child: const Text("Llegada"),
                ),
              ],
            );
          },
        );
      },
      backgroundColor: objColorsApp.celeste,
      foregroundColor: Colors.white,
      icon: Icons.call_outlined,
      label: 'Actividades',
    );
  }

}

Widget _buildAgendaItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person),
          ),
          title: const Text('Randy Rudolph'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Text('RUC/C: 095011183001', style: TextStyle(fontSize: 12)),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'RUC/C:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    TextSpan(
                      text: '095011183001',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              //Text('COD: 59345', style: TextStyle(fontSize: 12)),

              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'COD:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    TextSpan(
                      text: '59345',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),


              const Text('Tipo de Agenda: Llamada', style: TextStyle(fontSize: 12)),
              const Text('Activo', style: TextStyle(fontSize: 12, color: Colors.green)),
            ],
          ),
          trailing: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('10:20 AM', style: TextStyle(fontWeight: FontWeight.bold)),
              Icon(Icons.phone, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
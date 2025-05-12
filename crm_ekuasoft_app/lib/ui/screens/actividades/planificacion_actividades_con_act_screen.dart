import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

bool seleccionaTodasActividades = false;
bool seleccionaUnaActividad = false;
int activitySelected = 0;
List<MailActivityTypeDatumAppModel> actividadesFilAgendaPlanAct = [];
List<String> lstActividadesAct = [];
int idProspectoAct = 0;
Timer? _timerAct;
int _segundosAct = 0;
bool _corriendoAct = false;

String terminoBusquedaActiv = '';
bool actualizaListaActiv= false;
int contLstActiv = 0;
//import 'package:one_clock/one_clock.dart';
String actPlanSelectAct = '';
String tipoActividadEscogida = '';

late TextEditingController fechaActividadContTxtAct;
late TextEditingController descripcionActTxtAct;

int tabAccionesAct = 0;
late TextEditingController notasActTxtAct;

List<DatumActivitiesResponse> actividadesFiltradasAct = [];
List<DatumActivitiesResponse> lstActividadesDiariasByProspecto = [];

class PlanificacionActividadesConActividadScreen extends StatefulWidget {
  const PlanificacionActividadesConActividadScreen(Key? key) : super (key: key);
  @override
  State<PlanificacionActividadesConActividadScreen> createState() => PlanActivState();
}

class PlanActivState extends State<PlanificacionActividadesConActividadScreen> {

  @override
  void initState() {
    super.initState();
    //objActividadEscogida = null;
    contLstActiv = 0;
    notasActTxtAct = TextEditingController();
    fechaActividadContTxtAct = TextEditingController();
    descripcionActTxtAct = TextEditingController();
    terminoBusquedaActiv = '';
    actualizaListaActiv= false;
    actividadesFiltradasAct = [];
    idProspectoAct = 0;
    lstActividadesAct = [];
    _segundosAct = 0;
    _corriendoAct = false;
    actividadesFilAgendaPlanAct = [];
    lstActividadesDiariasByProspecto = [];
    tipoActividadEscogida = '';
    seleccionaTodasActividades = false;
    seleccionaUnaActividad = false;

  }

   Future<void> actualizaActividadesByCliente() async {
    try {
      lstActividadesDiariasByProspecto = [];
      ActivitiesPageModel? objRspFinal = await ActivitiesService().getActivitiesDiariasByProspecto( null, objDatumCrmLead?.id ?? 0);
      
      if(objRspFinal != null){
        lstActividadesDiariasByProspecto = objRspFinal.activities.data;        
      }
      
      setState(() {
        //_mensaje = "¡Datos recibidos!";
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
                                        height: size.height *
                                            state.heightModalPlanAct, //0.57,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'En esta interfaz es posible registrar las actividades que serán realizadas con los prospectos/leads asignados',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[700]),
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
                                                  items: lstActividadesAct.map((activityPrsp) =>
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
                                              
                                              TextFormField(
                                                controller: fechaActividadContTxtAct,
                                                readOnly: true,
                                                decoration: const InputDecoration(
                                                  labelText: 'Seleccione la fecha...',
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
                                              const SizedBox(height: 16),
                                              TextFormField(
                                                controller: descripcionActTxtAct,
                                                onChanged: (value) {
                                                  planActiv.setHeightModalPlanAct(
                                                      0.92);
                                                },
                                                onTap: () {
                                                  planActiv.setHeightModalPlanAct(
                                                      0.92);
                                                },
                                                onEditingComplete: () {
                                                  planActiv.setHeightModalPlanAct(
                                                      0.65);
                                                  FocusScope.of(context).unfocus();
                                                },
                                                onTapOutside: (event) {
                                                  planActiv.setHeightModalPlanAct(
                                                      0.65);
                                                  FocusScope.of(context).unfocus();
                                                },
                                                maxLines: 4,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText:
                                                      'Ingrese su descripción...',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                              SizedBox(height: size.height * 0.035),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      context.pop();
                                                    },
                                                    
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: const Color(
                                                          0xFF5F2EEA), // Purple button
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
                                                        leadPhone: objDatumCrmLead?.phone ?? ''
                                                      );
              
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
                                      
                                                      ActividadRegistroResponseModel objResp = await ActivitiesService().registroActividades(objReqst);
/*
                                                      if(lstActividadesDiariasByProspecto.isEmpty){
                                                        lstActividadesDiariasByProspecto = [];                                                        
                                                      }
                                                    
                                                      lstActividadesDiariasByProspecto.add(
                                                        DatumActivitiesResponse(
                                                          activityTypeId: IdActivities(id: objReqst.activityTypeId, name: ''),
                                                          cerrado: false,
                                                          dateDeadline: DateTime.parse(fechaActividadContTxtAct.text),
                                                          id: lstActividadesDiariasByProspecto.length + 1,
                                                          resId: objReqst.resId,
                                                          resModel: '',
                                                          summary: objReqst.note,
                                                          userId: IdActivities(id: objReqst.userId, name: '')
                                                        )
                                                      );
              */
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
              
              /*
                                                      if(objResp.result.mensaje.isNotEmpty){
                                  
                                                        showDialog(
                                                          //ignore: use_build_context_synchronously
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
                                                                        objResp.result.mensaje,
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
                                                      
                                                        //return;
                                                      }
                                                      */
                                      
                                                      
                                                      //ignore:use_build_context_synchronously
                                                      context.pop();
                                                      /*
                                                      //ignore:use_build_context_synchronously
                                                      context.pop();
                                                      */

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
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: const Color(0xFF5F2EEA),
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
                          Icons.calendar_month,
                          color: Colors.white,
                          size: 40,
                        )
                      ),
                    SizedBox(
                      width: size.width * 0.04,
                    )
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
                            /*
                            Container(
                              color: Colors.transparent,
                                width: size.width * 0.95,
                                child: Text(
                                  tipoActividadEscogida,//'Compra de terreno con plan de viaje',
                                  style: const TextStyle(color: Colors.white, fontSize: 17),
                                )),
                                */
                            const SizedBox(height: 15),
                            const Row(
                              children: [
                                Text(
                                  "⭐⭐⭐⭐⭐",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.yellow,
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
                                        onPressed: () {
                                          tabAccionesAct = 1;
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
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (tabAccionesAct == 0) const PlanActiv(null),
                      if (tabAccionesAct == 1)
                        // Información General
                        sectionTitle(Icons.info, "Información General"),
                      if (tabAccionesAct == 1) infoRowAct("Razón Social", "Randy Rudolph"),
                      if (tabAccionesAct == 1)
                        infoRowAct("Nombre Comercial", "[partner -> business_name]"),
                      if (tabAccionesAct == 1) infoRowAct("Clasificación", "Randy Rudolph"),
                      if (tabAccionesAct == 1) infoRowAct("Canal", "Randy Rudolph"),
                      if (tabAccionesAct == 1) infoRowAct("Dirección", objDatumCrmLead?.street ?? '-----'),
                      if (tabAccionesAct == 1)
                        // Territorio
                        sectionTitleAct(Icons.place, "Territorio"),
                      if (tabAccionesAct == 1) infoRowAct("Estado", objDatumCrmLead?.stageId.name ?? '-----'),
                      if (tabAccionesAct == 1) infoRowAct("Ciudad", "Guayaquil"),
                      if (tabAccionesAct == 1) infoRowAct("Cantón", "Tarquí"),
                      if (tabAccionesAct == 1) infoRowAct("Región", "Costa"),
                      if (tabAccionesAct == 1) infoRowAct("Lugar", "Norte"),
                      if (tabAccionesAct == 1)
                        // Precios y Ventas
                        sectionTitleAct(Icons.monetization_on, "Precios y Ventas"),
                      if (tabAccionesAct == 1) infoRowAct("Ingreso esperado", "\$${objDatumCrmLead?.expectedRevenue}"),
                      if (tabAccionesAct == 1) infoRowAct("Probabilidad", "${objDatumCrmLead?.probability}%"),
                    ],
                  ),
                ),
              ),
            );
          
        /*
        return FutureBuilder(
          future: ActivitiesService().getActivitiesByRangoFechas( null, objDatumCrmLead?.id ?? 0),
          builder: (context, snapshot) {

            if(!snapshot.hasData) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Image.asset(
                    "assets/gifs/gif_carga.gif",
                    height: size.width * 0.85,//150.0,
                    width: size.width * 0.85,//150.0,
                  ),
                ),
              );
            }

            ActivitiesPageModel rspAct = snapshot.data as ActivitiesPageModel;

            //actividadesFilAgendaPlanAct = rspAct.activities.data;
            lstActividadesDiariasByProspecto = rspAct.activities.data;
            actividadesFilAgendaPlanAct = rspAct.objMailAct.data;
            lstActividadesAct = [];
            objDatumCrmLead = rspAct.lead;
            
            for(int i = 0; i < actividadesFilAgendaPlanAct.length; i++){
              lstActividadesAct.add(actividadesFilAgendaPlanAct[i].name ?? '');
            }

            if(actPlanSelectAct.isEmpty && lstActividadesAct.isNotEmpty){
              actPlanSelectAct = lstActividadesAct.first;
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
                                        height: size.height *
                                            state.heightModalPlanAct, //0.57,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'En esta interfaz es posible registrar las actividades que serán realizadas con los prospectos/leads asignados',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[700]),
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
                                                  items: lstActividadesAct.map((activityPrsp) =>
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
                                              
                                              TextFormField(
                                                controller: fechaActividadContTxtAct,
                                                readOnly: true,
                                                decoration: const InputDecoration(
                                                  labelText: 'Seleccione la fecha...',
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
                                              const SizedBox(height: 16),
                                              TextFormField(
                                                controller: descripcionActTxtAct,
                                                onChanged: (value) {
                                                  planActiv.setHeightModalPlanAct(
                                                      0.92);
                                                },
                                                onTap: () {
                                                  planActiv.setHeightModalPlanAct(
                                                      0.92);
                                                },
                                                onEditingComplete: () {
                                                  planActiv.setHeightModalPlanAct(
                                                      0.65);
                                                  FocusScope.of(context).unfocus();
                                                },
                                                onTapOutside: (event) {
                                                  planActiv.setHeightModalPlanAct(
                                                      0.65);
                                                  FocusScope.of(context).unfocus();
                                                },
                                                maxLines: 4,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText:
                                                      'Ingrese su descripción...',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                              SizedBox(height: size.height * 0.035),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      context.pop();
                                                    },
                                                    
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: const Color(
                                                          0xFF5F2EEA), // Purple button
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
                                                        leadPhone: objDatumCrmLead?.phone ?? ''
                                                      );
              
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
                                      
                                                      ActividadRegistroResponseModel objResp = await ActivitiesService().registroActividades(objReqst);

                                                      if(lstActividadesDiariasByProspecto.isEmpty){
                                                        lstActividadesDiariasByProspecto = [];                                                        
                                                      }
                                                    
                                                      lstActividadesDiariasByProspecto.add(
                                                        DatumActivitiesResponse(
                                                          activityTypeId: IdActivities(id: objReqst.activityTypeId, name: ''),
                                                          cerrado: false,
                                                          dateDeadline: DateTime.parse(fechaActividadContTxtAct.text),
                                                          id: lstActividadesDiariasByProspecto.length + 1,
                                                          resId: objReqst.resId,
                                                          resModel: '',
                                                          summary: objReqst.note,
                                                          userId: IdActivities(id: objReqst.userId, name: '')
                                                        )
                                                      );
              
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
              
              /*
                                                      if(objResp.result.mensaje.isNotEmpty){
                                  
                                                        showDialog(
                                                          //ignore: use_build_context_synchronously
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
                                                                        objResp.result.mensaje,
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
                                                      
                                                        //return;
                                                      }
                                                      */
                                      
                                                      
                                                      //ignore:use_build_context_synchronously
                                                      context.pop();
                                                      /*
                                                      //ignore:use_build_context_synchronously
                                                      context.pop();
                                                      */

                                                      setState(() {
                                                        
                                                      });
                                                      
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
                                                    
                                                    },
                                                    
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: const Color(0xFF5F2EEA), // Purple button
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
                          Icons.calendar_month,
                          color: Colors.white,
                          size: 40,
                        )
                      ),
                    SizedBox(
                      width: size.width * 0.04,
                    )
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
                            Container(
                              color: Colors.transparent,
                                width: size.width * 0.95,
                                child: const Text(
                                  'Compra de terreno con plan de viaje',
                                  style: TextStyle(color: Colors.white, fontSize: 17),
                                )),
                            const SizedBox(height: 15),
                            const Row(
                              children: [
                                Text(
                                  "⭐⭐⭐⭐⭐",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.yellow,
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
                                        onPressed: () {
                                          tabAccionesAct = 1;
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
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (tabAccionesAct == 0) const PlanActiv(null),
                      if (tabAccionesAct == 1)
                        // Información General
                        sectionTitle(Icons.info, "Información General"),
                      if (tabAccionesAct == 1) infoRowAct("Razón Social", "Randy Rudolph"),
                      if (tabAccionesAct == 1)
                        infoRowAct("Nombre Comercial", "[partner -> business_name]"),
                      if (tabAccionesAct == 1) infoRowAct("Clasificación", "Randy Rudolph"),
                      if (tabAccionesAct == 1) infoRowAct("Canal", "Randy Rudolph"),
                      if (tabAccionesAct == 1) infoRowAct("Dirección", objDatumCrmLead?.street ?? '-----'),
                      if (tabAccionesAct == 1)
                        // Territorio
                        sectionTitleAct(Icons.place, "Territorio"),
                      if (tabAccionesAct == 1) infoRowAct("Estado", objDatumCrmLead?.stageId.name ?? '-----'),
                      if (tabAccionesAct == 1) infoRowAct("Ciudad", "Guayaquil"),
                      if (tabAccionesAct == 1) infoRowAct("Cantón", "Tarquí"),
                      if (tabAccionesAct == 1) infoRowAct("Región", "Costa"),
                      if (tabAccionesAct == 1) infoRowAct("Lugar", "Norte"),
                      if (tabAccionesAct == 1)
                        // Precios y Ventas
                        sectionTitleAct(Icons.monetization_on, "Precios y Ventas"),
                      if (tabAccionesAct == 1) infoRowAct("Ingreso esperado", "\$${objDatumCrmLead?.expectedRevenue}"),
                      if (tabAccionesAct == 1) infoRowAct("Probabilidad", "${objDatumCrmLead?.probability}%"),
                    ],
                  ),
                ),
              ),
            );
          
          }
        );
        */
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

Widget infoRowAct(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$label:",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
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
      if(actividadesFilAgendaPlanAct.isEmpty && lstActividadesDiariasByProspecto.isEmpty){
        await cargaActividadesByCliente();
      }
      //ignore: use_build_context_synchronously
      final gnrBloc = Provider.of<GenericBloc>(context, listen: false);
      gnrBloc.setMuestraCarga(false);
    });

  }

  
   Future<void> cargaActividadesByCliente() async {
    try {
      final gnrBloc = Provider.of<GenericBloc>(context, listen: false);
      gnrBloc.setIniciaCarga(true);
      
      ActivitiesPageModel? objRspFinal = await ActivitiesService().getActivitiesDiariasByProspecto(null, objDatumCrmLead?.id ?? 0);

      if(objRspFinal != null && actividadesFilAgendaPlanAct.isEmpty && lstActividadesDiariasByProspecto.isEmpty){
        lstActividadesDiariasByProspecto = objRspFinal.activities.data;
        actividadesFilAgendaPlanAct = objRspFinal.objMailAct.data;
        lstActividadesAct = [];
        objDatumCrmLead = objRspFinal.lead;
        
        for(int i = 0; i < actividadesFilAgendaPlanAct.length; i++){
          lstActividadesAct.add(actividadesFilAgendaPlanAct[i].name ?? '');
        }

        if(actPlanSelectAct.isEmpty && lstActividadesAct.isNotEmpty){
          actPlanSelectAct = lstActividadesAct.first;
        }
      }

      gnrBloc.setIniciaCarga(false);
/*
      setState(() {
        //_mensaje = "¡Datos recibidos!";
      });
      */

    } catch (_) {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //ScrollController scrollListaClt = ScrollController();

    final gnrBloc = Provider.of<GenericBloc>(context);
    gnrBloc.setMuestraCarga(true);
  
    return BlocBuilder<GenericBloc, GenericState>(
      builder: (context,state) {

        if(!state.inicioCarga){
          gnrBloc.setMuestraCarga(false);
        }

/*
        Future<void> refreshDataByFiltro(String filtro) async {            
                actividadesFiltradasAct = [];

                //CrmLead apiResponse = CrmLead.fromJson(objMemoria);

                if(terminoBusquedaActiv.isNotEmpty){
                  
                  actividadesFiltradasAct = rspAct.data
                  .where(
                    (producto) => producto.activityTypeId.name.toLowerCase().contains(terminoBusquedaActiv.toLowerCase()))
                  .toList();

                  contLstActiv = 0;

                  contLstActiv = actividadesFiltradasAct.length;
                } else{
                  actividadesFiltradasAct = rspAct.data;
                  actualizaListaActiv = false;
                }            

                if(terminoBusquedaActiv.isNotEmpty && actualizaListaActiv) {
                  setState(() {});
                }

              }
*/

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
                      
                          if(lstActividadesDiariasByProspecto.isNotEmpty && !state.muestraCarga)
                          Container(
                            width: size.width * 0.95,
                            height: size.height * 0.07,
                            color: Colors.transparent,
                            child: const Text('Agendado para hoy', style: TextStyle(color: Colors.green, fontSize: 25, fontWeight: FontWeight.bold),),
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
                                  child: const Text('Seleccionar todos', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
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
                                                const Icon(Icons.person),
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
                                                                            
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: 'Tipo de actividad:',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: lstActividadesDiariasByProspecto[index].activityTypeId.name,
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
                                                    text: 'Fecha planificada:',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: DateFormat('yyyy-MM-dd', 'es').format(lstActividadesDiariasByProspecto[index].dateDeadline),
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
                              style: AppTextStyles.bodyRegular(width: size.width),
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

                                                /*
                                                
                                                ActivitiesTypeRequestModel objReqst = ActivitiesTypeRequestModel(
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
                                                  actId: activitySelected,
                                                  workingTime: tiempo,
                                                  summary: '',
                                                  leadName: objDatumCrmLead?.name ?? '',
                                                  leadPhone: objDatumCrmLead?.phone ?? ''
                                                );
                                                */
                      
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
                                                        leadPhone: ''//objDatumCrmLead?.phone ?? ''
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
                            height: size.height * 0.09,
                            alignment: Alignment.topCenter,
                            child: const AutoSizeText('No existen actividades agendadas para el día de hoy', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,), maxLines: 2,  presetFontSizes: [42,40,38,36,34,32,30,28,26,24,22,20,18,16,14,12,10]),
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
          

        /*
        
        return FutureBuilder(
          future: ActivitiesService().getActivitiesById(objDatumCrmLead?.id ?? idProspectoAct),
          builder: (context, snapshot) {

            if(!snapshot.hasData) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Image.asset(
                    "assets/gifs/gif_carga.gif",
                    height: size.width * 0.85,//150.0,
                    width: size.width * 0.85,//150.0,
                  ),
                ),
              );
            }

            if(snapshot.data != null) {

              ActivitiesResponseModel rspAct = snapshot.data as ActivitiesResponseModel;

              if(!actualizaListaActiv)
              {
                contLstActiv = rspAct.length;
                actividadesFiltradasAct = rspAct.data;
              }

              Future<void> refreshDataByFiltro(String filtro) async {            
                actividadesFiltradasAct = [];

                //CrmLead apiResponse = CrmLead.fromJson(objMemoria);

                if(terminoBusquedaActiv.isNotEmpty){
                  
                  actividadesFiltradasAct = rspAct.data
                  .where(
                    (producto) => producto.activityTypeId.name.toLowerCase().contains(terminoBusquedaActiv.toLowerCase()))
                  .toList();

                  contLstActiv = 0;

                  contLstActiv = actividadesFiltradasAct.length;
                } else{
                  actividadesFiltradasAct = rspAct.data;
                  actualizaListaActiv = false;
                }            

                if(terminoBusquedaActiv.isNotEmpty && actualizaListaActiv) {
                  setState(() {});
                }

              }

              String formatearTiempo(int segundos) {
                int horas = segundos ~/ 3600;
                int minutos = (segundos % 3600) ~/ 60;
                int segs = segundos % 60;
                return '${horas.toString().padLeft(2, '0')}:${minutos.toString().padLeft(2, '0')}:${segs.toString().padLeft(2, '0')}';
              }

              return Column(
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
                      
                          if(lstActividadesDiariasByProspecto.isNotEmpty && !state.muestraCarga)
                          Container(
                            width: size.width * 0.95,
                            height: size.height * 0.07,
                            color: Colors.transparent,
                            child: const Text('Agendado para hoy', style: TextStyle(color: Colors.green, fontSize: 25, fontWeight: FontWeight.bold),),
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
                                                const Icon(Icons.person),
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
                                        title: Text(lstActividadesDiariasByProspecto[index].summary ?? ''),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                    
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: 'Tipo de agenda:',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: lstActividadesDiariasByProspecto[index].activityTypeId.name,
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
                                                    text: 'Fecha planificada:',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: DateFormat('yyyy-MM-dd', 'es').format(lstActividadesDiariasByProspecto[index].dateDeadline),
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
                                      ),
                                    ),
                                  )
                                );
                              
                              },
                            ),
                          ),
                      
                          if(lstActividadesDiariasByProspecto.isNotEmpty && !state.muestraCarga)
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
                                                
                                                ActivitiesTypeRequestModel objReqst = ActivitiesTypeRequestModel(
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
                                                  actId: activitySelected,
                                                  workingTime: tiempo,
                                                  summary: '',
                                                  leadName: objDatumCrmLead?.name ?? '',
                                                  leadPhone: objDatumCrmLead?.phone ?? ''
                                                );
                      
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
                                
                                                ActividadRegistroResponseModel objResp = await ActivitiesService().cierreActividadesXId(objReqst);
                      
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
                                                            Navigator.of(contextPrincipalGen!).pop();
                                                            Navigator.of(contextPrincipalGen!).pop();
                                                            Navigator.of(contextPrincipalGen!).pop();
                                                          },
                                                          child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              
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
                              style: AppTextStyles.bodyRegular(width: size.width),
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
                          SizedBox(height: size.height * 0.009),
                      
                          if(lstActividadesDiariasByProspecto.isEmpty && !state.muestraCarga)
                          SizedBox(height: size.height * 0.15),
                          
                          if(lstActividadesDiariasByProspecto.isEmpty && !state.muestraCarga)
                          Container(
                            color: Colors.transparent,
                            width: size.width * 0.95,
                            height: size.height * 0.09,
                            alignment: Alignment.topCenter,
                            child: const AutoSizeText('No existen actividades agendadas para el día de hoy', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,), maxLines: 2,  presetFontSizes: [42,40,38,36,34,32,30,28,26,24,22,20,18,16,14,12,10]),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              );
          
            }

            return Container();
          }
        );
        */
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
                          style: AppTextStyles.bodyRegular(width: size.width),
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
              Icon(Icons.phone, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

bool muestraCargaLocal = false;

MensajesAlertas objMsmsAlert = MensajesAlertas();
late TextEditingController filtroAgendaTxtByFiltroCal;
DatumActivitiesResponse? objCalendarioActividadescogidaByFiltroCal;
int idActividadSeleccionadaByFiltroCal = 0;
List<DateTime> _datesByFiltroCal = [];
String terminoBusquedaActAgendaByFiltroCal = '';
DateTime selectedDayGenByFiltroCal = DateTime.now();
DateTime focusedDayGenByFiltroCal = DateTime.now();
//int tabAccionesCal = 0;
List<bool> actualizaListaActAgendaByFiltro2CalCal = [
  false,
  true
]; // 'Mes' está seleccionado inicialmente
bool actualizaListaActAgendaByFiltro2 = false;
List<DatumActivitiesResponse> calendarioActividadesFilAgendaByFiltroCall = [];
int contLstAgendaByFiltroCal = 0;
bool buscaXCalendarioCal = false;

class CalendarioActividadesByFiltroView extends StatefulWidget {
  const CalendarioActividadesByFiltroView(Key? key) : super(key: key);

  @override
  State<CalendarioActividadesByFiltroView> createState() =>
      CalendarioActividadesByFiltroViewState();
}

class CalendarioActividadesByFiltroViewState extends State<CalendarioActividadesByFiltroView> {
  //late Future<ActivitiesPageModel> futureActivitiesPageModel;

  CalendarFormat calendarFormat = CalendarFormat.week;
  ColorsApp objColorsApp = ColorsApp();
  ScrollController scrollListaClt = ScrollController();

  @override
  void initState() {
    super.initState();
    muestraCargaLocal = true;
    objCalendarioActividadescogidaByFiltroCal = null;
    idActividadSeleccionadaByFiltroCal = 0;
    terminoBusquedaActAgendaByFiltroCal = '';
    actualizaListaActAgendaByFiltro2 = false;
    _datesByFiltroCal = [];
    calendarioActividadesFilAgendaByFiltroCall = [];
    contLstAgendaByFiltroCal = 0;
    actualizaListaActAgendaByFiltro2CalCal = [false, true];
    selectedDayGenByFiltroCal = DateTime.now();
    focusedDayGenByFiltroCal = DateTime.now();
    filtroAgendaTxtByFiltroCal = TextEditingController();
    //futureActivitiesPageModel = ActivitiesService().getActivitiesByRangoFechas('mem', 0);

    WidgetsBinding.instance.addPostFrameCallback((_) async {

      final gnrBloc = Provider.of<GenericBloc>(context, listen: false);
      final actBloc = Provider.of<ActivitiesBloc>(context, listen: false);

      gnrBloc.setMuestraCarga(true);
      actBloc.setLstActividades([]);

      ActivitiesPageModel objRsp = await ActivitiesService().getActivitiesByRangoFechas('mem', 0);

      actBloc.setLstActividades(objRsp.activities.data);
      gnrBloc.setMuestraCarga(false);
      muestraCargaLocal = false;
    });
  }

  Future<void> refreshDataAgenda() async {
    String resInt = await ValidacionesUtils().validaInternet();

    showDialog(
      //ignore:use_build_context_synchronously
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          SimpleDialog(alignment: Alignment.center, children: [
        SimpleDialogCargando(
          null,
          mensajeMostrar: 'Estamos consultando',
          mensajeMostrarDialogCargando: 'el listado de CalendarioActividades.',
        ),
      ]),
    );

    if (resInt.isEmpty) {
      //var rspPrsp = await ActivitiesService().getActivitiesByRangoFechas('mem', 0);
      ActivitiesPageModel rspPrsp = await ActivitiesService()
          .getActivitiesByRangoFechas(
              _datesByFiltroCal.isNotEmpty ? _datesByFiltroCal : 'mem',
              objDatumCrmLead?.id ?? 0);

      //ActivitiesPageModel rspAct = ActivitiesPageModel;

      contLstAgendaByFiltroCal = rspPrsp.activities.data.length;
      calendarioActividadesFilAgendaByFiltroCall = rspPrsp.activities.data;

      //ignore:use_build_context_synchronously
      context.pop();

      // Refresca los datos llamando a la misma función de carga
      setState(() {});
    } else {
      //ignore:use_build_context_synchronously
      context.pop();

      showDialog(
        barrierDismissible: false,
        //ignore:use_build_context_synchronously
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
              numLineasTitulo: 1,
              numLineasMensaje: 1,
              titulo: 'Error',
              mensajeAlerta: objMsmsAlert.mensajeOffLine);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final gnrBloc = Provider.of<GenericBloc>(context);
    final actBloc = Provider.of<ActivitiesBloc>(context);


    return BlocBuilder<GenericBloc, GenericState>(
      builder: (context, state) {
      
      return BlocBuilder<ActivitiesBloc, ActivitiesState>(
        builder: (context, stateAct) {

          Future<void> refreshDataByFiltro(String filtro) async {
            muestraCargaLocal = true;
            gnrBloc.setMuestraCarga(true);
            calendarioActividadesFilAgendaByFiltroCall = [];

            if (filtro.isNotEmpty) {

              if(stateAct.lstActivitiesResp.length > stateAct.lstActivities.length){
                actBloc.setLstActividades(stateAct.lstActivitiesResp);
              }

              if(stateAct.lstActivities.isEmpty) return;

              List<DatumActivitiesResponse> lstTemp = [];

              calendarioActividadesFilAgendaByFiltroCall = [];

              calendarioActividadesFilAgendaByFiltroCall = stateAct.lstActivities;
              actBloc.setLstActividadesResp([]);
              actBloc.setLstActividadesResp(stateAct.lstActivities);

              for(int i = 0; i < calendarioActividadesFilAgendaByFiltroCall.length; i++){
                if((calendarioActividadesFilAgendaByFiltroCall[i].leadName != null && calendarioActividadesFilAgendaByFiltroCall[i].leadName!.toUpperCase().contains(filtro.toUpperCase()))
                || (calendarioActividadesFilAgendaByFiltroCall[i].summary != null && calendarioActividadesFilAgendaByFiltroCall[i].summary!.toUpperCase().contains(filtro.toUpperCase()))){
                  lstTemp.add(calendarioActividadesFilAgendaByFiltroCall[i]);
                }
              }

              actBloc.setLstActividades(lstTemp);

            }

            if(filtro.isEmpty && stateAct.lstActivitiesResp.length > stateAct.lstActivities.length){
              actBloc.setLstActividades(stateAct.lstActivitiesResp);
            }

            muestraCargaLocal = false;

            gnrBloc.setMuestraCarga(false);
            //setState(() {});
          }

          final themeProvider = Provider.of<ThemeProvider>(context);

          //hint: Text('Selecciona un mes', style: TextStyle(color: themeProvider.themeMode.index == 0 || themeProvider.themeMode.index == 2 ? Colors.white : Colors.black,),),

          return Container(
            width: size.width * 0.99,
            height: size.height,
            color: Colors.transparent,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.02,
                  ),

                  ToggleButtons(
                    borderColor: Colors.purple,
                    fillColor: Colors.purple,
                    borderWidth: 2,
                    selectedBorderColor: Colors.purple,
                    selectedColor: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    onPressed: (int index) {
                      muestraCargaLocal = true;
                      actBloc.setLstActividades([]);
                      selectedDayGenByFiltroCal = DateTime.now();
                      focusedDayGenByFiltroCal = DateTime.now();

                      setState(() {
                        for (int i = 0; i < actualizaListaActAgendaByFiltro2CalCal.length; i++) {
                          actualizaListaActAgendaByFiltro2CalCal[i] = i == index;
                        }
                      });

                      WidgetsBinding.instance.addPostFrameCallback((_) async {

                        _datesByFiltroCal = [];
                        _datesByFiltroCal.add(DateTime.now());

                        ActivitiesPageModel objRsp = await ActivitiesService().getActivitiesByRangoFechas(_datesByFiltroCal, objDatumCrmLead?.id ?? 0);

                        actBloc.setLstActividades(objRsp.activities.data);
                        gnrBloc.setMuestraCarga(false);
                        muestraCargaLocal = false;
                      });
                    },
                    isSelected: actualizaListaActAgendaByFiltro2CalCal,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'Mes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: actualizaListaActAgendaByFiltro2CalCal[0] ? Colors.white : themeProvider.themeMode.index == 2 ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'Semana',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: actualizaListaActAgendaByFiltro2CalCal[1] ? Colors.white : themeProvider.themeMode.index == 2 ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  if (actualizaListaActAgendaByFiltro2CalCal[0])
                    Container(
                        width: size.width * 0.95,
                        height: size.height * 0.39,
                        color: Colors.transparent,
                        child: CalendarDatePicker2(
                            config: CalendarDatePicker2Config(
                              calendarType: CalendarDatePicker2Type.range,
                              //lastDate: DateTime.now()
                            ),
                            value: _datesByFiltroCal,
                            onValueChanged: (dates) async {
                              _datesByFiltroCal = dates;

                              if (dates.length == 1) {
                                return;
                              }

                              muestraCargaLocal = true;
                              actBloc.setLstActividades([]);

                              calendarioActividadesFilAgendaByFiltroCall = [];

                              WidgetsBinding.instance.addPostFrameCallback((_) async {

                                ActivitiesPageModel objRsp = await ActivitiesService().getActivitiesByRangoFechas(dates, objDatumCrmLead?.id ?? 0);

                                actBloc.setLstActividades(objRsp.activities.data);
                                gnrBloc.setMuestraCarga(false);
                                muestraCargaLocal = false;

                                if(objRsp.activities.data.isEmpty){
                                  setState(() {
                                    return;
                                  });
                                }
                                
                              });

                              /*

                              ActivitiesPageModel objRsp = await ActivitiesService().getActivitiesByRangoFechas(dates, objDatumCrmLead?.id ?? 0);

                              calendarioActividadesFilAgendaByFiltroCall = objRsp.activities.data;
                              //rspAct = objRsp; //.activities;
                              actualizaListaActAgendaByFiltro2 = true;
                              contLstAgendaByFiltroCal = calendarioActividadesFilAgendaByFiltroCall.length;

                              gnrBloc.setMuestraCarga(false);
                              actBloc.setLstActividades(calendarioActividadesFilAgendaByFiltroCall);
*/
                              //setState(() {});
                            })),

                  if (actualizaListaActAgendaByFiltro2CalCal[1])
                    Container(
                        width: size.width * 0.95,
                        height: size.height * 0.2,
                        color: Colors.transparent,
                        child: TableCalendar(
                            headerStyle: const HeaderStyle(formatButtonVisible: false),
                            calendarFormat: calendarFormat,
                            firstDay: DateTime.utc(2010, 10, 16),
                            lastDay: DateTime(3000),
                            focusedDay: focusedDayGenByFiltroCal,
                            selectedDayPredicate: (day) {
                              return focusedDayGenByFiltroCal == day;
                            },
                            onDaySelected: (selectedDay, focusedDay) async {
                              muestraCargaLocal = true;
                              selectedDayGenByFiltroCal = selectedDay;
                              focusedDayGenByFiltroCal = focusedDay;
                              actBloc.setLstActividades([]);
                              gnrBloc.setMuestraCarga(true);

                              setState(() {});

                              WidgetsBinding.instance.addPostFrameCallback((_) async {

                                _datesByFiltroCal = [];
                                _datesByFiltroCal.add(selectedDay);

                                ActivitiesPageModel objRsp = await ActivitiesService().getActivitiesByRangoFechas(_datesByFiltroCal, objDatumCrmLead?.id ?? 0);

                                actBloc.setLstActividades(objRsp.activities.data);
                                gnrBloc.setMuestraCarga(false);
                                muestraCargaLocal = false;

                                if(objRsp.activities.data.isEmpty){
                                  setState(() {
                                    return;
                                  });
                                }

                              });

                            }
                            /*
                            onDaySelected: (selectedDay, focusedDay) async {
                              
                              // Solo cambiamos el estado si realmente hay una consulta que hacer
                              if (!isSameDay(selectedDayGenByFiltroCal, selectedDay)) {
                                
                                selectedDayGenByFiltroCal = selectedDay;
                                focusedDayGenByFiltroCal = focusedDay;

                                // Mostramos loader
                                gnrBloc.setMuestraCarga(true);

                                try {
                                  // Aquí llamas a tu servicio para obtener datos                                  
                                  calendarioActividadesFilAgendaByFiltroCall = [];

                                  _datesByFiltroCal = [];
                                  _datesByFiltroCal.add(selectedDay);
                                  actBloc.setLstActividades([]);

                                  ActivitiesPageModel objRsp = await ActivitiesService().getActivitiesByRangoFechas(_datesByFiltroCal, objDatumCrmLead?.id ?? 0);

                                  calendarioActividadesFilAgendaByFiltroCall = objRsp.activities.data;

                                  //rspAct = objRsp;
                                  //actualizaListaActAgendaByFiltro2 = true;
                                  contLstAgendaByFiltroCal = calendarioActividadesFilAgendaByFiltroCall.length;

                                  actBloc.setLstActividades(objRsp.activities.data);
                                  
                                } finally {
                                  // Ocultamos loader después de la carga
                                  gnrBloc.setMuestraCarga(false);
                                }

                              }
                              
                            },
                          */
                          )
                        ),

                  SizedBox(height: size.height * 0.008),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: filtroAgendaTxtByFiltroCal,
                      onChanged: (value) {
                        actualizaListaActAgendaByFiltro2 = true;
                        terminoBusquedaActAgendaByFiltroCal = value;
                      },
                      onEditingComplete: () async {
                        gnrBloc.setMuestraCarga(true);

                        refreshDataByFiltro(filtroAgendaTxtByFiltroCal.text);

                        //ignore: use_build_context_synchronously
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        labelText: 'Buscar agendas por nombre o tipo de actividad.',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () async {
                            gnrBloc.setMuestraCarga(true);

                            filtroAgendaTxtByFiltroCal.text = '';
                            terminoBusquedaActAgendaByFiltroCal = '';

                            refreshDataByFiltro('');
                          },
                          icon: Icon(Icons.cancel,
                            size: 24,
                            color: AppLightColors().gray900PrimaryText
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: size.height * 0.007),

                  if (muestraCargaLocal)
                    Container(
                      width: size.width,
                      height: actualizaListaActAgendaByFiltro2CalCal[1]
                          ? size.height * 0.53
                          : size.height * 0.33,
                      color: Colors.transparent,
                      child: Image.asset(
                        "assets/gifs/gif_carga.gif",
                        height: size.width * 0.85,
                        width: size.width * 0.85,
                      ),
                    ),

                  //if (contLstAgendaByFiltroCal > 0 && !state.muestraCarga && calendarioActividadesFilAgendaByFiltroCall.isNotEmpty)
                  if (stateAct.lstActivities.isNotEmpty && !muestraCargaLocal)
                    Container(
                      color: Colors.transparent,
                      width: size.width,
                      height: actualizaListaActAgendaByFiltro2CalCal[1]
                          ? size.height * 0.53
                          : size.height * 0.33,
                      child: ListView.builder(
                        controller: scrollListaClt,
                        itemCount: stateAct.lstActivities.length,//contLstAgendaByFiltroCal,
                        itemBuilder: (_, int index) {
                          return Slidable(
                              //key: ValueKey(lstCalendarioActividades[index].id),
                              startActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (cont) async {
                                        //if (calendarioActividadesFilAgendaByFiltroCall[index].cerrado) {
                                        if (stateAct.lstActivities[index].cerrado) {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder:
                                                (BuildContext context) {
                                              return ContentAlertDialog(
                                                  onPressed: () {
                                                    Navigator.of(
                                                            context)
                                                        .pop();
                                                  },
                                                  onPressedCont: () {
                                                    Navigator.of(
                                                            context)
                                                        .pop();
                                                  },
                                                  tipoAlerta:
                                                      TipoAlerta()
                                                          .alertAccion,
                                                  numLineasTitulo: 2,
                                                  numLineasMensaje: 2,
                                                  titulo: 'Error',
                                                  mensajeAlerta:
                                                      'Esta actividad ya fue cerrada.');
                                            },
                                          );

                                          return;
                                        }

                                        const storage =
                                            FlutterSecureStorage();

                                        await storage.write(
                                            key: 'idMem',
                                            value: stateAct.lstActivities[index].resId.toString());//calendarioActividadesFilAgendaByFiltroCall[index].resId.toString());

                                        await storage.write(
                                            key: 'fecMem',
                                            value: DateFormat('yyyy-MM-dd', 'es').format(stateAct.lstActivities[index].dateDeadline));//calendarioActividadesFilAgendaByFiltroCall[index].dateDeadline));

                                        idActividadSeleccionadaByFiltroCal = stateAct.lstActivities[index].id;//calendarioActividadesFilAgendaByFiltroCall[index].id;

                                        objCalendarioActividadescogidaByFiltroCal = stateAct.lstActivities[index];//calendarioActividadesFilAgendaByFiltroCall[index];

                                        //ignore: use_build_context_synchronously
                                        context.push(objRutasGen
                                            .rutaPlanificacionActividades);
                                        //context.push(objRutasGen.rutaPlanificacionActividades);
                                      },
                                      backgroundColor: objColorsApp.fucsia,
                                      foregroundColor: Colors.white,
                                      icon: Icons.account_circle,
                                      label: 'Cierre de Calendario de Actividades',
                                    )
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: stateAct.lstActivities[index].cerrado//calendarioActividadesFilAgendaByFiltroCall[index].cerrado
                                          ? Colors.grey[300]
                                          : Colors.white,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: stateAct.lstActivities[index].cerrado//calendarioActividadesFilAgendaByFiltroCall[index].cerrado
                                              ? Colors.black45
                                              : Colors.grey[300],
                                      child: Stack(children: [
                                        Icon(Icons.person, color: themeProvider.themeMode.index == 2 ? Colors.black : Colors.white,),
                                        //if (!calendarioActividadesFilAgendaByFiltroCall[index].cerrado && DateFormat('yyyy-MM-dd','es').format(calendarioActividadesFilAgendaByFiltroCall[index].dateDeadline) == DateFormat('yyyy-MM-dd','es').format(DateTime.now()))
                                        if (!stateAct.lstActivities[index].cerrado && DateFormat('yyyy-MM-dd','es').format(stateAct.lstActivities[index].dateDeadline) == DateFormat('yyyy-MM-dd','es').format(DateTime.now()))
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
                                      ]),
                                    ),
                                    //title: Text(calendarioActividadesFilAgendaByFiltroCall[index].summary ??''),
                                    title: Text(stateAct.lstActivities[index].summary ??'', style: const TextStyle(color: Colors.black),),
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
                                                //text: calendarioActividadesFilAgendaByFiltroCall[index].activityTypeId.name,
                                                text: stateAct.lstActivities[index].activityTypeId.name,
                                                style: const TextStyle(
                                                  color:
                                                      Colors.blueGrey,
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
                                                text:
                                                    'Fecha planificada:',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              TextSpan(
                                                //text: DateFormat('yyyy-MM-dd','es').format(calendarioActividadesFilAgendaByFiltroCall[index].dateDeadline),
                                                text: DateFormat('yyyy-MM-dd','es').format(stateAct.lstActivities[index].dateDeadline),
                                                style: const TextStyle(
                                                  color:
                                                      Colors.blueGrey,
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
                              ));
                        },
                      ),
                    ),
                  
                  //if (contLstAgendaByFiltroCal == 0)
                  if (!muestraCargaLocal && stateAct.lstActivities.isEmpty)
                    Container(
                      width: size.width * 0.9,
                      height: actualizaListaActAgendaByFiltro2CalCal[1]
                          ? size.height * 0.5
                          : size.height * 0.2,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            color: Colors.transparent,
                            width: size.width * 0.95,
                            height: size.height * 0.09,
                            alignment: Alignment.topCenter,
                            child: const AutoSizeText(
                                'No existen actividades agendadas para la fecha seleccionada',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                presetFontSizes: [
                                  42,
                                  40,
                                  38,
                                  36,
                                  34,
                                  32,
                                  30,
                                  28,
                                  26,
                                  24,
                                  22,
                                  20,
                                  18,
                                  16,
                                  14,
                                  12,
                                  10
                                ]),
                          ),
                        ],
                      ),
                    ),
                  
                  SizedBox(
                    height: size.height * 0.02,
                  )
                ],
              ),
            ),
          );
                
        },
      );
    });
  }

  // Widget para los botones de Mes/Semana
  Widget buildToggleButton(
      String text, bool actualizaListaActAgendaByFiltro2CalCal) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(          
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  // Widget para cada elemento de la agenda
  Widget buildAgendaItem() {
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

              const Text('Tipo de Agenda: Llamada',
                  style: TextStyle(fontSize: 12)),
              const Text('Activo',
                  style: TextStyle(fontSize: 12, color: Colors.green)),
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
}

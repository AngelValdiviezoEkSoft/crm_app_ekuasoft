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

MensajesAlertas objMsmsAlert = MensajesAlertas();
late TextEditingController filtroAgendaTxtByFiltroCal;
DatumActivitiesResponse? objCalendarioActividadescogidaByFiltroCal;
int idActividadSeleccionadaByFiltroCal = 0;
List<DateTime> _datesByFiltroCal = [];
String terminoBusquedaActAgendaByFiltroCal = '';
DateTime selectedDayGenByFiltroCal = DateTime.now();
DateTime focusedDayGenByFiltroCal = DateTime.now();
//int tabAccionesCal = 0;
List<bool> actualizaListaActAgendaByFiltro2CalCal = [false,true ]; // 'Mes' está seleccionado inicialmente
bool actualizaListaActAgendaByFiltro2 = false;
List<DatumActivitiesResponse> calendarioActividadesFilAgendaByFiltroCall = [];
int contLstAgendaByFiltroCal = 0;
bool buscaXCalendarioCal = false;

class CalendarioActividadesByFiltroView extends StatefulWidget {
  
  const CalendarioActividadesByFiltroView(Key? key) : super(key: key);

  @override
  State<CalendarioActividadesByFiltroView> createState() => CalendarioActividadesByFiltroViewState();

}


class CalendarioActividadesByFiltroViewState extends State<CalendarioActividadesByFiltroView>  {

  @override
  void initState() {
    super.initState();
    objCalendarioActividadescogidaByFiltroCal = null;
    idActividadSeleccionadaByFiltroCal = 0;
    terminoBusquedaActAgendaByFiltroCal = '';
    actualizaListaActAgendaByFiltro2 = false;
    _datesByFiltroCal = [];
    calendarioActividadesFilAgendaByFiltroCall = [];
    contLstAgendaByFiltroCal = 0;
    actualizaListaActAgendaByFiltro2CalCal = [false,true ];
    selectedDayGenByFiltroCal = DateTime.now();
    focusedDayGenByFiltroCal = DateTime.now();
    filtroAgendaTxtByFiltroCal = TextEditingController();
  }

  Future<void> refreshDataAgenda() async {

    String resInt = await ValidacionesUtils().validaInternet();

    showDialog(
      //ignore:use_build_context_synchronously
      context: context,
      barrierDismissible: false,
      builder: (context) => SimpleDialog(
        alignment: Alignment.center,
        children: [
          SimpleDialogCargando(
            null,
            mensajeMostrar: 'Estamos consultando',
            mensajeMostrarDialogCargando: 'el listado de CalendarioActividades.',
          ),
        ]
      ),
    );

    if(resInt.isEmpty){
      //var rspPrsp = await ActivitiesService().getActivitiesByRangoFechas('mem', 0);
      ActivitiesPageModel rspPrsp = await ActivitiesService().getActivitiesByRangoFechas(_datesByFiltroCal.isNotEmpty ? _datesByFiltroCal : 'mem', objDatumCrmLead?.id ?? 0);

      //ActivitiesPageModel rspAct = ActivitiesPageModel;
        
      contLstAgendaByFiltroCal = rspPrsp.activities.data.length;
      calendarioActividadesFilAgendaByFiltroCall = rspPrsp.activities.data;


      //ignore:use_build_context_synchronously
      context.pop();

      // Refresca los datos llamando a la misma función de carga
      setState(() {
        
      });
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
            mensajeAlerta: objMsmsAlert.mensajeOffLine
          );
        },
      );
    }

  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    CalendarFormat calendarFormat = CalendarFormat.week;
    ColorsApp objColorsApp = ColorsApp();
    ScrollController scrollListaClt = ScrollController();
    final gnrBloc = Provider.of<GenericBloc>(context);
    gnrBloc.setMuestraCarga(false);

    return BlocBuilder<GenericBloc, GenericState>(
      builder: (context, state) {
        return FutureBuilder(
          future: ActivitiesService().getActivitiesByRangoFechas('mem', 0),//getActivitiesByFecha(DateFormat('yyyy-MM-dd', 'es').format(DateTime.now())),//),
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
            
            if(snapshot.hasData && snapshot.data != null) {
        
              ActivitiesPageModel rspAct = snapshot.data as ActivitiesPageModel;
        
              if(!actualizaListaActAgendaByFiltro2)
              {
                contLstAgendaByFiltroCal = rspAct.activities.data.length;
                calendarioActividadesFilAgendaByFiltroCall = rspAct.activities.data;
              }
        
              Future<void> refreshDataByFiltro(String filtro) async {            
                gnrBloc.setMuestraCarga(true);
                calendarioActividadesFilAgendaByFiltroCall = [];
        
                if(filtro.isNotEmpty){
                  
                  for(int i = 0; i < rspAct.activities.data.length; i++){
                    if(rspAct.activities.data[i].summary != null && 
                    rspAct.activities.data[i].summary!.toLowerCase().contains(filtro.toLowerCase()) 
                    || (rspAct.activities.data[i].activityTypeId.name.toLowerCase().contains(filtro.toLowerCase()))){
                      calendarioActividadesFilAgendaByFiltroCall.add(rspAct.activities.data[i]);
                    }
                  }
                  gnrBloc.setMuestraCarga(false);
        
        /*
                  if(calendarioActividadesFilAgendaByFiltroCall.isEmpty){
                    for(int i = 0; i < rspAct.activities.data.length; i++){
                      if(rspAct.activities.data[i].summary != null && 
                      rspAct.activities.data[i].summary!.toLowerCase().contains(filtro.toLowerCase())
                      ){
                        calendarioActividadesFilAgendaByFiltroCall.add(rspAct.activities.data[i]);
                      }
                    }
                  }
        
                  if(calendarioActividadesFilAgendaByFiltroCall.isEmpty){
                    for(int i = 0; i < rspAct.activities.data.length; i++){
                      if(rspAct.activities.data[i].activityTypeId.name.toLowerCase().contains(filtro.toLowerCase())){
                        calendarioActividadesFilAgendaByFiltroCall.add(rspAct.activities.data[i]);
                      }
                    }
                  }
                  */
        
                  contLstAgendaByFiltroCal = 0;
        
                  contLstAgendaByFiltroCal = calendarioActividadesFilAgendaByFiltroCall.length;
                } else{
                  calendarioActividadesFilAgendaByFiltroCall = rspAct.activities.data;
                  actualizaListaActAgendaByFiltro2 = false;
                }            
        
                gnrBloc.setMuestraCarga(false);
                setState(() {});
        
              }
        
                  return 
                    Container(
                      width: size.width * 0.99,
                      height: size.height,
                      color: Colors.transparent,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            
                            SizedBox(height:  size.height * 0.02,),
                  
                            ToggleButtons(
                              borderColor: Colors.purple,
                              fillColor: Colors.purple,
                              borderWidth: 2,
                              selectedBorderColor: Colors.purple,
                              selectedColor: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              onPressed: (int index) {
                                setState(() {
                                  for (int i = 0; i < actualizaListaActAgendaByFiltro2CalCal.length; i++) {
                                    actualizaListaActAgendaByFiltro2CalCal[i] = i == index;
                                  }
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
                                      color: actualizaListaActAgendaByFiltro2CalCal[0] ? Colors.white : Colors.black,
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
                                      color: actualizaListaActAgendaByFiltro2CalCal[1] ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                              
                            ),
                            
                            if(actualizaListaActAgendaByFiltro2CalCal[0])
                            Container(
                              width: size.width *0.95,
                              height: size.height * 0.39,
                              color: Colors.transparent,
                              child: CalendarDatePicker2(
                                config: CalendarDatePicker2Config(
                                  calendarType: CalendarDatePicker2Type.range,
                                  lastDate: DateTime.now()
                                ),
                                value: _datesByFiltroCal,
                                onValueChanged: (dates) async {
                                  gnrBloc.setMuestraCarga(true);
                                  _datesByFiltroCal = dates;
                  
                                  if(dates.length == 1)
                                  {
                                    return;
                                  }
                  
                                  ActivitiesPageModel objRsp = await ActivitiesService().getActivitiesByRangoFechas(dates, objDatumCrmLead?.id ?? 0);
                  
                                  calendarioActividadesFilAgendaByFiltroCall = [];
                                  calendarioActividadesFilAgendaByFiltroCall = objRsp.activities.data;                                  
                  
                                  setState(() {
                                    rspAct = objRsp;//.activities;
                                    actualizaListaActAgendaByFiltro2 = true;
                                    contLstAgendaByFiltroCal = calendarioActividadesFilAgendaByFiltroCall.length;
                                  });
                                }
                              )                          
                            ),
                  
                            if(actualizaListaActAgendaByFiltro2CalCal[1])
                            Container(
                              width: size.width *0.95,
                              height: size.height * 0.2,
                              color: Colors.transparent,
                              child: TableCalendar(     
                                headerStyle: const HeaderStyle(formatButtonVisible: false),
                                calendarFormat: calendarFormat,
                                firstDay: DateTime.utc(2010, 10, 16),
                                lastDay: DateTime.now(),
                                focusedDay: focusedDayGenByFiltroCal,
                                selectedDayPredicate: (day) {
                                  return focusedDayGenByFiltroCal == day;
                                },
                                onDaySelected: (selectedDay, focusedDay) async {
                                  gnrBloc.setMuestraCarga(true);
                                  _datesByFiltroCal = [];
                                  _datesByFiltroCal.add(selectedDay);
                  
                                  ActivitiesPageModel objRsp = await ActivitiesService().getActivitiesByRangoFechas(_datesByFiltroCal, objDatumCrmLead?.id ?? 0);
                  
                                  calendarioActividadesFilAgendaByFiltroCall = [];
                                  calendarioActividadesFilAgendaByFiltroCall = objRsp.activities.data;                                  
                  
                                  setState(() {                                                    
                                    rspAct = objRsp;
                                    actualizaListaActAgendaByFiltro2 = true;
                                    contLstAgendaByFiltroCal = calendarioActividadesFilAgendaByFiltroCall.length;
                  
                                    selectedDayGenByFiltroCal = selectedDay;
                                    focusedDayGenByFiltroCal = focusedDay; // update `focusedDayGenByFiltroCal` here as well
                                  });
                                }
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
                                  
                                  if(actualizaListaActAgendaByFiltro2CalCal[0]){//MES
                                    if(filtroAgendaTxtByFiltroCal.text.isEmpty){
                                      FocusScope.of(context).unfocus();
                                      return;
                                    }
                  
                                    if(_datesByFiltroCal.length == 1)
                                    {
                                      FocusScope.of(context).unfocus();
                                      return;
                                    }
                                    ActivitiesPageModel objRsp = await ActivitiesService().getActivitiesByRangoFechas(_datesByFiltroCal, objDatumCrmLead?.id ?? 0);
                  
                                    calendarioActividadesFilAgendaByFiltroCall = [];
                                    calendarioActividadesFilAgendaByFiltroCall = objRsp.activities.data;
                  
                                    setState(() {
                                      rspAct = objRsp;//.activities;
                                      actualizaListaActAgendaByFiltro2 = true;
                                      contLstAgendaByFiltroCal = calendarioActividadesFilAgendaByFiltroCall.length;
                                    });
                  
                                    refreshDataByFiltro(filtroAgendaTxtByFiltroCal.text);
                                  }
                  
                                  if(filtroAgendaTxtByFiltroCal.text.isNotEmpty){
                                    refreshDataByFiltro(filtroAgendaTxtByFiltroCal.text);
                                  }
        
                                  gnrBloc.setMuestraCarga(false);
                                  
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
                                        
                                        if(actualizaListaActAgendaByFiltro2CalCal[0]){//MES
                                          
                                          if(_datesByFiltroCal.length == 1)
                                          {
                                            gnrBloc.setMuestraCarga(false);
                                            return;
                                          }
                                          ActivitiesPageModel objRsp = await ActivitiesService().getActivitiesByRangoFechas(_datesByFiltroCal, objDatumCrmLead?.id ?? 0);
                  
                                          calendarioActividadesFilAgendaByFiltroCall = [];
                                          calendarioActividadesFilAgendaByFiltroCall = objRsp.activities.data;
                  
                                          setState(() {
                                            rspAct = objRsp;//.activities;
                                            actualizaListaActAgendaByFiltro2 = true;
                                            contLstAgendaByFiltroCal = calendarioActividadesFilAgendaByFiltroCall.length;
                                          });  
                  
                                          return;
                                        }
        
                                        refreshDataByFiltro('');
                                      },
                                      icon: Icon(Icons.cancel,
                                          size: 24,
                                          color: AppLightColors()
                                              .gray900PrimaryText),
                                    ),
                                ),
                              ),
                            ),
                  
                            SizedBox(height: size.height * 0.007),
        
                            if(state.muestraCarga)
                            Container(
                              width: size.width,
                              height: actualizaListaActAgendaByFiltro2CalCal[1] ? size.height * 0.53 : size.height * 0.33,
                              color: Colors.transparent,
                              child: Image.asset(
                                "assets/gifs/gif_carga.gif",
                                height: size.width * 0.85,
                                width: size.width * 0.85,
                              ),
                            ),
                  
                            if(contLstAgendaByFiltroCal > 0 && !state.muestraCarga)
                            Container(
                              color: Colors.transparent,
                              width: size.width,
                              height: actualizaListaActAgendaByFiltro2CalCal[1] ? size.height * 0.53 : size.height * 0.33,
                              child: ListView.builder(
                                controller: scrollListaClt,
                                itemCount: contLstAgendaByFiltroCal,
                                itemBuilder: ( _, int index ) {
                  
                                  return Slidable(
                                    //key: ValueKey(lstCalendarioActividades[index].id),
                                    startActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (cont) async {
                  
                                              if(calendarioActividadesFilAgendaByFiltroCall[index].cerrado){
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
                                                      mensajeAlerta: 'Esta actividad ya fue cerrada.'
                                                    );
                                                  },
                                                );
                              
                                                return;
                                              }
                  
                                              const storage = FlutterSecureStorage();
                    
                                              await storage.write(key: 'idMem', value: calendarioActividadesFilAgendaByFiltroCall[index].resId.toString());
                                              await storage.write(key: 'fecMem', value: DateFormat('yyyy-MM-dd', 'es').format(calendarioActividadesFilAgendaByFiltroCall[index].dateDeadline));
                                              
                                              idActividadSeleccionadaByFiltroCal = calendarioActividadesFilAgendaByFiltroCall[index].id;
                  
                                              objCalendarioActividadescogidaByFiltroCal = calendarioActividadesFilAgendaByFiltroCall[index];
                  
                                              //ignore: use_build_context_synchronously
                                              //context.push(objRutasGen.rutaPlanificacionCalendarioActividades);
                                              
                                            },
                                            backgroundColor: objColorsApp.fucsia,
                                            foregroundColor: Colors.white,
                                            icon: Icons.account_circle,
                                            label: 'Cierre de Calendario de Actividades',
                                          )
                                        ]
                                    ),
                                    child:  Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                                      child: Card(
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        color: calendarioActividadesFilAgendaByFiltroCall[index].cerrado ? Colors.grey[300] : Colors.white,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: calendarioActividadesFilAgendaByFiltroCall[index].cerrado ? Colors.black45 : Colors.grey[300],
                                            child: Stack(
                                                children: [
                                                  const Icon(Icons.person),
                                                  if(!calendarioActividadesFilAgendaByFiltroCall[index].cerrado && DateFormat('yyyy-MM-dd', 'es').format(calendarioActividadesFilAgendaByFiltroCall[index].dateDeadline) == DateFormat('yyyy-MM-dd', 'es').format(DateTime.now()))
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
                                          title: Text(calendarioActividadesFilAgendaByFiltroCall[index].summary ?? ''),
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
                                                      text: calendarioActividadesFilAgendaByFiltroCall[index].activityTypeId.name,
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
                                                      text: DateFormat('yyyy-MM-dd', 'es').format(calendarioActividadesFilAgendaByFiltroCall[index].dateDeadline),
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
                  
                            if(contLstAgendaByFiltroCal == 0)
                            Container(
                              width: size.width * 0.9,
                              height: actualizaListaActAgendaByFiltro2CalCal[1] ? size.height * 0.5 : size.height * 0.2,
                              color: Colors.transparent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  /*
                                  Container(
                                    color: Colors.transparent,
                                    width: size.width * 0.95,
                                    height: size.height * 0.09,
                                    alignment: Alignment.center,
                                    child: AutoSizeText('¡HEY!', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'AristotelicaDisplayDemiBoldTrial',color: objColorsApp.naranjaIntenso,), maxLines: 1,  presetFontSizes: const [58,56,54,52,50,48,46,44,42,40,38,36,34,32,30,28,26,24,22,20,18,16,14,12,10]),
                                  ),
                                  */
                                  Container(
                                    color: Colors.transparent,
                                    width: size.width * 0.95,
                                    height: size.height * 0.09,
                                    alignment: Alignment.topCenter,
                                    child: const AutoSizeText('No existen actividades agendadas para la fecha seleccionada', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,), maxLines: 2,  presetFontSizes: [42,40,38,36,34,32,30,28,26,24,22,20,18,16,14,12,10]),
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
            }
        
            return Center(
              child: Container(
                color: Colors.transparent,
                child: Image.asset('assets/gifs/gif_carga.gif'),
              ),
            );
          }
        );
      }
    );
  }

  // Widget para los botones de Mes/Semana
  Widget buildToggleButton(String text, bool actualizaListaActAgendaByFiltro2CalCal) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          /*
          primary: actualizaListaActAgendaByFiltro2CalCal ? Colors.blue : Colors.grey[200],
          onPrimary: actualizaListaActAgendaByFiltro2CalCal ? Colors.white : Colors.black,
          */
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
}

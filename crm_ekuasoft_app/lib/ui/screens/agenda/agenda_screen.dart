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

MensajesAlertas objMensajesAlertasAgenda = MensajesAlertas();
late TextEditingController filtroAgendaTxt;
DatumActivitiesResponse? objActividadEscogida;
int idActividadSeleccionada = 0;
List<DateTime> _dates = [];
String terminoBusquedaActAgenda = '';
DateTime selectedDayGen = DateTime.now();
DateTime focusedDayGen = DateTime.now();
//int tabAccionesCal = 0;
List<bool> isSelected = [false,true ]; // 'Mes' está seleccionado inicialmente
bool actualizaListaActAgenda = false;
List<DatumActivitiesResponse> actividadesFilAgenda = [];
int contLstAgenda = 0;
bool entraXActividad = false;

class AgendaScreen extends StatefulWidget {
  
  const AgendaScreen(Key? key) : super(key: key);

  @override
  State<AgendaScreen> createState() => AgendaScreenState();

}


class AgendaScreenState extends State<AgendaScreen>  {

  @override
  void initState() {
    super.initState();
    objActividadEscogida = null;
    idActividadSeleccionada = 0;
    terminoBusquedaActAgenda = '';
    actualizaListaActAgenda = false;
    _dates = [];
    actividadesFilAgenda = [];
    contLstAgenda = 0;
    isSelected = [false,true ];
    selectedDayGen = DateTime.now();
    focusedDayGen = DateTime.now();
    filtroAgendaTxt = TextEditingController();
    entraXActividad = false;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(actividadesFilAgendaPlanAct.isEmpty && lstActividadesDiariasByProspecto.isEmpty){
        await cargaActividadesRangoFechas();        
      }
      //ignore: use_build_context_synchronously
      final gnrBloc = Provider.of<GenericBloc>(context, listen: false);
      gnrBloc.setMuestraCarga(false);
    });

  }

  Future<void> cargaActividadesRangoFechas() async {
    try {
      final gnrBloc = Provider.of<GenericBloc>(context, listen: false);
      gnrBloc.setIniciaCarga(true);

      //ActivitiesService().getActivitiesByRangoFechas('mem', 0);

      ActivitiesPageModel? objRspFinal = await ActivitiesService().getActivitiesByRangoFechas('mem', 0);

      //ActivitiesPageModel? objRspFinal = await ActivitiesService().getActivitiesDiariasByProspecto(null, objDatumCrmLead?.id ?? 0);

      if(objRspFinal != null && actividadesFilAgenda.isEmpty){
        contLstAgenda = objRspFinal.activities.data.length;
        actividadesFilAgenda = objRspFinal.activities.data;
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
            mensajeMostrarDialogCargando: 'el listado de actividades.',
          ),
        ]
      ),
    );

    if(resInt.isEmpty){
      //var rspPrsp = await ActivitiesService().getActivitiesByRangoFechas('mem', 0);
      ActivitiesPageModel rspPrsp = await ActivitiesService().getActivitiesByRangoFechas(_dates.isNotEmpty ? _dates : 'mem', objDatumCrmLead?.id ?? 0);

      //ActivitiesPageModel rspAct = ActivitiesPageModel;
        
      contLstAgenda = rspPrsp.activities.data.length;
      actividadesFilAgenda = rspPrsp.activities.data;


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
            mensajeAlerta: objMensajesAlertasAgenda.mensajeOffLine
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

    Future<void> refreshDataByFiltro(String filtro) async {

      ActivitiesPageModel objActivitiesPageModel = ActivitiesService().getActivitiesByRangoFechas('mem', 0);

      gnrBloc.setMuestraCarga(true);
      actividadesFilAgenda = [];

      if(filtro.isNotEmpty){
        
        for(int i = 0; i < objActivitiesPageModel.activities.data.length; i++){
          if(objActivitiesPageModel.activities.data[i].summary != null && 
          objActivitiesPageModel.activities.data[i].summary!.toLowerCase().contains(filtro.toLowerCase()) 
          || (objActivitiesPageModel.activities.data[i].activityTypeId.name.toLowerCase().contains(filtro.toLowerCase()))){
            actividadesFilAgenda.add(objActivitiesPageModel.activities.data[i]);
          }
        }
        gnrBloc.setMuestraCarga(false);

        contLstAgenda = 0;

        contLstAgenda = actividadesFilAgenda.length;
      } else{
        actividadesFilAgenda = objActivitiesPageModel.activities.data;
        actualizaListaActAgenda = false;
      }

      gnrBloc.setMuestraCarga(false);
      setState(() {});

    }

    return BlocBuilder<GenericBloc, GenericState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: const Text("Agenda"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  context.pop();
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () async {
                    await refreshDataAgenda();
                  },
                ),
              ],
              backgroundColor: Colors.white,
              elevation: 0,
              foregroundColor: Colors.black,
            ),
            body: Container(
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
                          for (int i = 0; i < isSelected.length; i++) {
                            isSelected[i] = i == index;
                          }
                        });
                      },
                      isSelected: isSelected,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            'Mes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected[0] ? Colors.white : Colors.black,
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
                              color: isSelected[1] ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ],
                      
                    ),
                    
                    if(isSelected[0])
                    Container(
                      width: size.width *0.95,
                      height: size.height * 0.39,
                      color: Colors.transparent,
                      child: CalendarDatePicker2(
                        config: CalendarDatePicker2Config(
                          calendarType: CalendarDatePicker2Type.range,
                          lastDate: DateTime.now()
                        ),
                        value: _dates,
                        onValueChanged: (dates) async {
                          gnrBloc.setMuestraCarga(true);
                          _dates = dates;
          
                          if(dates.length == 1)
                          {
                            return;
                          }
          
                          ActivitiesPageModel objRsp = await ActivitiesService().getActivitiesByRangoFechas(dates, objDatumCrmLead?.id ?? 0);
          
                          actividadesFilAgenda = [];
                          actividadesFilAgenda = objRsp.activities.data;                                  
          
                          setState(() {
                            //rspAct = objRsp;//.activities;
                            actualizaListaActAgenda = true;
                            contLstAgenda = actividadesFilAgenda.length;
                          });
                        }
                      )                          
                    ),
          
                    if(isSelected[1])
                    Container(
                      width: size.width *0.95,
                      height: size.height * 0.2,
                      color: Colors.transparent,
                      child: TableCalendar(     
                        headerStyle: const HeaderStyle(formatButtonVisible: false),
                        calendarFormat: calendarFormat,
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.now(),
                        focusedDay: focusedDayGen,
                        selectedDayPredicate: (day) {
                          return focusedDayGen == day;
                        },
                        onDaySelected: (selectedDay, focusedDay) async {
                          gnrBloc.setMuestraCarga(true);
                          _dates = [];
                          _dates.add(selectedDay);
          
                          ActivitiesPageModel objRsp = await ActivitiesService().getActivitiesByRangoFechas(_dates, null);
          
                          actividadesFilAgenda = [];
                          actividadesFilAgenda = objRsp.activities.data;                                  
          
                          setState(() {                                                    
                            //rspAct = objRsp;
                            actualizaListaActAgenda = true;
                            contLstAgenda = actividadesFilAgenda.length;
          
                            selectedDayGen = selectedDay;
                            focusedDayGen = focusedDay; // update `focusedDayGen` here as well
                          });
                        }
                      )
                    ),
                    
                    SizedBox(height: size.height * 0.008),
          
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        controller: filtroAgendaTxt,
                        onChanged: (value) {
                          actualizaListaActAgenda = true;
                          terminoBusquedaActAgenda = value;                          
                        },
                        onEditingComplete: () async {

                          gnrBloc.setMuestraCarga(true);
                          
                          if(isSelected[0]){//MES
                            if(filtroAgendaTxt.text.isEmpty){
                              FocusScope.of(context).unfocus();
                              return;
                            }
          
                            if(_dates.length == 1)
                            {
                              FocusScope.of(context).unfocus();
                              return;
                            }
                            ActivitiesPageModel objRsp = await ActivitiesService().getActivitiesByRangoFechas(_dates, objDatumCrmLead?.id ?? 0);
          
                            actividadesFilAgenda = [];
                            actividadesFilAgenda = objRsp.activities.data;
          
                            setState(() {
                              //rspAct = objRsp;//.activities;
                              actualizaListaActAgenda = true;
                              contLstAgenda = actividadesFilAgenda.length;
                            });
          
                            refreshDataByFiltro(filtroAgendaTxt.text);
                          }
          
                          if(filtroAgendaTxt.text.isNotEmpty){
                            refreshDataByFiltro(filtroAgendaTxt.text);
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

                                filtroAgendaTxt.text = '';
                                terminoBusquedaActAgenda = '';
                                
                                if(isSelected[0]){//MES
                                  
                                  if(_dates.length == 1)
                                  {
                                    gnrBloc.setMuestraCarga(false);
                                    return;
                                  }
                                  ActivitiesPageModel objRsp = await ActivitiesService().getActivitiesByRangoFechas(_dates, objDatumCrmLead?.id ?? 0);
          
                                  actividadesFilAgenda = [];
                                  actividadesFilAgenda = objRsp.activities.data;
          
                                  setState(() {
                                    //rspAct = objRsp;//.activities;
                                    actualizaListaActAgenda = true;
                                    contLstAgenda = actividadesFilAgenda.length;
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

                    if(state.inicioCarga)
                    Container(
                      width: size.width,
                      height: isSelected[1] ? size.height * 0.53 : size.height * 0.33,
                      color: Colors.transparent,
                      child: Image.asset(
                        "assets/gifs/gif_carga.gif",
                        height: size.width * 0.85,
                        width: size.width * 0.85,
                      ),
                    ),
          
                    if(contLstAgenda > 0 && !state.inicioCarga)
                    Container(
                      color: Colors.transparent,
                      width: size.width,
                      height: isSelected[1] ? size.height * 0.53 : size.height * 0.33,
                      child: ListView.builder(
                        controller: scrollListaClt,
                        itemCount: contLstAgenda,
                        itemBuilder: ( _, int index ) {
          
                          return Slidable(
                            //key: ValueKey(lstActividades[index].id),
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (cont) async {
          
                                      if(actividadesFilAgenda[index].cerrado){
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
            
                                      await storage.write(key: 'idMem', value: actividadesFilAgenda[index].resId.toString());
                                      await storage.write(key: 'fecMem', value: DateFormat('yyyy-MM-dd', 'es').format(actividadesFilAgenda[index].dateDeadline));
                                      
                                      idActividadSeleccionada = actividadesFilAgenda[index].id;
          
                                      entraXActividad = true;
                                      objActividadEscogida = actividadesFilAgenda[index];
          
                                      //ignore: use_build_context_synchronously
                                      context.push(objRutasGen.rutaPlanificacionActividades);
                                      
                                    },
                                    backgroundColor: objColorsApp.fucsia,
                                    foregroundColor: Colors.white,
                                    icon: Icons.account_circle,
                                    label: 'Cierre de Actividades',
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
                                color: actividadesFilAgenda[index].cerrado ? Colors.grey[300] : Colors.white,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: actividadesFilAgenda[index].cerrado ? Colors.black45 : Colors.grey[300],
                                    child: Stack(
                                        children: [
                                          const Icon(Icons.person),
                                          if(!actividadesFilAgenda[index].cerrado && DateFormat('yyyy-MM-dd', 'es').format(actividadesFilAgenda[index].dateDeadline) == DateFormat('yyyy-MM-dd', 'es').format(DateTime.now()))
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
                                  title: Text(actividadesFilAgenda[index].summary ?? ''),
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
                                              text: actividadesFilAgenda[index].activityTypeId.name,
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
                                              text: DateFormat('yyyy-MM-dd', 'es').format(actividadesFilAgenda[index].dateDeadline),
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
          
                    if(contLstAgenda == 0)
                    Container(
                      width: size.width * 0.9,
                      height: isSelected[1] ? size.height * 0.5 : size.height * 0.2,
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
            ),
          );
                
        /*
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
        
              if(!actualizaListaActAgenda)
              {
                contLstAgenda = rspAct.activities.data.length;
                actividadesFilAgenda = rspAct.activities.data;
              }
        
              Future<void> refreshDataByFiltro(String filtro) async {            
                gnrBloc.setMuestraCarga(true);
                actividadesFilAgenda = [];
        
                if(filtro.isNotEmpty){
                  
                  for(int i = 0; i < rspAct.activities.data.length; i++){
                    if(rspAct.activities.data[i].summary != null && 
                    rspAct.activities.data[i].summary!.toLowerCase().contains(filtro.toLowerCase()) 
                    || (rspAct.activities.data[i].activityTypeId.name.toLowerCase().contains(filtro.toLowerCase()))){
                      actividadesFilAgenda.add(rspAct.activities.data[i]);
                    }
                  }
                  gnrBloc.setMuestraCarga(false);
        
                  contLstAgenda = 0;
        
                  contLstAgenda = actividadesFilAgenda.length;
                } else{
                  actividadesFilAgenda = rspAct.activities.data;
                  actualizaListaActAgenda = false;
                }            
        
                gnrBloc.setMuestraCarga(false);
                setState(() {});
        
              }
        
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text("Agenda"),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () async {
                            await refreshDataAgenda();
                          },
                        ),
                      ],
                      backgroundColor: Colors.white,
                      elevation: 0,
                      foregroundColor: Colors.black,
                    ),
                    body: Container(
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
                                  for (int i = 0; i < isSelected.length; i++) {
                                    isSelected[i] = i == index;
                                  }
                                });
                              },
                              isSelected: isSelected,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                  child: Text(
                                    'Mes',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected[0] ? Colors.white : Colors.black,
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
                                      color: isSelected[1] ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                              
                            ),
                            
                            if(isSelected[0])
                            Container(
                              width: size.width *0.95,
                              height: size.height * 0.39,
                              color: Colors.transparent,
                              child: CalendarDatePicker2(
                                config: CalendarDatePicker2Config(
                                  calendarType: CalendarDatePicker2Type.range,
                                  lastDate: DateTime.now()
                                ),
                                value: _dates,
                                onValueChanged: (dates) async {
                                  gnrBloc.setMuestraCarga(true);
                                  _dates = dates;
                  
                                  if(dates.length == 1)
                                  {
                                    return;
                                  }
                  
                                  ActivitiesPageModel objRsp = await ActivitiesService().getActivitiesByRangoFechas(dates, objDatumCrmLead?.id ?? 0);
                  
                                  actividadesFilAgenda = [];
                                  actividadesFilAgenda = objRsp.activities.data;                                  
                  
                                  setState(() {
                                    rspAct = objRsp;//.activities;
                                    actualizaListaActAgenda = true;
                                    contLstAgenda = actividadesFilAgenda.length;
                                  });
                                }
                              )                          
                            ),
                  
                            if(isSelected[1])
                            Container(
                              width: size.width *0.95,
                              height: size.height * 0.2,
                              color: Colors.transparent,
                              child: TableCalendar(     
                                headerStyle: const HeaderStyle(formatButtonVisible: false),
                                calendarFormat: calendarFormat,
                                firstDay: DateTime.utc(2010, 10, 16),
                                lastDay: DateTime.now(),
                                focusedDay: focusedDayGen,
                                selectedDayPredicate: (day) {
                                  return focusedDayGen == day;
                                },
                                onDaySelected: (selectedDay, focusedDay) async {
                                  gnrBloc.setMuestraCarga(true);
                                  _dates = [];
                                  _dates.add(selectedDay);
                  
                                  ActivitiesPageModel objRsp = await ActivitiesService().getActivitiesByRangoFechas(_dates, null);
                  
                                  actividadesFilAgenda = [];
                                  actividadesFilAgenda = objRsp.activities.data;                                  
                  
                                  setState(() {                                                    
                                    rspAct = objRsp;
                                    actualizaListaActAgenda = true;
                                    contLstAgenda = actividadesFilAgenda.length;
                  
                                    selectedDayGen = selectedDay;
                                    focusedDayGen = focusedDay; // update `focusedDayGen` here as well
                                  });
                                }
                              )
                            ),
                            
                            SizedBox(height: size.height * 0.008),
                  
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextField(
                                controller: filtroAgendaTxt,
                                onChanged: (value) {
                                  actualizaListaActAgenda = true;
                                  terminoBusquedaActAgenda = value;                          
                                },
                                onEditingComplete: () async {
        
                                  gnrBloc.setMuestraCarga(true);
                                  
                                  if(isSelected[0]){//MES
                                    if(filtroAgendaTxt.text.isEmpty){
                                      FocusScope.of(context).unfocus();
                                      return;
                                    }
                  
                                    if(_dates.length == 1)
                                    {
                                      FocusScope.of(context).unfocus();
                                      return;
                                    }
                                    ActivitiesPageModel objRsp = await ActivitiesService().getActivitiesByRangoFechas(_dates, objDatumCrmLead?.id ?? 0);
                  
                                    actividadesFilAgenda = [];
                                    actividadesFilAgenda = objRsp.activities.data;
                  
                                    setState(() {
                                      rspAct = objRsp;//.activities;
                                      actualizaListaActAgenda = true;
                                      contLstAgenda = actividadesFilAgenda.length;
                                    });
                  
                                    refreshDataByFiltro(filtroAgendaTxt.text);
                                  }
                  
                                  if(filtroAgendaTxt.text.isNotEmpty){
                                    refreshDataByFiltro(filtroAgendaTxt.text);
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
        
                                        filtroAgendaTxt.text = '';
                                        terminoBusquedaActAgenda = '';
                                        
                                        if(isSelected[0]){//MES
                                          
                                          if(_dates.length == 1)
                                          {
                                            gnrBloc.setMuestraCarga(false);
                                            return;
                                          }
                                          ActivitiesPageModel objRsp = await ActivitiesService().getActivitiesByRangoFechas(_dates, objDatumCrmLead?.id ?? 0);
                  
                                          actividadesFilAgenda = [];
                                          actividadesFilAgenda = objRsp.activities.data;
                  
                                          setState(() {
                                            rspAct = objRsp;//.activities;
                                            actualizaListaActAgenda = true;
                                            contLstAgenda = actividadesFilAgenda.length;
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
                              height: isSelected[1] ? size.height * 0.53 : size.height * 0.33,
                              color: Colors.transparent,
                              child: Image.asset(
                                "assets/gifs/gif_carga.gif",
                                height: size.width * 0.85,
                                width: size.width * 0.85,
                              ),
                            ),
                  
                            if(contLstAgenda > 0 && !state.muestraCarga)
                            Container(
                              color: Colors.transparent,
                              width: size.width,
                              height: isSelected[1] ? size.height * 0.53 : size.height * 0.33,
                              child: ListView.builder(
                                controller: scrollListaClt,
                                itemCount: contLstAgenda,
                                itemBuilder: ( _, int index ) {
                  
                                  return Slidable(
                                    //key: ValueKey(lstActividades[index].id),
                                    startActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (cont) async {
                  
                                              if(actividadesFilAgenda[index].cerrado){
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
                    
                                              await storage.write(key: 'idMem', value: actividadesFilAgenda[index].resId.toString());
                                              await storage.write(key: 'fecMem', value: DateFormat('yyyy-MM-dd', 'es').format(actividadesFilAgenda[index].dateDeadline));
                                              
                                              idActividadSeleccionada = actividadesFilAgenda[index].id;
                  
                                              entraXActividad = true;
                                              objActividadEscogida = actividadesFilAgenda[index];
                  
                                              //ignore: use_build_context_synchronously
                                              context.push(objRutasGen.rutaPlanificacionActividades);
                                              
                                            },
                                            backgroundColor: objColorsApp.fucsia,
                                            foregroundColor: Colors.white,
                                            icon: Icons.account_circle,
                                            label: 'Cierre de Actividades',
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
                                        color: actividadesFilAgenda[index].cerrado ? Colors.grey[300] : Colors.white,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: actividadesFilAgenda[index].cerrado ? Colors.black45 : Colors.grey[300],
                                            child: Stack(
                                                children: [
                                                  const Icon(Icons.person),
                                                  if(!actividadesFilAgenda[index].cerrado && DateFormat('yyyy-MM-dd', 'es').format(actividadesFilAgenda[index].dateDeadline) == DateFormat('yyyy-MM-dd', 'es').format(DateTime.now()))
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
                                          title: Text(actividadesFilAgenda[index].summary ?? ''),
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
                                                      text: actividadesFilAgenda[index].activityTypeId.name,
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
                                                      text: DateFormat('yyyy-MM-dd', 'es').format(actividadesFilAgenda[index].dateDeadline),
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
                  
                            if(contLstAgenda == 0)
                            Container(
                              width: size.width * 0.9,
                              height: isSelected[1] ? size.height * 0.5 : size.height * 0.2,
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
        */
      }
    );
  }

  // Widget para los botones de Mes/Semana
  Widget buildToggleButton(String text, bool isSelected) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          /*
          primary: isSelected ? Colors.blue : Colors.grey[200],
          onPrimary: isSelected ? Colors.white : Colors.black,
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

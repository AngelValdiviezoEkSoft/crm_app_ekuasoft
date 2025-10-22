import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
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
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

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
  const CalendarioActividadesByFiltroView({super.key});

  @override
  State<CalendarioActividadesByFiltroView> createState() =>
      _CalendarioActividadesByFiltroViewState();
}

class _CalendarioActividadesByFiltroViewState extends State<CalendarioActividadesByFiltroView> {
  final ValueNotifier<bool> muestraCargaLocal = ValueNotifier(false);
  final TextEditingController filtroAgendaTxt = TextEditingController();
  final ScrollController scrollListaClt = ScrollController();

  static const platformPhone = MethodChannel('call_channel');

  static const platformEmail = MethodChannel('email_channel');

  late ActivitiesBloc actBloc;
  late GenericBloc gnrBloc;
  late ThemeProvider themeProvider;

  CalendarFormat calendarFormat = CalendarFormat.week;
  ColorsApp objColorsApp = ColorsApp();
  List<DateTime> _datesFiltro = [];
  List<bool> toggleValues = [true, false];

  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      gnrBloc = Provider.of<GenericBloc>(context, listen: false);
      actBloc = Provider.of<ActivitiesBloc>(context, listen: false);

      await _cargarActividadesInicial();
    });
  }

  Future<void> _cargarActividadesInicial() async {
    muestraCargaLocal.value = true;
    gnrBloc.setMuestraCarga(true);

    try {
      ActivitiesPageModel rsp = await ActivitiesService().getActivitiesByRangoFechas('mem', 0);
      actBloc.setLstActividades(rsp.activities.data);
    } finally {
      gnrBloc.setMuestraCarga(false);
      muestraCargaLocal.value = false;
    }
  }

  Future<void> _buscarPorFiltro(String filtro) async {
    muestraCargaLocal.value = true;
    gnrBloc.setMuestraCarga(true);

    final listaOriginal = actBloc.state.lstActivitiesResp.isNotEmpty
        ? actBloc.state.lstActivitiesResp
        : actBloc.state.lstActivities;

    if (filtro.isEmpty) {
      actBloc.setLstActividades(listaOriginal);
    } else {
      final filtradas = listaOriginal.where((a) {
        final texto = filtro.toUpperCase();
        return (a.leadName?.toUpperCase().contains(texto) ?? false) ||
               (a.summary?.toUpperCase().contains(texto) ?? false) ||
               a.activityTypeId.name.toUpperCase().contains(texto);
      }).toList();

      actBloc.setLstActividades(filtradas);
    }

    gnrBloc.setMuestraCarga(false);
    muestraCargaLocal.value = false;
  }

  Future<void> _cargarPorFechas(List<DateTime> fechas) async {
    if (fechas.isEmpty) return;

    muestraCargaLocal.value = true;
    gnrBloc.setMuestraCarga(true);

    try {
      ActivitiesPageModel rsp = await ActivitiesService().getActivitiesByRangoFechas(fechas, objDatumCrmLead?.id ?? 0);
      actBloc.setLstActividades(rsp.activities.data);
    } finally {
      gnrBloc.setMuestraCarga(false);
      muestraCargaLocal.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    gnrBloc = Provider.of<GenericBloc>(context);
    actBloc = Provider.of<ActivitiesBloc>(context);

    final size = MediaQuery.of(context).size;

    return BlocBuilder<ActivitiesBloc, ActivitiesState>(
      builder: (context, stateAct) {
        return ValueListenableBuilder<bool>(
          valueListenable: muestraCargaLocal,
          builder: (context, cargando, _) {
            return Container(
              width: size.width,
              height: size.height,
              color: Colors.transparent,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    _buildToggleButtons(),
                    if (toggleValues[0]) _buildTableCalendar(size),
                    if (toggleValues[1]) _buildRangePicker(size),
                    _buildSearchBar(),
                    const SizedBox(height: 10),

                    if (cargando)
                      Center(
                        child: Image.asset(
                          "assets/gifs/gif_carga.gif",
                          height: size.width * 0.5,
                        ),
                      )
                    else if (stateAct.lstActivities.isEmpty)
                      _buildEmptyState(size)
                    else
                      _buildListaActividades(size, stateAct.lstActivities),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildToggleButtons() {
    return ToggleButtons(
      borderColor: Colors.purple,
      fillColor: Colors.purple,
      selectedBorderColor: Colors.purple,
      selectedColor: Colors.white,
      borderRadius: BorderRadius.circular(20),
      onPressed: (int index) {
        setState(() {
          toggleValues = List.generate(2, (i) => i == index);
        });

        if (index == 0) {
          _cargarPorFechas([DateTime.now()]);
        } else {
          _cargarPorFechas([DateTime.now(), DateTime.now()]);
        }
      },
      isSelected: toggleValues,
      children: const [
        Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("Semana")),
        Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("Mes")),
      ],
    );
  }

  Widget _buildTableCalendar(Size size) {
    return Container(
      color: Colors.transparent,
      width: size.width * 0.95,
      height: size.height * 0.2,
      child: TableCalendar(
        headerStyle: const HeaderStyle(formatButtonVisible: false),
        calendarFormat: calendarFormat,
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime(3000),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(day, selectedDay),
        onDaySelected: (selected, focused) {
          if (!isSameDay(selectedDay, selected)) {
            selectedDay = selected;
            focusedDay = focused;
            _cargarPorFechas([selected]);
          }
        },
      ),
    );
  }

  Widget _buildRangePicker(Size size) {
    return Container(
      color: Colors.transparent,
      width: size.width * 0.95,
      height: size.height * 0.36,
      child: CalendarDatePicker2(
        config: CalendarDatePicker2Config(calendarType: CalendarDatePicker2Type.range),
        value: _datesFiltro,
        onValueChanged: (dates) async {
          _datesFiltro = dates;
          if (dates.length > 1) {
            await _cargarPorFechas(dates);
          }
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: filtroAgendaTxt,
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
          _buscarPorFiltro(filtroAgendaTxt.text);
        },
        decoration: InputDecoration(
          labelText: 'Buscar agendas...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              filtroAgendaTxt.clear();
              _buscarPorFiltro('');
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Widget _buildListaActividades(Size size, List<DatumActivitiesResponse> actividades) {
    return Container(
      color: Colors.transparent,
      width: size.width,
      height: size.height * (toggleValues[0] ? 0.54 : 0.43),
      child: ListView.builder(
        controller: scrollListaClt,
        itemCount: actividades.length,
        itemBuilder: (_, index) {
          final act = actividades[index];
          return Slidable(
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (cont) async {
                    //if (calendarioActividadesFilAgendaByFiltroCall[index].cerrado) {
                    if (actividades[index].cerrado) {
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
                        value: actividades[index].resId.toString());//calendarioActividadesFilAgendaByFiltroCall[index].resId.toString());

                    await storage.write(
                        key: 'fecMem',
                        value: DateFormat('yyyy-MM-dd', 'es').format(actividades[index].dateDeadline));//calendarioActividadesFilAgendaByFiltroCall[index].dateDeadline));

                    idActividadSeleccionadaByFiltroCal = actividades[index].id;//calendarioActividadesFilAgendaByFiltroCall[index].id;

                    objCalendarioActividadescogidaByFiltroCal = actividades[index];//calendarioActividadesFilAgendaByFiltroCall[index];

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
            child: _buildActividadCard(act, size)
          );
        },
      ),
    );
  }

  Widget _buildActividadCard(DatumActivitiesResponse act, Size size) {

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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: act.cerrado ? Colors.grey[300] : Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: act.cerrado ? Colors.black26 : Colors.grey[200],
          child: //const Icon(Icons.person),
          Stack(children: [
            if(act.activityCategory != null 
              && act.activityCategory!.toLowerCase() != 'whatsapp'
              && act.activityCategory!.toLowerCase() != 'phonecall'
              && (act.activityCategory!.toLowerCase() != 'email' || act.leadEmail == null || act.leadEmail!.isEmpty))
            Icon(Icons.person, color: themeProvider.themeMode.index == 2 ? Colors.black : Colors.white,),

             if (!act.cerrado &&act.activityCategory != null && act.activityCategory!.toLowerCase() == 'phonecall')
              GestureDetector(
                onTap: () {
                  makePhoneCall(act.leadPhone!);
                  //makePhoneCall('0988665834');
                },
                child: const Icon(Icons.call, size: 22,)
              ),

              if (!act.cerrado &&act.activityCategory != null && act.activityCategory!.toLowerCase() == 'email' && act.leadEmail != null && act.leadEmail!.isNotEmpty)
              GestureDetector(
                onTap: () {
                  openEmailApp(act.leadEmail!);
                },
                child: const Icon(Icons.email, size: 22, color: Colors.white,)
              ),

              if (!act.cerrado && act.activityCategory != null && act.activityCategory!.toLowerCase() == 'whatsapp')
              GestureDetector(
                onTap: () {
                  abrirWhatsapp( act.leadPhone!, size,  message:'Saludos');
                },
                child: const FaIcon(FontAwesomeIcons.whatsapp, size: 22, color: Colors.green,)
              ),
            

            //if (!calendarioActividadesFilAgendaByFiltroCall[index].cerrado && DateFormat('yyyy-MM-dd','es').format(calendarioActividadesFilAgendaByFiltroCall[index].dateDeadline) == DateFormat('yyyy-MM-dd','es').format(DateTime.now()))
            if (!act.cerrado && DateFormat('yyyy-MM-dd','es').format(act.dateDeadline) == DateFormat('yyyy-MM-dd','es').format(DateTime.now()))
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
        title: Text(act.summary ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Prospecto: ${act.contactName}", style: const TextStyle(fontSize: 12)),            
            Row(children: [
              Text("Tipo de actividad: ${act.activityTypeId.name}", style: const TextStyle(fontSize: 12)),
              SizedBox(width: size.width * 0.04,),
                                                    
             
            ],
            
            ),
            Text("Fecha planificada: ${DateFormat('dd/MM/yyyy').format(act.dateDeadline)}",style: const TextStyle(fontSize: 12)),
            Text("Hora planificada: ${act.scheduledTimeFormula}",style: const TextStyle(fontSize: 12)),
            Text("Creado en: ${DateFormat('dd/MM/yyyy HH:MM:SS').format(act.dateCreate!)}",style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(Size size) {
    return SizedBox(
      height: size.height * 0.25,
      child: const Center(
        child: Text("No existen actividades agendadas para la fecha seleccionada",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}


  Future<void> abrirWhatsapp(String phoneNumber, Size size,{
    String message = ''
  }) async {
      launchWhatsAppBusinessOnly(size, phoneNumber: phoneNumber, message: message);
    /*
    // Asegúrate de que el número no tenga el signo '+' inicial
    final String cleanedNumber = phoneNumber.replaceAll('+', '').replaceAll(' ', '');

    // Usamos el enlace universal (wa.me) que es el más compatible
    final String urlString = 'https://wa.me/$cleanedNumber?text=${Uri.encodeComponent(message)}';
    final Uri url = Uri.parse(urlString);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      launchWhatsAppBusinessOnly(size, phoneNumber: phoneNumber, message: message);
    }
    */
  }

  Future<void> launchWhatsAppBusinessOnly(Size size,{
    required String phoneNumber,
    String message = '',
  }) async {

     final Uri fallbackUrl = Uri.parse('https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');
      if (await canLaunchUrl(fallbackUrl)) {
          await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
      } else {
        showDialog(
          //ignore: use_build_context_synchronously
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

    /*
    final String androidBusinessUrl = 'whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}';
    final Uri url = Uri.parse(androidBusinessUrl);

    if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      final Uri fallbackUrl = Uri.parse('https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');
      if (await canLaunchUrl(fallbackUrl)) {
          await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
      } else {
        showDialog(
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
  }


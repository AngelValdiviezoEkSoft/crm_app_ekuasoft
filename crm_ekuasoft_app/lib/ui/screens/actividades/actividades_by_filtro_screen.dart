import 'package:auto_size_text/auto_size_text.dart';
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

List<MailActivityTypeDatumAppModel> tpActividades = [];
List<String> lstActividadesActByFlt = [];
List<DatumActivitiesResponse> lstActividadesByFiltros = [];
MensajesAlertas objMensajesAlertasAgendaByFiltro = MensajesAlertas();
late TextEditingController filtroAgendaTxtByFiltro;
DatumActivitiesResponse? objActividadEscogidaByFiltro;
int idActividadSeleccionadaByFiltro = 0;
List<DateTime> _datesByFiltro = [];
String terminoBusquedaActAgendaByFiltro = '';
DateTime selectedDayGenByFiltro = DateTime.now();
DateTime focusedDayGenByFiltro = DateTime.now();
//int tabAccionesCal = 0;
List<bool> isSelectedByFiltro = [false,true ]; // 'Mes' está seleccionado inicialmente
bool actualizaListaActAgendaByFiltro = false;
List<DatumActivitiesResponse> lstActividadesByFiltrosByFiltro = [];
int contLstAgendaByFiltro = 0;
bool buscaXCalendario = false;

late TextEditingController nombreProbFiltroTxt;
late TextEditingController cellFiltroTxt;
late TextEditingController probabilidadFiltroTxt;

int contLstAgendaByFiltroCalFiltroCampos = 0;
bool actualizaListaActAgendaByFiltro2FiltroCampos = false;
String campSelectTpAct = '';
int activityTypeId= 0;

class ActividadesByFiltro extends StatefulWidget {
  
  const ActividadesByFiltro(Key? key) : super(key: key);

  @override
  State<ActividadesByFiltro> createState() => ActividadesByFiltroState();

}


class ActividadesByFiltroState extends State<ActividadesByFiltro>  {

  @override
  void initState() {
    super.initState();
    objActividadEscogidaByFiltro = null;
    idActividadSeleccionadaByFiltro = 0;
    terminoBusquedaActAgendaByFiltro = '';
    actualizaListaActAgendaByFiltro = false;
    _datesByFiltro = [];
    lstActividadesByFiltrosByFiltro = [];
    contLstAgendaByFiltro = 0;
    isSelectedByFiltro = [false,true ];
    selectedDayGenByFiltro = DateTime.now();
    focusedDayGenByFiltro = DateTime.now();
    filtroAgendaTxtByFiltro = TextEditingController();
    nombreProbFiltroTxt = TextEditingController();
    cellFiltroTxt = TextEditingController();
    probabilidadFiltroTxt = TextEditingController();
    contLstAgendaByFiltroCalFiltroCampos = 0;
    actualizaListaActAgendaByFiltro2FiltroCampos = false;
    lstActividadesActByFlt = [];
    tpActividades = [];
    campSelectTpAct = '';
    activityTypeId = 0;
    lstActividadesByFiltros = [];
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
      
      ActivitiesPageModel rspPrsp = await ActivitiesService().getActivitiesByRangoFechas(_datesByFiltro.isNotEmpty ? _datesByFiltro : 'mem', objDatumCrmLead?.id ?? 0);
  
      contLstAgendaByFiltro = rspPrsp.activities.data.length;
      lstActividadesByFiltrosByFiltro = rspPrsp.activities.data;


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
            mensajeAlerta: objMensajesAlertasAgendaByFiltro.mensajeOffLine
          );
        },
      );
    }

  }

  ScrollController scrollListaClt = ScrollController();

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final gnrBloc = Provider.of<GenericBloc>(context);
    gnrBloc.setMuestraCarga(false);

    return BlocBuilder<GenericBloc, GenericState>(
      builder: (context, state) {

        return FutureBuilder(
          future: ActivitiesService().getTipoActividades(),
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
            else{
              MailActivityTypeAppModel rspAct = snapshot.data as MailActivityTypeAppModel;

              tpActividades = rspAct.data;

              if(lstActividadesActByFlt.isEmpty){
                lstActividadesActByFlt.add('-- Seleccione --');
                for(int i = 0; i < tpActividades.length; i++){
                  lstActividadesActByFlt.add(tpActividades[i].name ?? '');
                }
              }

              if(campSelectTpAct.isEmpty && lstActividadesActByFlt.isNotEmpty){
                campSelectTpAct = lstActividadesActByFlt.first;
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
                    if(!buscaXCalendario)
                    IconButton(
                      icon: const Icon(Icons.calendar_month),
                      onPressed: () async {
                        //await refreshDataAgenda();
                        
                        setState(() {
                          buscaXCalendario = true;
                        });
                      },
                    ),
    
                    if(buscaXCalendario)
                    IconButton(
                      icon: const Icon(Icons.list),
                      onPressed: () async {
                        setState(() {
                          buscaXCalendario = false;
                        });
                      },
                    ),
                  ],
                  backgroundColor: Colors.white,
                  elevation: 0,
                  foregroundColor: Colors.black,
                ),
                body: !buscaXCalendario ?
                Container(
                  width: size.width * 0.99,
                  height: size.height,
                  color: Colors.transparent,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        
                        SizedBox(height:  size.height * 0.02,),
    
                        Container(
                          color: Colors.transparent,
                          width: size.width * 0.95,
                          height: size.height * 0.09,
                          child: TextFormField(
                            controller: nombreProbFiltroTxt,
                            decoration: const InputDecoration(
                              labelText: 'Nombre de oportunidad',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.person),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        Container(
                          color: Colors.transparent,
                          width: size.width * 0.95,
                          height: size.height * 0.09,
                          child: TextFormField(
                            controller: cellFiltroTxt,
                            decoration: const InputDecoration(
                              labelText: 'Número celular',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.phone_iphone_outlined),
                            ),
                            keyboardType: TextInputType.phone,
                            /*
                            onChanged: (value) {
                              setState(() {
                                campSelectTpAct = '';
                              });
                            },
                            */
                          ),
                        ),
                        const SizedBox(height: 16),
    
                        Container(
                          color: Colors.transparent,
                          width: size.width * 0.95,
                          height: size.height * 0.09,
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Seleccione el tipo de actividad...',
                            ),
                            value: campSelectTpAct,
                            items: lstActividadesActByFlt.map((activityPrsp) =>
                              DropdownMenuItem(
                                  value: activityPrsp,
                                  child: Text(activityPrsp, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 12),),                                              
                                )
                              )
                            .toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                campSelectTpAct = newValue ?? '';
                              });
                            },
                          ),
                        ),
                        
    
                        SizedBox(height: size.height * 0.035),
    
                        Container(
                          color: Colors.transparent,
                          width: size.width * 0.9,
                          height: size.height * 0.06,
                          child: ElevatedButton(
                            onPressed: () async {

                              if(campSelectTpAct != '-- Seleccione --' && cellFiltroTxt.text.isEmpty && nombreProbFiltroTxt.text.isEmpty){
                                for(int i = 0; i < tpActividades.length; i++){
                                  if(campSelectTpAct == tpActividades[i].name){
                                    activityTypeId = tpActividades[i].id ?? 0;
                                  }
                                }
                              }
                              else {
                                if(cellFiltroTxt.text.isNotEmpty || nombreProbFiltroTxt.text.isNotEmpty){
                                  activityTypeId = 0;
                                }
                                if(campSelectTpAct != '-- Seleccione --' || (cellFiltroTxt.text.isNotEmpty && nombreProbFiltroTxt.text.isNotEmpty)){
                                  for(int i = 0; i < tpActividades.length; i++){
                                    if(campSelectTpAct == tpActividades[i].name){
                                      activityTypeId = tpActividades[i].id ?? 0;
                                    }
                                  }
                                }
                              }
                              
                              ActivitiesPageModel objRsp = await ActivitiesService().getActivitiesByFiltros(nombreProbFiltroTxt.text, cellFiltroTxt.text, activityTypeId, objDatumCrmLead?.id ?? 0);
              
                              lstActividadesByFiltros = [];

                              if(objRsp.activities.data.isNotEmpty){
                                lstActividadesByFiltros = objRsp.activities.data;
                              }
    /*
                              nombreProbFiltroTxt = TextEditingController();
                              cellFiltroTxt = TextEditingController();
                              probabilidadFiltroTxt = TextEditingController();
                              */

                              //ignore: use_build_context_synchronously
                              FocusScope.of(context).unfocus();

    
                              setState(() {
                                //rspAct = objRsp;//.activities;
                                actualizaListaActAgendaByFiltro2FiltroCampos = true;
                                contLstAgendaByFiltroCalFiltroCampos = lstActividadesByFiltros.length;
                              }); 
                            },
                            style: ElevatedButton.styleFrom(                                  
                              backgroundColor: const Color.fromRGBO(75, 57, 239, 1.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('Buscar', style: TextStyle(color: Colors.white),),
                          ),
                        ),
    
                        SizedBox(height: size.height * 0.015),
    
                        Container(
                          width: size.width * 0.9,
                          height: size.height * 0.42,
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
                    
                              //if(contLstAgenda > 0 && !state.muestraCarga)
                              if(lstActividadesByFiltros.isNotEmpty && !state.muestraCarga)
                              Container(
                                color: Colors.transparent,
                                width: size.width,
                                height: size.height * 0.42,//isSelected[1] ? size.height * 0.53 : size.height * 0.33,
                                child: ListView.builder(
                                  controller: scrollListaClt,
                                  itemCount: lstActividadesByFiltros.length,
                                  itemBuilder: ( _, int index ) {
                    
                                    return Slidable(
                                      key: ValueKey(lstActividadesByFiltros[index].id),
                                      startActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed: (cont) async {
                    
                                                if(lstActividadesByFiltros[index].cerrado){
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
                      
                                                await storage.write(key: 'idMem', value: lstActividadesByFiltros[index].resId.toString());
                                                await storage.write(key: 'fecMem', value: DateFormat('yyyy-MM-dd', 'es').format(lstActividadesByFiltros[index].dateDeadline));
                                                
                                                entraXActividad = true;
                                                idActividadSeleccionada = lstActividadesByFiltros[index].id;
                    
                                                objActividadEscogida = lstActividadesByFiltros[index];
                    
                                                //ignore: use_build_context_synchronously
                                                context.push(objRutasGen.rutaPlanificacionActividades);
                                                
                                              },
                                              backgroundColor: ColorsApp().fucsia,
                                              foregroundColor: Colors.white,
                                              icon: Icons.account_circle,
                                              label: 'Cierre de Actividades',
                                            )
                                          ]
                                      ),
                                      child:  Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                        child: Card(
                                          elevation: 1,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          color: lstActividadesByFiltros[index].cerrado ? Colors.grey[300] : Colors.white,
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: lstActividadesByFiltros[index].cerrado ? Colors.black45 : Colors.grey[300],
                                              child: Stack(
                                                  children: [
                                                    const Icon(Icons.person),
                                                    if(!lstActividadesByFiltros[index].cerrado && DateFormat('yyyy-MM-dd', 'es').format(lstActividadesByFiltros[index].dateDeadline) == DateFormat('yyyy-MM-dd', 'es').format(DateTime.now()))
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
                                            title: Text(lstActividadesByFiltros[index].summary ?? ''),
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
                                                        text: lstActividadesByFiltros[index].activityTypeId.name,
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
                                                        text: DateFormat('yyyy-MM-dd', 'es').format(lstActividadesByFiltros[index].dateDeadline),
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
                              
                              if(lstActividadesByFiltros.isEmpty)
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
                )
                :
                const CalendarioActividadesByFiltroView(null),
              );
            
            }

            //return Container();
          }
        );
      }
    );
  }

  // Widget para los botones de Mes/Semana
  Widget buildToggleButton(String text, bool isSelectedByFiltro) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          /*
          primary: isSelectedByFiltro ? Colors.blue : Colors.grey[200],
          onPrimary: isSelectedByFiltro ? Colors.white : Colors.black,
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

import 'package:auto_size_text/auto_size_text.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
List<DatumActivitiesResponse> actividadesFilAgendaByFiltro = [];
int contLstAgendaByFiltro = 0;
bool buscaXCalendario = false;

late TextEditingController nombreProbFiltroTxt;
late TextEditingController emailFiltroTxt;
late TextEditingController probabilidadFiltroTxt;

int contLstAgendaByFiltroCalFiltroCampos = 0;
bool actualizaListaActAgendaByFiltro2FiltroCampos = false;

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
    actividadesFilAgendaByFiltro = [];
    contLstAgendaByFiltro = 0;
    isSelectedByFiltro = [false,true ];
    selectedDayGenByFiltro = DateTime.now();
    focusedDayGenByFiltro = DateTime.now();
    filtroAgendaTxtByFiltro = TextEditingController();
    nombreProbFiltroTxt = TextEditingController();
    emailFiltroTxt = TextEditingController();
    probabilidadFiltroTxt = TextEditingController();
    contLstAgendaByFiltroCalFiltroCampos = 0;
    actualizaListaActAgendaByFiltro2FiltroCampos = false;
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
      actividadesFilAgendaByFiltro = rspPrsp.activities.data;


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

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final gnrBloc = Provider.of<GenericBloc>(context);
    gnrBloc.setMuestraCarga(false);

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
                            //await refreshDataAgenda();
                            
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
                                  labelText: 'Nombre de probabilidad',
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
                                controller: emailFiltroTxt,
                                decoration: const InputDecoration(
                                  labelText: 'Correo',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.email),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            Container(
                              color: Colors.transparent,
                              width: size.width * 0.95,
                              height: size.height * 0.09,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: probabilidadFiltroTxt,
                                decoration: const InputDecoration(
                                  labelText: 'Probabilidad',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.percent),
                                ),
                              ),
                            ),

                            SizedBox(height: size.height * 0.035),

                            Container(
                              color: Colors.transparent,
                              width: size.width * 0.9,
                              height: size.height * 0.06,
                              child: ElevatedButton(
                                onPressed: () async {

                                  ActivitiesPageModel objRsp = await ActivitiesService().getActivitiesByFiltros(nombreProbFiltroTxt.text, emailFiltroTxt.text, probabilidadFiltroTxt.text, objDatumCrmLead?.id ?? 0);
                  
                                  calendarioActividadesFilAgendaByFiltroCall = [];
                                  calendarioActividadesFilAgendaByFiltroCall = objRsp.activities.data;

                                  nombreProbFiltroTxt = TextEditingController();
                                  emailFiltroTxt = TextEditingController();
                                  probabilidadFiltroTxt = TextEditingController();

                                  setState(() {
                                    //rspAct = objRsp;//.activities;
                                    actualizaListaActAgendaByFiltro2FiltroCampos = true;
                                    contLstAgendaByFiltroCalFiltroCampos = calendarioActividadesFilAgendaByFiltroCall.length;
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

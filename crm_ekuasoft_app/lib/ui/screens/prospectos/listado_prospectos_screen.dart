import 'dart:ui' as ui;

import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:crm_ekuasoft_app/main.dart';
import 'package:excel/excel.dart' as exc;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

bool accionNav = false;
String objRspGen = '';
List<int> years = [];
List<DatumCrmLead> prospectosFiltrados = [];
List<CrmStage> lstEstadoProspectos = [];
String terminoBusqueda = '';
DatumCrmLead? objDatumCrmLead;
late TextEditingController filtroPrspTxt;
bool listaVaciaPrp = false;
bool actualizaListaPrp= false;
bool ingresaUnaVez = true;
CrmStage? selectCrmStage;

class ListaProspectosScreen extends StatefulWidget {
  const ListaProspectosScreen({super.key});

  @override
  State<ListaProspectosScreen> createState() => ListaProspectosScreenState();
}

//class MarcacionScreen extends StatelessWidget {
class ListaProspectosScreenState extends State<ListaProspectosScreen> {

  List<String> lstEstadosPrsp = [];
  String estadoPrspSelect = '-- Todos --';
  late Future<String> _futureProspectos;
  int selectedYear = DateTime.now().year;
  int? _mesSeleccionado; // mes del 1 al 12  
  bool muestraContador = false;

  bool showButtonScrool = false;
  final ScrollController scrollListaClt = ScrollController();

  int contLst = 0;
  final LocalAuthentication auth = LocalAuthentication();
  final PagingController<int, DatumCrmLead> pagingController = PagingController(firstPageKey: 0);

  void scrollToTop() {
    scrollListaClt.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  List<MenuGridWidgetModel> lstMenuGrid = [];


  @override
  void initState() {
    super.initState(); 
    accionNav = false;   
    estadoPrspSelect = '-- Todos --';
    lstEstadosPrsp = [];
    lstEstadoProspectos = [];
    lstMenuGrid = [
      
      /*
      MenuGridWidgetModel(
        icon: Icons.download, 
        title: 'Reporte',
        onTap: () {
          contextPrincipalGen!.pop();
          generarReporte(contextPrincipalGen!);
        },
      ),
      */
      
      MenuGridWidgetModel(
        icon: Icons.calendar_month, 
        title: 'Calendario de actividades',
        onTap: () {
          contextPrincipalGen!.pop();
          contextPrincipalGen!.push(objRutasGen.rutaConsultaActividades);
        },
      ),
    ];

    objRspGen = '';
    ingresaUnaVez = true;
    objActividadEscogida = null;
    objCalendarioActividadescogidaByFiltroCal = null;
    actualizaListaPrp = false;
    contLst = 0;
    terminoBusqueda = '';
    filtroPrspTxt = TextEditingController();
    prospectosFiltrados = [];    
    pagingController.addPageRequestListener((pageKey) {
      //fetchPage(pageKey);
    });

    scrollListaClt.addListener(() {
      if (scrollListaClt.offset > 200 && !showButtonScrool) {
        setState(() {
          showButtonScrool = true;
        });
      } else if (scrollListaClt.offset <= 200 && showButtonScrool) {
        setState(() {
          showButtonScrool = false;
        });
      }
    });

    int currentYear = DateTime.now().year;
    
    years = [];
    years = List.generate(currentYear - 2000 + 1, (index) => 2000 + index);
    
    _futureProspectos = getProspectos();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      cargaComboEstadosProspectos();
    });
  }

  @override
  void dispose() {
    pagingController.dispose();
    accionNav = false;
    super.dispose();
  }

  Future<void> refreshDataProsp() async {

    String resInt = await ValidacionesUtils().validaInternet();

    if(!accionNav)
    {
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
              mensajeMostrarDialogCargando: 'el listado de prospectos.',
            ),
          ]
        ),
      );
    }

    if(resInt.isEmpty){
      var rspPrsp = await ProspectoTypeService().getProspectos();

      var objLogDecode = json.decode(rspPrsp);
      var objLogDecode2 = json.decode(objLogDecode);

      var tstLength = objLogDecode2["result"]["data"]["crm.lead"]["length"];

      String contStr = '$tstLength';

      contLst = 0;

      contLst = int.parse(contStr);

      CrmLeadAppModel apiResponse = CrmLeadAppModel.fromJson(objLogDecode2["result"]["data"]["crm.lead"]);

      //List<CrmLeadDatumAppModel> prospectosFiltrados = [];
      prospectosFiltrados = [];

      if(terminoBusqueda.isNotEmpty){
        
        if(!terminoBusqueda.contains('+') && !terminoBusqueda.contains('0')){

          for(int i = 0; i < apiResponse.data.length; i++){
            if(apiResponse.data[i].name != null && apiResponse.data[i].name!.toLowerCase().contains(terminoBusqueda.toLowerCase())){
              //prospectosFiltrados.add(apiResponse.data[i]);
            }
          }

          if(prospectosFiltrados.isEmpty){

            for(int i = 0; i < apiResponse.data.length; i++){
              if(apiResponse.data[i].contactName != null && apiResponse.data[i].contactName!.toLowerCase().contains(terminoBusqueda.toLowerCase())){
                //prospectosFiltrados.add(apiResponse.data[i]);
              }
            }

          }

          if(prospectosFiltrados.isEmpty){

            for(int i = 0; i < apiResponse.data.length; i++){
              if(apiResponse.data[i].emailFrom != null && apiResponse.data[i].emailFrom!.toLowerCase().contains(terminoBusqueda.toLowerCase())){
                //prospectosFiltrados.add(apiResponse.data[i]);
              }
            }
          }
        } else {
          if(prospectosFiltrados.isEmpty && (terminoBusqueda.contains('+') || terminoBusqueda.contains('0'))){
            for(int i = 0; i < apiResponse.data.length; i++){
              if(apiResponse.data[i].phone != null && apiResponse.data[i].phone!.contains(terminoBusqueda)){
                //prospectosFiltrados.add(apiResponse.data[i]);
              }
            }
          }
        }

        contLst = prospectosFiltrados.length;
      } else{
        for(int i = 0; i < apiResponse.data.length; i++){
          List<StructCombos> lstComboActivityId = [];
          
          CampaignId objCampaign = CampaignId(
            id: apiResponse.data[i].campaignId.id ?? 0,
            name: apiResponse.data[i].campaignId.name ?? ''
          );

          StructCombos objCountryId = StructCombos(
            id: apiResponse.data[i].countryId.id ?? 0,
            name: apiResponse.data[i].countryId.name ?? ''
          );

          CampaignId objLostReason = CampaignId (
            id: apiResponse.data[i].lostReasonId.id ?? 0,
            name: apiResponse.data[i].lostReasonId.name ?? ''
          );

          StructCombos objMedios = StructCombos(
            id: apiResponse.data[i].mediumId.id ?? 0,
            name: apiResponse.data[i].mediumId.name ?? ''
          );

          StructCombos objSource = StructCombos(
            id: apiResponse.data[i].sourceId.id ?? 0,
            name: apiResponse.data[i].sourceId.name ?? ''
          );

          StageId objStage = StageId(
            id: apiResponse.data[i].stageId.id,
            name: apiResponse.data[i].stageId.name,
            isWon: apiResponse.data[i].stageId.isWon
          );

          StructCombos objState = StructCombos(
            id: apiResponse.data[i].stateId.id ?? 0,
            name: apiResponse.data[i].stateId.name ?? ''
          );

          StructCombos objUserId = StructCombos(
            id: apiResponse.data[i].userId.id ?? 0,
            name: apiResponse.data[i].userId.name ?? ''
          );

          CampaignId objTitle = CampaignId(
            id: apiResponse.data[i].title.id ?? 0,
            name: apiResponse.data[i].title.name ?? '',
          );

          PartnerId objPartnerId = PartnerId(
            cantonId: StructCombos (id: 0, name: ''),
            channelId: StructCombos (id: 0, name: ''),
            cityId: StructCombos (id: 0, name: ''),
            clasificationId: StructCombos (id: 0, name: ''),
            email: '',
            id: apiResponse.data[i].partnerId.id ?? 0,
            name: apiResponse.data[i].partnerId.name ?? '',
            regionId: StructCombos (id: 0, name: ''),
            sectorId: StructCombos (id: 0, name: ''),
            tradeName: ''
          );

          for(int j = 0; j < apiResponse.data[i].activityIds.length; j++){

            StructCombos objStruc = StructCombos(
              id: apiResponse.data[i].activityIds[j].id ?? 0,
              name: apiResponse.data[i].activityIds[j].name ?? ''
            );

            lstComboActivityId.add(
              objStruc
            );
          }

          prospectosFiltrados.add(
            DatumCrmLead(
              dateCreate: DateTime.now(),
              activityIds: lstComboActivityId,
              campaignId: objCampaign,
              countryId: objCountryId,
              dayClose: apiResponse.data[i].dayClose ?? 0,
              emailFrom: apiResponse.data[i].emailFrom ?? '',
              expectedRevenue: apiResponse.data[i].expectedRevenue ?? 0,
              id: apiResponse.data[i].id ?? 0,
              lostReasonId: objLostReason,
              mediumId: objMedios,
              mobile: apiResponse.data[i].phone ?? '',
              name: apiResponse.data[i].name ?? '',
              partnerId: objPartnerId,
              priority: apiResponse.data[i].priority ?? '',
              sourceId: objSource,
              stageId: objStage,
              stateId: objState,
              tagIds: [],
              title: objTitle,
              type: apiResponse.data[i].type ?? '',
              active: apiResponse.data[i].active,
              contactName: apiResponse.data[i].contactName ?? '',
              description: apiResponse.data[i].description ?? '',
              phone: apiResponse.data[i].phone ?? '',
              probability: apiResponse.data[i].probability ?? 0,
              referred: apiResponse.data[i].referred ?? '',
              street: apiResponse.data[i].street ?? '',
              dateOpen: apiResponse.data[i].dateOpen,
              dateClose: apiResponse.data[i].dateClose,
              dateDeadline: apiResponse.data[i].dateDeadline,
              userId: objUserId
            )
          );

        }
      }

      objRspGen = '';
      objRspGen = jsonEncode(prospectosFiltrados);

      try{
        if(!accionNav){
          //ignore:use_build_context_synchronously
          context.pop();
        }

        setState(() {});
      }
      catch(_){}

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
            mensajeAlerta: 'No tiene acceso a internet.'
          );
        },
      );
    }

  }

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);

    //VALIDAR QUE SEA SOLO PARA CVE
    final meses = List.generate(12, (index) => DateFormat.MMMM().format(DateTime(0, index + 1)));
    meses.add("-- Todos --");

    ColorsApp objColorsApp = ColorsApp();

    final size = MediaQuery.of(context).size;

    return 
    objPermisosGen != null && objPermisosGen!.buttons.btnCreateLead ?
    Scaffold(
      appBar: AppBar(
          //backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 19,),
            onPressed: () {
              //ignore: use_build_context_synchronously
              FocusScope.of(context).unfocus();

              terminoBusqueda = '';
              filtroPrspTxt = TextEditingController();
              context.pop();

            },
          ),
          title: const Text('Prospectos', style: TextStyle(fontSize: 19),),
          actions: [
            
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                terminoBusqueda = '';
                filtroPrspTxt.text = '';
                //refreshDataByFiltro(objRspGen);
                _mesSeleccionado = null;//DateTime.now().month;
                selectedYear = DateTime.now().year;
                                
                refreshDataProsp();
              },
            ),
            
            /*
            IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: () {
                //context.push(objRutasGen.rutaAgenda);
                context.push(objRutasGen.rutaConsultaActividades);
              },
            ),
            */

            IconButton(
              icon: const Icon(Icons.grid_on_outlined),
              onPressed: () {
                //
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // Usamos un `AlertDialog` para la estructura del modal
                    return AlertDialog(
                      title: const Text('Opciones'),
                      content: Container(
                        color: Colors.transparent,
                        // El `Container` limita el tamaño del modal/GridView
                        width: double.maxFinite, 
                        height: size.height * 0.47, // 40% de la altura de la pantalla
                        child: GridView.builder(
                          itemCount: lstMenuGrid.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 columnas
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            final item = lstMenuGrid[index];
                            return _MenuCard(item: item);
                          },
                        ),
                      ),
                      // 5. Botón opcional de cerrar en el diálogo
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cerrar'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

/*
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                generarReporte(context);
              },
            ),
            */
          ],
        ),
      body: BlocBuilder<GenericBloc, GenericState>(
        builder: (context,state) {

          return FutureBuilder(
            future: _futureProspectos,//state.lstProspectos(),
            builder: (context, snapshot) {

              if (snapshot.hasError) {
                return const Center(
                  child: AutoSizeText(
                    '!UPS¡, intenta acceder después de unos minutos.',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }

              if (snapshot.hasData) {
                String objRsp = snapshot.data as String;
                
                objRspGen = objRsp;

                if(objRsp.isNotEmpty){
                  
                  var objLogDecode = json.decode(objRsp);

                  var tstLength = objLogDecode["length"];

                  String contStr = '$tstLength';

                  contLst = 0;

                  contLst = int.parse(contStr);

                  if(ingresaUnaVez){
                    refreshDataByFiltro(objRsp);
                  }
                  
                  listaVaciaPrp = false;
                  
                } else {
                  listaVaciaPrp = true;
                }

                ingresaUnaVez = false;
              

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.002,
                      ),
                  
                      Container(
                        color: themeProvider.themeMode.index == 2 ? Colors.black : Colors.white,
                        width: size.width * 0.98,
                        child: TextField(
                          inputFormatters: [
                            EmojiInputFormatter()
                          ],
                          controller: filtroPrspTxt,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: themeProvider.themeMode.index == 2 ? Colors.white : Colors.black,),
                            hintText: 'Buscar prospectos por nombre, correo o celular',
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            suffixIcon: IconButton(
                              onPressed: () {
                                terminoBusqueda = '';
                                filtroPrspTxt.text = '';
                                refreshDataByFiltro(objRsp);
                                _mesSeleccionado = null;//DateTime.now().month;
                                selectedYear = DateTime.now().year;
                                muestraContador = false;
                                
                                setState(() {
                                  
                                });
                              },
                              icon: Icon(
                                Icons.cancel,
                                size: 20,
                                color: themeProvider.themeMode.index == 2 ? Colors.white : AppLightColors().gray900PrimaryText,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            actualizaListaPrp = false;
                            terminoBusqueda = value;
                            //refreshDataByFiltro(value, objRsp);
                          },
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                            actualizaListaPrp = true;
                            setState(() { });
                            WidgetsBinding.instance.addPostFrameCallback((_) async {
                              refreshDataByFiltro(objRsp);
                            });
                          },
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                            actualizaListaPrp = true;
                            setState(() { });
                          },
                        ),
                      ),

                      SizedBox(
                        height: size.height * 0.009,
                      ),

/*
                      Container(
                        width: size.width * 0.96,
                        height: size.height * 0.03,
                        color: Colors.transparent,
                        child: const Text('Filtros: '),
                      ),
                      */

                      Container(
                        color: Colors.transparent,
                        width: size.width * 0.96,
                        height: size.height * 0.07,
                        child: Row(
                          children: [
                            Container(
                              color: Colors.white,
                              width: size.width * 0.34,
                              //height: size.height * 0.06,
                              child: DropdownButtonFormField<CrmStage>(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                value: selectCrmStage,
                                hint: const Text('Seleccione'),
                                onChanged: (CrmStage? newValue) {
                                  selectCrmStage = newValue;
                                  refreshDataByEstado(objRspGen, selectCrmStage?.name ?? '');
                                  setState(() {});
                                },
                                items: lstEstadoProspectos.map((CrmStage item) {
                                  return DropdownMenuItem<CrmStage>(
                                    value: item, 
                                    child: Text(
                                      item.name ?? '',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            
                            SizedBox(width: size.width * 0.05,),

                            Container(
                              color: Colors.white,
                              width: size.width * 0.25,
                              child: DropdownButtonFormField<int>(
                                alignment: Alignment.center,
                                hint: const Text('Mes', style: TextStyle(color: Colors.black),),//, style: TextStyle(color: themeProvider.themeMode.index == 0 || themeProvider.themeMode.index == 2 ? Colors.white : Colors.black,),),
                                value: _mesSeleccionado,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  //filled: true,
                                  border: OutlineInputBorder(),
                                  //fillColor: themeProvider.themeMode.index == 0 ? Colors.white : Colors.black
                                ),
                                items: List.generate(13, (index) {
                                  return DropdownMenuItem(
                                    value: index + 1,                                                            
                                    //enabled: true,
                                    child: Text(meses[index]),
                                  );
                                }),
                                onChanged: (value) {
                                  estadoPrspSelect = '-- Todos --';
                                  muestraContador = true;

                                  _mesSeleccionado = value;
                                  
                                  refreshDataByMes(_mesSeleccionado ?? 0, objRspGen, _mesSeleccionado == 13);
                                },
                              ),
                            ),

                            SizedBox(width: size.width * 0.05,),

                            Container(
                              color: Colors.white,
                              width: size.width * 0.27,
                              child: DropdownButtonFormField<int>(
                                //style: TextStyle(color: !_isDropdownOpen && (themeProvider.themeMode.index == 0 || themeProvider.themeMode.index == 2) ? Colors.white : Colors.black,),
                                value: selectedYear,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                items: years.map((year) {
                                  return DropdownMenuItem(
                                    value: year,
                                    child: Text(year.toString()),
                                  );
                                }).toList(),                                                    
                                onChanged: (value) {
                                  estadoPrspSelect = '-- Todos --';
                                  selectedYear = value!;
                                  muestraContador = true;
                                  refreshDataByMes(_mesSeleccionado ?? 0, objRspGen, _mesSeleccionado == 13);                            
                                },
                              ),
                            ),

                          ],
                        ),
                      ),
                      
                      SizedBox(height: size.height * 0.02,),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: const Color.fromARGB(255, 217, 217, 217)),
                          borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),                        
                        width: size.width * 0.96,
                        height: size.height * 0.04,
                        alignment: Alignment.center,
                        child: SelectableText.rich(
                            TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Prospectos registrados: ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: themeProvider.themeMode.index == 0 || themeProvider.themeMode.index == 1 ? Colors.black : Colors.white)
                                  ),
                                  TextSpan(
                                    text: '${prospectosFiltrados.length}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue)
                                  ),
                                ]
                              ),
                          )
                      
                      ),

                      //if(muestraContador && prospectosFiltrados.isNotEmpty)
                      SizedBox(height: size.height * 0.007,),

                      if(prospectosFiltrados.isNotEmpty) 
                      Container(
                        color: Colors.transparent,
                        width: size.width,
                        height: size.height * 0.6,
                        child: Scaffold(
                          body: LiquidPullToRefresh(
                            onRefresh: refreshDataProsp,
                            color: Colors.blue[300],
                            child: ListView.builder(
                              controller: scrollListaClt,
                              itemCount: prospectosFiltrados.length,//contLst,
                              itemBuilder: ( _, int index ) {
                            
                                return Slidable(
                                  key: ValueKey(prospectosFiltrados[index].id),
                                  startActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) async 
                                          {
                                            objDatumCrmLead = prospectosFiltrados[index];
                          
                                            //ignore: use_build_context_synchronously
                                            FocusScope.of(context).unfocus();
                          
                                            terminoBusqueda = '';
                                            entraXActividad = false;
                                            filtroPrspTxt = TextEditingController();

                                            terminoBusqueda = '';
                                            filtroPrspTxt.text = '';
                                            refreshDataByFiltro(objRsp);
                                            _mesSeleccionado = null;//DateTime.now().month;
                                            selectedYear = DateTime.now().year;
                                            lstTipoActividades = [];
                                            lstMotivoPerdida = [];

                                            accionNav = true;
                          
                                            //context.push(Rutas().rutaPlanificacionActividades);
                                            rutaActualGen = Rutas().rutaPlanActivConActiv;
                                            await context.push(Rutas().rutaPlanActivConActiv);
                                            await refreshDataProsp();
                                          },
                                          backgroundColor: objColorsApp.celeste,
                                          foregroundColor: Colors.white,
                                          icon: Icons.call_outlined,
                                          label: 'Actividades',
                                        ),
                                      ]
                                    ),
                                    child: ListTile(
                                      title: Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.98,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: prospectosFiltrados[index].active != null && prospectosFiltrados[index].active == true ? Colors.transparent : Colors.grey[300],
                                            border: Border.all(color: const Color.fromARGB(255, 217, 217, 217)),
                                            borderRadius: const BorderRadius.all(Radius.circular(10))
                                          ),
                                          width: size.width * 0.98,
                                          height: size.height * 0.23,
                                          child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.7,
                                              height: size.height * 0.25,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(width: size.width * 0.01,),
                                                  Container(
                                                    color: Colors.transparent,
                                                    width: size.width * 0.14,
                                                    height: size.height * 0.1,
                                                    child: CircleAvatar(
                                                      radius: 30.0,
                                                      backgroundColor: Colors.grey[200],
                                                      child: const Icon(Icons.person, color: Colors.grey, size: 40.0),
                                                    ),
                                                  ),
                                                  SizedBox(width: size.width * 0.02,),
                                                  Container(
                                                    color: Colors.transparent,
                                                    width: size.width * 0.52,
                                                    height: size.height * 0.25,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        color: Colors.transparent,
                                                        width: size.width * 0.54,
                                                        height: size.height * 0.04,
                                                        child: LayoutBuilder(
                                                          builder: (context, constraints) {
                                                            final text = prospectosFiltrados[index].name;
                                                            const textStyle = TextStyle(fontWeight: FontWeight.bold);

                                                            final textPainter = TextPainter(
                                                              text: TextSpan(text: text, style: textStyle),
                                                              maxLines: 1,
                                                              textDirection: ui.TextDirection.ltr,//TextDirection.LTR,
                                                            )..layout(maxWidth: constraints.maxWidth);

                                                            String displayText = text;
                                                            if (textPainter.didExceedMaxLines) {
                                                              displayText = text.substring(0, textPainter.getPositionForOffset(Offset(constraints.maxWidth - 20, 0)).offset) + '...';
                                                            }

                                                            return SelectableText(
                                                              displayText,
                                                              style: textStyle,
                                                            );
                                                          },
                                                        ),
                                                      ),

                                                      Container(
                                                        color: Colors.transparent,
                                                        width: size.width * 0.54,
                                                        height: size.height * 0.04,
                                                        child: LayoutBuilder(
                                                          builder: (context, constraints) {
                                                            final text = prospectosFiltrados[index].contactName ?? '';
                                                            const textStyle = TextStyle(fontWeight: FontWeight.bold);

                                                            final textPainter = TextPainter(
                                                              text: TextSpan(text: text, style: textStyle),
                                                              maxLines: 1,
                                                              textDirection: ui.TextDirection.ltr,//TextDirection.LTR,
                                                            )..layout(maxWidth: constraints.maxWidth);

                                                            String displayText = text;
                                                            if (textPainter.didExceedMaxLines) {
                                                              displayText = text.substring(0, textPainter.getPositionForOffset(Offset(constraints.maxWidth - 20, 0)).offset) + '...';
                                                            }

                                                            return SelectableText(
                                                              displayText,
                                                              style: textStyle,
                                                            );
                                                          },
                                                        ),
                                                      ),

/*
                                                      Container(
                                                        color: Colors.transparent,
                                                        width: size.width * 0.54,
                                                        height: size.height * 0.04,
                                                        child: SelectableText.rich(
                                                          TextSpan(
                                                          children: [                                                            
                                                            TextSpan(
                                                              text: prospectosFiltrados[index].name,
                                                              style: const TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                overflow: TextOverflow.ellipsis,                                                                
                                                              ),                                                              
                                                            ),
                                                          ],
                                                        ),
                                                        )
                                                      ),

                                                      Container(
                                                        color: Colors.transparent,
                                                        width: size.width * 0.54,
                                                        height: size.height * 0.04,
                                                        child: SelectableText.rich(
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: prospectosFiltrados[index].contactName ?? '',
                                                                style: const TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      */
                                                      
                                                    Container(
                                                      color: Colors.transparent,
                                                      width: size.width * 0.54,
                                                      height: size.height * 0.035,
                                                        child: 
                                                        SelectableText.rich(
                                                          TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text: 'Email: ',
                                                                  style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: themeProvider.themeMode.index == 0 || themeProvider.themeMode.index == 1 ? Colors.black : Colors.white
                                                                  )
                                                                ),
                                                                TextSpan(
                                                                  text: prospectosFiltrados[index].emailFrom,
                                                                  style: const TextStyle(
                                                                    fontSize: 14,
                                                                    color: Colors.blue)
                                                                ),
                                                              ]
                                                            ),
                                                          
                                                        )
                                                    ),
                                                

                                                  Container(
                                                    color: Colors.transparent,
                                                    width: size.width * 0.54,
                                                    height: size.height * 0.035,
                                                      child: 
                                                      SelectableText.rich(
                                                         TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: 'Teléfono: ',
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: themeProvider.themeMode.index == 0 || themeProvider.themeMode.index == 1 ? Colors.black : Colors.white)
                                                              ),
                                                              TextSpan(
                                                                text: prospectosFiltrados[index].phone,
                                                                style: const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors.blue)
                                                              ),
                                                            ]
                                                          ),
                                                        
                                                      )
                                                  ),
                                                
                                                  
                                                  Container(
                                                    color: Colors.transparent,
                                                    width: size.width * 0.6,
                                                    height: size.height * 0.035,
                                                      child: 
                                                      SelectableText.rich(
                                                         TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: 'Registro: ',
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: themeProvider.themeMode.index == 0 || themeProvider.themeMode.index == 1 ? Colors.black : Colors.white)
                                                              ),
                                                              TextSpan(
                                                                text: prospectosFiltrados[index].dateCreate != null ? DateFormat('dd/MM/yyyy HH:mm:ss').format(prospectosFiltrados[index].dateCreate!) : '-------',
                                                                style: const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.blue)
                                                              ),
                                                            ]
                                                          ),
                                                        
                                                      )
                                                  ),
                                                

                                                  Container(
                                                    color: Colors.transparent,
                                                    width: size.width * 0.54,
                                                    height: size.height * 0.035,
                                                      child: AutoSizeText(
                                                        prospectosFiltrados[index].stageId.name,
                                                        style: TextStyle(
                                                          fontWeight: prospectosFiltrados[index].stageId.name.toLowerCase() == 'ganado' ? FontWeight.bold : FontWeight.normal,
                                                          fontSize: 10,
                                                          color: prospectosFiltrados[index].stageId.name.toLowerCase() == 'perdido' ? Colors.red :
                                                          prospectosFiltrados[index].stageId.name.toLowerCase() == 'ganado' ? Colors.blue : Colors.green,                                                          
                                                        ),
                                                        maxLines: 2,
                                                        textAlign: TextAlign.left,                                                        
                                                      ),
                                                    ),
                                                
                                                  ],
                                                ),
                                              ),
                                                  
                                                  
                                            ],
                                          )
                                        ),
                                            Container(
                                              width: size.width * 0.13,
                                              height: size.height * 0.17,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                //color: Colors.black12, // Color del óvalo
                                                color: themeProvider.themeMode.index == 0 ? Colors.black12 : Colors.white,
                                                borderRadius: BorderRadius.circular(50), // Bordes redondeados para el óvalo
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Container(
                                                    color: Colors.transparent,
                                                    height: size.height * 0.04,
                                                    alignment: Alignment.topCenter,
                                                    child: IconButton(
                                                      icon: const Icon(Icons.location_pin, color: Colors.grey, size: 20,),
                                                      onPressed: () {
                                                        context.push(Rutas().rutaMap);
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    color: Colors.transparent,
                                                    height: size.height * 0.04,
                                                    alignment: Alignment.topCenter,
                                                    child: IconButton(
                                                      icon: const Icon(Icons.route, color: Colors.grey, size: 20,),
                                                      onPressed: () {
                                                        
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    color: Colors.transparent,
                                                    height: size.height * 0.04,
                                                    child: IconButton(
                                                      icon: const Icon(Icons.edit, color: Colors.grey, size: 20,),
                                                      onPressed: () async {

                                                        objDatumCrmLead = prospectosFiltrados[index];
                            
                                                        //ignore: use_build_context_synchronously
                                                        FocusScope.of(context).unfocus();
                            
                                                        terminoBusqueda = '';
                                                        filtroPrspTxt = TextEditingController();

                                                        rutaActualGen = Rutas().rutaEditProsp;
                                                        accionNav = true;
                            
                                                        await context.push(Rutas().rutaEditProsp);

                                                        await refreshDataProsp();
    
                                                        // Esto es solo para asegurar que la UI se reconstruya
                                                        //setState(() {});
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(height: size.height * 0.004,)
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: size.width * 0.01,)
                                          ],
                                          ),
                                        ),
                                      ),
                                    )
                                  );
                                },
                              ),
                          ),
                          floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
                          floatingActionButton: showButtonScrool
                            ? FloatingActionButton(
                                onPressed: scrollToTop,
                                backgroundColor: Colors.black45,
                                child: const Icon(Icons.arrow_upward, color: Colors.white,),
                              )
                            : null,
                        ),
                      ),
                      

                      if(prospectosFiltrados.isEmpty && !listaVaciaPrp)
                      Container(
                        width: size.width * 0.75,
                        height: size.height * 0.65,
                        color: Colors.transparent,
                        alignment: Alignment.topCenter,
                        child: ConsultaVaciaScreen(null, msmCabBand: 'Atención', msmBand: 'No existe el prospecto buscado', imgCabBand: 'gifs/consulta_vacia.gif',)
                      ),

                      if(prospectosFiltrados.isEmpty && listaVaciaPrp)
                      Container(
                        width: size.width * 0.75,
                        height: size.height * 0.65,
                        color: Colors.transparent,
                        alignment: Alignment.topCenter,
                        child: ConsultaVaciaScreen(null, msmCabBand: 'Atención', msmBand: 'No existe información para mostrar', imgCabBand: 'gifs/consulta_vacia.gif',)
                      )
                    ],
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
      ),
      floatingActionButton: FloatingActionButton(                
        onPressed: () async {
          terminoBusqueda = '';
          filtroPrspTxt = TextEditingController();

          accionNav = true;
          await context.push(objRutasGen.rutaRegistroPrsp);
          await refreshDataProsp();
        },
        backgroundColor: const Color.fromRGBO(75, 57, 239, 1.0),
        child: const Icon(Icons.person_add_alt, color: Colors.white,),
      ),
    )
    :
    Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              //ignore: use_build_context_synchronously
              FocusScope.of(context).unfocus();
              
              terminoBusqueda = '';
              filtroPrspTxt = TextEditingController();
              //context.pop();

              //ignore:use_build_context_synchronously
              context.push(objRutasGen.rutaHome);
            },
          ),
          title: const Text('Prospectos'),
        ),
      body: BlocBuilder<GenericBloc, GenericState>(
        builder: (context,state) {

          return FutureBuilder(
            future: ProspectoTypeService().getProspectos(),
            builder: (context, snapshot) {

              if (snapshot.hasError) {
                return const Center(
                  child: AutoSizeText(
                    '!UPS¡, intenta acceder después de unos minutos.',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }

              if (snapshot.hasData) {

                //List<ClientModelResponse> lstCLientes = [];//snapshot.data as List<ClientModelResponse>;

                String objRsp = snapshot.data as String;

                var objLogDecode = json.decode(objRsp);
                var objLogDecode2 = json.decode(objLogDecode);

                var tstLength = objLogDecode2["result"]["data"]["crm.lead"]["length"];

                String contStr = '$tstLength';

                contLst = 0;

                contLst = int.parse(contStr);

                //String estadoPrsp = '';
                ProspectoResponseModel apiResponse = ProspectoResponseModel.fromJson(objLogDecode);

                List<DatumCrmLead> prospectosFiltrados = [];

                if(terminoBusqueda.isNotEmpty){
                  prospectosFiltrados = apiResponse.result.data.crmLead.data
                  .where(
                    (producto) => producto.name.toLowerCase().contains(terminoBusqueda.toLowerCase())
                  )
                  .toList();

                  if(prospectosFiltrados.isEmpty){
                    prospectosFiltrados = apiResponse.result.data.crmLead.data
                    .where((producto) =>
                        producto.emailFrom.toLowerCase().contains(terminoBusqueda.toLowerCase()))
                    .toList();
                  }

                  if(prospectosFiltrados.isEmpty) {
                    for(int i = 0; i < apiResponse.result.data.crmLead.data.length; i++) {
                      if(apiResponse.result.data.crmLead.data[i].phone != null && apiResponse.result.data.crmLead.data[i].phone!.contains(terminoBusqueda)){
                        prospectosFiltrados.add(apiResponse.result.data.crmLead.data[i]);
                      }
                    }
                  }

                  contLst = 0;

                  contLst = prospectosFiltrados.length;
                } else{
                  prospectosFiltrados = apiResponse.result.data.crmLead.data;
                }

                if(prospectosFiltrados.isNotEmpty){
                  List<DatumCrmLead> listaDescendente = List.of(prospectosFiltrados)
                  ..sort((a, b) => b.priority.compareTo(a.priority));
                  prospectosFiltrados = [];
                  prospectosFiltrados = listaDescendente;

                }

                return SingleChildScrollView(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                  
                      Container(
                        color: Colors.white,
                        width: size.width * 0.98,
                        child: TextField(
                          inputFormatters: [
                            EmojiInputFormatter()
                          ],
                          decoration: const InputDecoration(
                            hintText: 'Buscar prospectos por nombre, correo o celular',
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                          ),
                          onChanged: (value) {
                            actualizaListaPrp = false;
                            terminoBusqueda = value;
                            //refreshDataByFiltro(value, objRsp);                            
                          },
                          onEditingComplete: () {
                            actualizaListaPrp = true;
                            setState(() { });
                          },
                          onTapOutside: (event) {
                            actualizaListaPrp = true;
                            setState(() { });
                          },
                        ),
                      ),

                      if(prospectosFiltrados.isNotEmpty)         
                      SizedBox(height: size.height * 0.02,),

                      if(prospectosFiltrados.isNotEmpty) 
                      Container(
                        color: Colors.transparent,
                        width: size.width,
                        height: size.height * 0.65,
                        child: ListView.builder(
                          controller: scrollListaClt,
                          itemCount: contLst,
                          itemBuilder: ( _, int index ) {

                            return Slidable(
                              key: ValueKey(prospectosFiltrados[index].id),
                              startActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) => context.push(Rutas().rutaPlanificacionActividades),
                                      backgroundColor: objColorsApp.celeste,
                                      foregroundColor: Colors.white,
                                      icon: Icons.call_outlined,
                                      label: 'Actividades',
                                    ),
                                
                                  ]
                              ),
                              child: ListTile(
                                title: Container(
                                color: Colors.transparent,
                                width: size.width * 0.98,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color: const Color.fromARGB(255, 217, 217, 217)
                                    ),
                                    borderRadius: const BorderRadius.all(Radius.circular(10))
                                  ),
                                  width: size.width * 0.98,
                                  height: size.height * 0.195,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.7,
                                        height: size.height * 0.25,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(width: size.width * 0.01,),
                                            Container(
                                              color: Colors.transparent,
                                        width: size.width * 0.14,
                                        height: size.height * 0.1,
                                              child: CircleAvatar(
                                                        radius: 30.0,
                                                        backgroundColor: Colors.grey[200],
                                                        child: const Icon(Icons.person, color: Colors.grey, size: 40.0),
                                                      ),
                                            ),
                                            Container(
                                              color: Colors.transparent,
                                        width: size.width * 0.55,
                                        height: size.height * 0.25,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  color: Colors.transparent,
                                                  width: size.width * 0.54,
                                                  height: size.height * 0.04,
                                                  child: Text(
                                                    prospectosFiltrados[index].name,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      //fontSize: 10,
                                                      //color: Colors.black
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    ),
                                                ),
                                                Container(
                                                  color: Colors.transparent,
                                                  width: size.width * 0.54,
                                                  height: size.height * 0.04,
                                                  child: AutoSizeText(
                                                    prospectosFiltrados[index].contactName ?? '',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      //fontSize: 10,
                                                      //color: Colors.black
                                                    ),
                                                    maxLines: 1,
                                                    minFontSize: 4,
                                                    textAlign: TextAlign.left,
                                                    ),
                                                ),
                                                Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.54,
                                              height: size.height * 0.035,
                                              child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                text: TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: 'Email: ',
                                                      //style: TextStyle(color: Colors.black)
                                                    ),
                                                    TextSpan(
                                                      //
                                                      //text: '${objLogDecode2["result"]["data"]["crm.lead"]["data"][index]["email_from"]}',
                                                      text: prospectosFiltrados[index].emailFrom,
                                                      style: const TextStyle(color: Colors.blue)
                                                    ),
                                                  ]
                                                ),
                                              )
                                          
                                            ),
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.54,
                                              height: size.height * 0.035,
                                                child: 
                                                RichText(
                                                  overflow: TextOverflow.ellipsis,
                                                  text: TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: 'Teléfono: ',
                                                        //style: TextStyle(color: Colors.black)
                                                      ),
                                                      TextSpan(
                                                        text: prospectosFiltrados[index].phone,
                                                        style: const TextStyle(color: Colors.blue)
                                                      ),
                                                    ]
                                                  ),
                                                )
                                            ),
                                            Container(
                                                color: Colors.transparent,
                                                width: size.width * 0.54,
                                              height: size.height * 0.035,
                                                child: AutoSizeText(
                                                    prospectosFiltrados[index].stageId.name,
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 10,
                                                        color: Colors.green
                                                      ),
                                                      maxLines: 2,
                                                      textAlign: TextAlign.left,),
                                            ),
                                          
                                                ],
                                              ),
                                            ),
                                            
                                            
                                          ],
                                        )
                                      ),
                                      Container(
                                        width: size.width * 0.11,
                                        height: size.height * 0.17,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.black12,// Color del óvalo
                                          borderRadius: BorderRadius.circular(50), // Bordes redondeados para el óvalo
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          //crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              color: Colors.transparent,
                                              height: size.height * 0.03,
                                              alignment: Alignment.topCenter,
                                              child: IconButton(
                                                icon: const Icon(Icons.location_pin, color: Colors.grey, size: 20,),
                                                onPressed: () {},
                                              ),
                                            ),
                                            Container(
                                              color: Colors.transparent,
                                              height: size.height * 0.03,
                                              alignment: Alignment.topCenter,
                                              child: IconButton(
                                                icon: const Icon(Icons.route, color: Colors.grey, size: 20,),
                                                onPressed: () {},
                                              ),
                                            ),
                                            Container(
                                              color: Colors.transparent,
                                              height: size.height * 0.03,
                                              child: IconButton(
                                                icon: const Icon(Icons.info, color: Colors.grey, size: 20,),
                                                onPressed: () {
                                                  terminoBusqueda = '';
                                                  filtroPrspTxt = TextEditingController();
                                                  
                                                  objDatumCrmLead = prospectosFiltrados[index];
                                                  context.push(Rutas().rutaEditProsp);
                                                },
                                              ),
                                            ),
                                            SizedBox(height: size.height * 0.004,)
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: size.width * 0.01,)
                                    ],
                                    ),
                                  ),
                                ),
                              )
                            );
                          },
                        ),
                      ),

                      if(prospectosFiltrados.isEmpty && !listaVaciaPrp)
                      Container(
                        width: size.width * 0.75,
                        height: size.height * 0.75,
                        color: Colors.transparent,
                        alignment: Alignment.topCenter,
                        child: ConsultaVaciaScreen(null, msmCabBand: 'Atención', msmBand: 'No existe el prospecto buscado', imgCabBand: 'gifs/consulta_vacia.gif',)
                      ),

                      if(prospectosFiltrados.isEmpty && listaVaciaPrp)
                      Container(
                        width: size.width * 0.75,
                        height: size.height * 0.75,
                        color: Colors.transparent,
                        alignment: Alignment.topCenter,
                        child: ConsultaVaciaScreen(null, msmCabBand: 'Atención', msmBand: 'No existe información para mostrar', imgCabBand: 'gifs/consulta_vacia.gif',)
                      )
                    ],
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
      ),
        
    );
  }

  Future<String> getProspectos() async {
    return await ProspectoTypeService().lstProspectosMemoria();
  }

  Future<void> refreshDataByFiltro(String objMemoria) async { 
               
    prospectosFiltrados = [];

    CrmLead apiResponse = CrmLead.fromJson(objMemoria);

    if(terminoBusqueda.isNotEmpty){
      if(prospectosFiltrados.isEmpty){
        for(int i = 0; i < apiResponse.data.length; i++){
          if(apiResponse.data[i].emailFrom.toLowerCase().contains(terminoBusqueda.toLowerCase()) 
          || apiResponse.data[i].name.toLowerCase().contains(terminoBusqueda.toLowerCase()) 
          || (apiResponse.data[i].contactName != null && apiResponse.data[i].contactName!.toLowerCase().contains(terminoBusqueda.toLowerCase()))){
            prospectosFiltrados.add(apiResponse.data[i]);
          }
        }
      }
      if(prospectosFiltrados.isEmpty){ //&& (terminoBusqueda.contains('+') || terminoBusqueda.contains('0'))){

        String numeroConCodigoPais = '';
        String primerosDos = terminoBusqueda.substring(0, 2);

        if(primerosDos == '09'){
          numeroConCodigoPais = terminoBusqueda.replaceFirst(primerosDos, "5939");
          terminoBusqueda = numeroConCodigoPais;
        }
        
        for(int i = 0; i < apiResponse.data.length; i++){
          if(apiResponse.data[i].phone != null && apiResponse.data[i].phone!.contains(terminoBusqueda)){
            prospectosFiltrados.add(apiResponse.data[i]);
          }
        }

      }

      contLst = 0;

      contLst = prospectosFiltrados.length;
    } else{
      prospectosFiltrados = apiResponse.data;
    }

    if(prospectosFiltrados.isNotEmpty){
      List<DatumCrmLead> listaDescendente = List.of(prospectosFiltrados)
      ..sort((a, b) => b.priority.compareTo(a.priority));
      prospectosFiltrados = [];
      prospectosFiltrados = listaDescendente;
    }

    return;

  }

  Future<void> refreshDataByMes(int mesSelect, String objMemoria, bool muestraTodos) async {

    refreshDataByEstado(objMemoria, '-- Todos --');

    prospectosFiltrados = [];

    CrmLead apiResponse = CrmLead.fromJson(objMemoria);

    if(terminoBusqueda.isEmpty){
      if(mesSelect != 0 && !muestraTodos){
        prospectosFiltrados = apiResponse.data.where((element) => element.dateOpen!.month == mesSelect && element.dateOpen!.year == selectedYear).toList();
        contLst = 0;

        contLst = prospectosFiltrados.length;
      } else{
        if(prospectosFiltrados.isEmpty && selectedYear != 0){
          prospectosFiltrados = apiResponse.data.where((element) => element.dateOpen!.year == selectedYear).toList();
        }
        /*
        else{
          prospectosFiltrados = apiResponse.data;
        }
        */
      }
    }
    else{
      if(prospectosFiltrados.isEmpty){
        for(int i = 0; i < apiResponse.data.length; i++){
          if(apiResponse.data[i].dateOpen!.month == mesSelect && apiResponse.data[i].dateOpen!.year == selectedYear
            && (
              apiResponse.data[i].emailFrom.toLowerCase().contains(terminoBusqueda.toLowerCase()) 
          || apiResponse.data[i].name.toLowerCase().contains(terminoBusqueda.toLowerCase()) 
          || (apiResponse.data[i].contactName != null && apiResponse.data[i].contactName!.toLowerCase().contains(terminoBusqueda.toLowerCase()))
            )
          ){
            prospectosFiltrados.add(apiResponse.data[i]);
          }
        }
      }
      if(prospectosFiltrados.isEmpty){ //&& (terminoBusqueda.contains('+') || terminoBusqueda.contains('0'))){
        for(int i = 0; i < apiResponse.data.length; i++){
          if(apiResponse.data[i].dateOpen!.month == mesSelect && apiResponse.data[i].dateOpen!.year == selectedYear
            && (apiResponse.data[i].phone != null && apiResponse.data[i].phone!.contains(terminoBusqueda))
          ){
            prospectosFiltrados.add(apiResponse.data[i]);
          }
        }
      }
    }

    setState(() {});

  }

  Future<void> refreshDataByEstado(String objMemoria, String state) async {               
    prospectosFiltrados = [];

    CrmLead apiResponse = CrmLead.fromJson(objMemoria);

    if(state != EnvironmentsProd().estadoProspectoTodos){
      for(int i = 0; i < apiResponse.data.length; i++){

        //GANADO
        if(
          state.toLowerCase() == EnvironmentsProd().estadoProspectoGanado &&
          apiResponse.data[i].active != null && apiResponse.data[i].active == true          
          && apiResponse.data[i].stageId.id == lstEstadoProspectos.firstWhere(((element) => element.stageUsage!.toLowerCase() == 'won')).id
        ){
          prospectosFiltrados.add(apiResponse.data[i]);
        }

        //PERDIDO 
        if(
          state.toLowerCase() == EnvironmentsProd().estadoProspectoPerdido &&
          apiResponse.data[i].active != null && apiResponse.data[i].active == false
        ){
          prospectosFiltrados.add(apiResponse.data[i]);
        }

        //NUEVO
        if(
          state.toLowerCase() == EnvironmentsProd().estadoProspectoNuevo &&
          apiResponse.data[i].active != null && apiResponse.data[i].active == true
          && apiResponse.data[i].stageId.id == lstEstadoProspectos.firstWhere(((element) => element.stageUsage!.toLowerCase() == 'new')).id
        ){
          prospectosFiltrados.add(apiResponse.data[i]);
        }
      }
    }
    else{
      prospectosFiltrados = apiResponse.data;
    }

    return;

  }

  Future<void> generarReporte(BuildContext context) async {
  try {
    // Crear libro Excel y hoja
    final excel = exc.Excel.createExcel();
    final sheet = excel['Reporte'];

    final headerStyle = exc.CellStyle(
      bold: true,
      horizontalAlign: exc.HorizontalAlign.Center,
      backgroundColorHex: exc.ExcelColor.grey300//"#DDDDDD", // gris suave
    );

    final headers = [
      exc.TextCellValue('Fecha de creación'),
      exc.TextCellValue('Nombre'),
      exc.TextCellValue('Celular'),      
      exc.TextCellValue('Oportunidad'),
      exc.TextCellValue('Correo'),
      exc.TextCellValue('Estado'),
    ];

    sheet.appendRow(headers);

    // Aplicar estilo a la primera fila (índice 0)
    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.cell(exc.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.cellStyle = headerStyle;
    }

    sheet.setColumnWidth(0, 20); // Fecha de creación
    sheet.setColumnWidth(1, 40); // Nombre
    sheet.setColumnWidth(2, 19); // Celular
    sheet.setColumnWidth(3, 30); // Oportunidad
    sheet.setColumnWidth(4, 40); // Correo
    sheet.setColumnWidth(5, 15); // Estado

    // (Opcional) Altura de la primera fila (encabezado)
    sheet.setRowHeight(0, 25);

    // Llenar datos dinámicamente
    for (var d in prospectosFiltrados) {
      sheet.appendRow([
        exc.TextCellValue(
          d.dateOpen != null
              ? DateFormat('dd/MM/yyyy', 'es').format(d.dateOpen!)
              : '',
        ),
        exc.TextCellValue(d.contactName ?? ''),
        exc.TextCellValue(d.phone ?? ''),        
        exc.TextCellValue(d.name),
        exc.TextCellValue(d.emailFrom),
        exc.TextCellValue(d.stageId.name),
      ]);
    }

    // Obtener directorio temporal
    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/ReporteProspectos.xlsx';

    // Guardar archivo
    final file = File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);

    // Abrir archivo automáticamente
    await OpenFilex.open(file.path);

    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Reporte generado correctamente')),
    );
  } catch (e) {
    //debugPrint('❌ Error generando el reporte: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error al generar el reporte')),
    );
  }
}

  Future<void> cargaComboEstadosProspectos() async {
    if(lstEstadoProspectos.isNotEmpty) return;

    const storage = FlutterSecureStorage();
    String cmbCamp = await storage.read(key: 'cmbLstEstadosProspecto') ?? '';

    var objCamp = json.decode(cmbCamp);
    
    var rsp = CrmStageResponse.fromJson(objCamp);

    lstEstadoProspectos = rsp.data ?? [];

    lstEstadoProspectos.add(
      CrmStage(
        active: false,
        createDate: '',
        createUid: null,
        displayName: '-- Todos --',
        name: '-- Todos --',
      )
    );

    selectCrmStage = lstEstadoProspectos.last;

    setState(() {
      
    });
  }

}

class _MenuCard extends StatelessWidget {
  final MenuGridWidgetModel item;
  const _MenuCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        item.onTap!();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 40, color: Colors.grey.shade500),
            const SizedBox(height: 10),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

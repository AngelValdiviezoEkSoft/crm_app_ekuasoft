
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

String objRspGen = '';
List<int> years = [];
List<DatumCrmLead> prospectosFiltrados = [];
String terminoBusqueda = '';
DatumCrmLead? objDatumCrmLead;
late TextEditingController filtroPrspTxt;
bool listaVaciaPrp = false;
bool actualizaListaPrp= false;
bool ingresaUnaVez = true;

class ListaProspectosScreen extends StatefulWidget {
  const ListaProspectosScreen({super.key});

  @override
  State<ListaProspectosScreen> createState() => _ListaProspectosScreenState();
}

//class MarcacionScreen extends StatelessWidget {
class _ListaProspectosScreenState extends State<ListaProspectosScreen> {

  late Future<String> _futureProspectos;
  int selectedYear = DateTime.now().year;
  int? _mesSeleccionado; // mes del 1 al 12  

  bool showButtonScrool = false;
  final ScrollController scrollListaClt = ScrollController();

  late int _pageSize;
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

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  Future<void> fetchPage(int pageKey) async {
     try {
      final url = Uri.parse(
          "https://api.ejemplo.com/leads?page=$pageKey&size=$_pageSize"); // API ficticia
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newItems = (data['items'] as List)
            .map((item) => DatumCrmLead.fromJson(item))
            .toList();

        final isLastPage = newItems.length < _pageSize;
        if (isLastPage) {
          pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(newItems, nextPageKey);
        }
      } else {
        throw Exception('Error al cargar datos paginados');
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  Future<void> refreshDataProsp() async {

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
            mensajeMostrarDialogCargando: 'el listado de prospectos.',
          ),
        ]
      ),
    );

    if(resInt.isEmpty){
      var rspPrsp = await ProspectoTypeService().getProspectos();

      var objLogDecode = json.decode(rspPrsp);
      var objLogDecode2 = json.decode(objLogDecode);

      var tstLength = objLogDecode2["result"]["data"]["crm.lead"]["length"];

      String contStr = '$tstLength';

      contLst = 0;

      contLst = int.parse(contStr);

      CrmLeadAppModel apiResponse = CrmLeadAppModel.fromJson(objLogDecode2["result"]["data"]["crm.lead"]);

      List<CrmLeadDatumAppModel> prospectosFiltrados = [];

      if(terminoBusqueda.isNotEmpty){
        
        if(!terminoBusqueda.contains('+') && !terminoBusqueda.contains('0')){

          for(int i = 0; i < apiResponse.data.length; i++){
            if(apiResponse.data[i].name != null && apiResponse.data[i].name!.toLowerCase().contains(terminoBusqueda.toLowerCase())){
              prospectosFiltrados.add(apiResponse.data[i]);
            }
          }

          if(prospectosFiltrados.isEmpty){

            for(int i = 0; i < apiResponse.data.length; i++){
              if(apiResponse.data[i].contactName != null && apiResponse.data[i].contactName!.toLowerCase().contains(terminoBusqueda.toLowerCase())){
                prospectosFiltrados.add(apiResponse.data[i]);
              }
            }

          }

          if(prospectosFiltrados.isEmpty){

            for(int i = 0; i < apiResponse.data.length; i++){
              if(apiResponse.data[i].emailFrom != null && apiResponse.data[i].emailFrom!.toLowerCase().contains(terminoBusqueda.toLowerCase())){
                prospectosFiltrados.add(apiResponse.data[i]);
              }
            }
          }
        } else {
          if(prospectosFiltrados.isEmpty && (terminoBusqueda.contains('+') || terminoBusqueda.contains('0'))){
            for(int i = 0; i < apiResponse.data.length; i++){
              if(apiResponse.data[i].phone != null && apiResponse.data[i].phone!.contains(terminoBusqueda)){
                prospectosFiltrados.add(apiResponse.data[i]);
              }
            }
          }
        }

        contLst = prospectosFiltrados.length;
      } else{
        prospectosFiltrados = apiResponse.data;
      }

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
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              //ignore: use_build_context_synchronously
              FocusScope.of(context).unfocus();

              terminoBusqueda = '';
              filtroPrspTxt = TextEditingController();
              context.pop();

              //ignore:use_build_context_synchronously
              //context.push(objRutasGen.rutaHome);
            },
          ),
          title: const Text('Prospectos'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                terminoBusqueda = '';
                filtroPrspTxt.text = '';
                refreshDataByFiltro(objRspGen);
                _mesSeleccionado = null;//DateTime.now().month;
                selectedYear = DateTime.now().year;
                                
                refreshDataProsp();
              },
            ),
            IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: () {
                //context.push(objRutasGen.rutaAgenda);
                context.push(objRutasGen.rutaConsultaActividades);
              },
            ),
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
                    //refreshDataByMes(_mesSeleccionado ?? 0, objRsp, _mesSeleccionado == 13);
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
                        height: size.height * 0.02,
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
                                
                                setState(() {
                                  
                                });
                              },
                              icon: Icon(Icons.cancel,
                                size: 24,
                                color: AppLightColors().gray900PrimaryText
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
                        height: size.height * 0.02,
                      ),

                      //VALIDAR QUE SEA SOLO PARA CVE
                      Container(
                        color: Colors.white,
                        width: size.width * 0.96,
                        child: DropdownButtonFormField<int>(
                          //dropdownColor: themeProvider.themeMode.index == 0 ? Colors.white : Colors.black,
                          //style: TextStyle(color: themeProvider.themeMode.index == 0 ? Colors.white : Colors.black,),
                          hint: const Text('Selecciona un mes', style: TextStyle(color: Colors.black),),//, style: TextStyle(color: themeProvider.themeMode.index == 0 || themeProvider.themeMode.index == 2 ? Colors.white : Colors.black,),),
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
                            _mesSeleccionado = value;
                            
                            refreshDataByMes(_mesSeleccionado ?? 0, objRspGen, _mesSeleccionado == 13);
                          },
                        ),
                      ),

                      SizedBox(
                        height: size.height * 0.02,
                      ),

                      //VALIDAR QUE SEA SOLO PARA CVE
                      Container(
                        color: Colors.white,
                        width: size.width * 0.96,
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
                            selectedYear = value!;
                            refreshDataByMes(_mesSeleccionado ?? 0, objRspGen, _mesSeleccionado == 13);                            
                          },
                        ),
                      ),


                      if(prospectosFiltrados.isNotEmpty)         
                      SizedBox(height: size.height * 0.02,),

                      if(prospectosFiltrados.isNotEmpty) 
                      Container(
                        color: Colors.transparent,
                        width: size.width,
                        height: size.height * 0.52,
                        child: Scaffold(
                          body: CustomRefreshIndicator(
                            onRefresh: refreshDataProsp,
                            builder: (context, child, controllerOp) {
                               // Personalización del indicador
                              return Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  if (controllerOp.isDragging || controllerOp.value > 0)
                                    Positioned(
                                      top: size.height * 0.01,//50,
                                      child: Opacity(
                                        opacity: 1,//controllerOp.value,
                                        child: Container(
                                          height: size.height * 0.07,//30,
                                          width: size.width * 0.08,//30,
                                          color: Colors.transparent,
                                          /*
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blueAccent,
                                          ),
                                          */
                                          child: const CircularProgressIndicator(
                                            strokeWidth: 1,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  
                                  Transform.translate(
                                    offset: Offset(0, 100 * controllerOp.value),
                                    child: child,
                                  ),
                                ],
                              );
                            },
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
                                          onPressed: (context) 
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
                          
                                            //context.push(Rutas().rutaPlanificacionActividades);
                                            context.push(Rutas().rutaPlanActivConActiv);
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
                                            color: Colors.transparent,
                                            border: Border.all(
                                                color: const Color.fromARGB(255, 217, 217, 217)),
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
                                                        child: Text(
                                                          prospectosFiltrados[index].name,
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.bold,                                                                
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
                                                        child: Text(
                                                          prospectosFiltrados[index].contactName ?? '',
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.bold,                                                                
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
                                                    height: size.height * 0.035,
                                                      child: 
                                                      SelectableText.rich(
                                                         TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: 'Email: ',
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: themeProvider.themeMode.index == 0 || themeProvider.themeMode.index == 1 ? Colors.black : Colors.white)
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
                                              width: size.width * 0.13,
                                              height: size.height * 0.17,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                //color: Colors.black12, // Color del óvalo
                                                color: themeProvider.themeMode.index == 0 ? Colors.white30 : Colors.white,
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
                                                      icon: const Icon(Icons.info, color: Colors.grey, size: 20,),
                                                      onPressed: () {
                            
                                                        objDatumCrmLead = prospectosFiltrados[index];
                            
                                                        //ignore: use_build_context_synchronously
                                                        FocusScope.of(context).unfocus();
                            
                                                        terminoBusqueda = '';
                                                        filtroPrspTxt = TextEditingController();
                            
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
      floatingActionButton: FloatingActionButton(                
        onPressed: () {
          terminoBusqueda = '';
          filtroPrspTxt = TextEditingController();
          context.push(objRutasGen.rutaRegistroPrsp);
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
                                          color: const Color.fromARGB(255, 217, 217, 217)),
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
                                                    //
                                                    //'${objLogDecode2["result"]["data"]["crm.lead"]["data"][index]["name"]}',
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
                                                    //prospectosFiltrados[index]
                                                    //'${objLogDecode2["result"]["data"]["crm.lead"]["data"][index]["contact_name"]}',
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

    return;

  }

  Future<void> refreshDataByMes(int mesSelect, String objMemoria, bool muestraTodos) async {            
    prospectosFiltrados = [];

    CrmLead apiResponse = CrmLead.fromJson(objMemoria);

    if(terminoBusqueda.isEmpty){
      if(mesSelect != 0 && !muestraTodos){
        prospectosFiltrados = apiResponse.data.where((element) => element.dateOpen!.month == mesSelect && element.dateOpen!.year == selectedYear).toList();
        contLst = 0;

        contLst = prospectosFiltrados.length;
      } else{
        prospectosFiltrados = apiResponse.data;
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

    //setState(() {});

  }

}

//void doNothing(BuildContext context) {}
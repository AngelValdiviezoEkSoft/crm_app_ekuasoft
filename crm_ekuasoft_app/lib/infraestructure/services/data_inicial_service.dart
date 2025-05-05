
import 'dart:convert';

import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storageDataInicial = FlutterSecureStorage();

class DataInicialService extends ChangeNotifier{

  final String endPoint = CadenaConexion().apiEndpoint;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isValidForm(){
    return formKey.currentState?.validate() ?? false;
  }

  readModelosApp(List<Map<String, dynamic>> modelo) async {
    try {

      var codImei = await storageProspecto.read(key: 'codImei') ?? '';

      var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

      ConsultaMultiModelRequestModel objReq = ConsultaMultiModelRequestModel(
        jsonrpc: EnvironmentsProd().jsonrpc,
        params: ParamsMultiModels(
          bearer: obj.result.bearer,
          company: objLogDecode['result']['current_company'],
          imei: codImei,
          key: obj.result.key,
          tocken: obj.result.tocken,
          tockenValidDate: obj.result.tockenValidDate,
          uid: objLogDecode['result']['uid'],
          models: []
        )
      );

      await GenericService().getMultiModelosGen(objReq, modelo);
      
    }
    catch(_){
      //print('Test DataInit $ex');
    }
  }
  
  readCombosProspectos() async {

    try{

      var objCamp = await CampaniaService().getCompanias();
      var objOrigen = await OrigenService().getOrigenes();
      var objMedias = await MediaService().getMedias();
      var objActividades = await ActivitiesService().getActivities();
      var objPaises = await PaisService().getPaises();
      //var objPaises = await PaisService().getPaises();

      await storageDataInicial.write(key: 'cmbCampania', value: json.encode(objCamp));
      await storageDataInicial.write(key: 'cmbOrigen', value: json.encode(objOrigen));
      await storageDataInicial.write(key: 'cmbMedia', value: json.encode(objMedias));
      await storageDataInicial.write(key: 'cmbActividades', value: json.encode(objActividades));
      await storageDataInicial.write(key: 'cmbPaises', value: json.encode(objPaises));
      //await storageDataInicial.write(key: 'RespuestaIrModel', value: json.encode());

    }
    catch(ex){
      //print('TST init: $ex');
    }
  }

  Future<String> readPrincipalPage() async {

    try{
      final registraProspecto = await storageDataInicial.read(key: 'registraProspecto') ?? '';
      
      var connectivityResult = await ValidacionesUtils().validaInternet();

      String rspRegistro = '';

      if(registraProspecto.isNotEmpty && connectivityResult.isEmpty){
        var objReg = jsonDecode(registraProspecto);

        Map<String, dynamic> jsonMap = jsonDecode(objReg);        

        DatumCrmLead  objGuardar = DatumCrmLead.fromMap2(jsonMap);

        await ProspectoTypeService().registraProspecto(objGuardar);
        await storageDataInicial.delete(key: 'registraProspecto');

        rspRegistro = 'G';
      }

      final resp = await storageDataInicial.read(key: 'RespuestaLogin') ?? '';

      final data = json.decode(resp);
      final objTmp = data['result'];
      final lstFinal = objTmp['allowed_companies'];
      final objPermisosTmp = objTmp['done_permissions'];

      Map<String, dynamic> dataTmp = json.decode(json.encode(lstFinal));

      List<String> lstRsp = [];

      dataTmp.forEach((key, value) {
        if(key == objTmp['current_company'].toString()){
          lstRsp.add(value['name']);
        }
      });

      dataTmp.forEach((key, value) {
        if(key != objTmp['current_company'].toString()){                  
          lstRsp.add(value['name']);
        }
      });

      String respCmbLst = '';

      final objPermisos = DonePermissions.fromJson(objPermisosTmp);

      objPermisosGen = objPermisos;

      final items = <ItemBoton>[
        if(objPermisos.mainMenu.itemListLeads)
        ItemBoton('','','',1, Icons.group_add, 'Prospectos', 'Seguimiento y control de prospectos','','', Colors.white, Colors.white,false,false,'','','icCompras.png','icComprasTrans.png','',
          Rutas().rutaListaProspectos, 
          () {
            
          }
        ),
        if(objPermisos.mainMenu.itemListPartners)
        ItemBoton('','','',2, Icons.groups, 'Clientes', 'Listado de todos los clientes asignados','','', Colors.white, Colors.white,false,false,'','','icTramApr.png','icTramAprTrans.png','',
          Rutas().rutaListaClientes, 
          () {
            
          }
        ),
        if(objPermisos.mainMenu.itemScheduledVisits)
        ItemBoton('','','',3, Icons.calendar_month, 'Visitas Agendadas', 'Listado de clientes programados para el día','','', Colors.white, Colors.white,false,false,'','','icTramProc.png','icTramProcTrans.png','',
          Rutas().rutaConstruccion, 
          () {}
        ),
        if(objPermisos.mainMenu.itemListCatalog)
        ItemBoton('','','',4, Icons.auto_stories_sharp, 'Catálogo', 'Catálogo de productos con imágenes','','', Colors.white, Colors.white,false,false,'','','icCompras.png','icComprasTrans.png','',
          Rutas().rutaConstruccion, 
          () {}
        ),
        if(objPermisos.mainMenu.itemListInventory)
        ItemBoton('','','',5, Icons.dashboard_customize_outlined, 'Inventario', 'Inventario general de productos con stock','','', Colors.white, Colors.white,false,false,'','','icTramApr.png','icTramAprTrans.png','',
          Rutas().rutaConstruccion, 
          () {}
        ),
        if(objPermisos.mainMenu.itemListPriceList)
        ItemBoton('','','',6, Icons.format_list_bulleted_add, 'Listas de precio', 'Lista de precios generales para ventas','','', Colors.white, Colors.white,false,false,'','','icTramProc.png','icTramProcTrans.png','',
          Rutas().rutaConstruccion, 
          () {}
        ),
        if(objPermisos.mainMenu.itemListPromotions)
        ItemBoton('','','',7, Icons.percent, 'Promociones Vigentes', 'Listado de Promociones Vigentes','','', Colors.white, Colors.white,false,false,'','','icCompras.png','icComprasTrans.png','',
          Rutas().rutaConstruccion, 
          () {}
        ),
        if(objPermisos.mainMenu.itemListDistribution)
        ItemBoton('','','',8, Icons.inventory_rounded, 'Distribución en Rutas', 'Permite realizar el control de vehículos para reparto de ruta','','', Colors.white, Colors.white,false,false,'','','icCompras.png','icComprasTrans.png','',
          Rutas().rutaConstruccion, 
          () {}
        ),
      ]; 

      var rspPrsp = await ProspectoTypeService().getProspectos();
      var rspCli = await ClienteService().getClientes();

      await storageDataInicial.write(key: 'RespuestaProspectos', value: rspPrsp);
      await storageDataInicial.write(key: 'RespuestaClientes', value: rspCli);
      
      final jsonString = serializeItemBotonMenuList(items);      

      respCmbLst = '$rspRegistro---${json.encode(lstRsp)}---$jsonString---${objPermisos.mainMenu.cardSales}---${objPermisos.mainMenu.cardCollection}';

      return respCmbLst;
    }
    catch(ex){
      //print('Error gen: $ex');
      return '';
    }
  }

}

  Map<String, dynamic> serializeItemBotonMenu(ItemBoton item) {
    return {
      'tipoNotificacion': item.tipoNotificacion,
      'idSolicitud': item.idSolicitud,
      'idNotificacionGen': item.idNotificacionGen,
      'ordenNot': item.ordenNot,
      'icon': item.icon.codePoint,
      'mensajeNotificacion': item.mensajeNotificacion,
      'mensaje2': item.mensaje2,
      'fechaNotificacion': item.fechaNotificacion,
      'tiempoDesde': item.tiempoDesde,
      'color1': item.color1.value,
      'color2': item.color2.value,
      'requiereAccion': item.requiereAccion,
      'esRelevante': item.esRelevante,
      'estadoLeido': item.estadoLeido,
      'numIdenti': item.numIdenti,
      'iconoNotificacion': item.iconoNotificacion,
      'rutaImagen': item.rutaImagen,
      'idTransaccion': item.idTransaccion,
      'rutaNavegacion': item.rutaNavegacion,
    };
  }


  String serializeItemBotonMenuList(List<ItemBoton> items) {    
    final serializedList = items.map((item) => serializeItemBotonMenu(item)).toList();

    return jsonEncode(serializedList);
  }

  List<ItemBoton> deserializeItemBotonMenuList(String jsonString) {
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => deserializeItemBotonMenu(json)).toList();
  }

  ItemBoton deserializeItemBotonMenu(Map<String, dynamic> json) {
    IconData iconData;
    
    try{
      iconData = IconData(
        json['icon'],
        fontFamily: 'MaterialIcons',
      );
    }
    catch(_){
      iconData = Icons.abc;
    }
    
    return ItemBoton(
      json['tipoNotificacion'] ?? '',
      json['idSolicitud'] ?? '',
      json['idNotificacionGen'] ?? '',
      json['ordenNot'] ?? 0,
      iconData,
      json['mensajeNotificacion'] ?? '',
      json['mensaje2'] ?? '',
      json['fechaNotificacion'] ?? '',
      json['tiempoDesde'] ?? '',
      Color(json['color1'] ?? 0),
      Color(json['color2'] ?? 0),
      json['requiereAccion'] ?? false,
      json['esRelevante'] ?? false,
      json['estadoLeido'] ?? '',
      json['numIdenti'] ?? '',
      json['iconoNotificacion'] ?? '',
      json['rutaImagen'] ?? '',
      json['idTransaccion'] ?? '',
      json['rutaNavegacion'] ?? '',
      () {},
    );
  
  }


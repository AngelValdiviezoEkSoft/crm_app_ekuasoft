part of 'generic_bloc.dart';

class GenericState extends Equatable {

  final storage = const FlutterSecureStorage();
  final int positionMenu;
  final int positionFormaPago;
  final double coordenadasMapa;
  final double radioMarcacion;
  final String formaPago;
  final String localidadId;
  final String idFormaPago;
  final double heightModalPlanAct;
  final bool muestraCarga;

  const GenericState(
    {
      positionMenu = 0,
      positionFormaPago = 0,
      coordenadasMapa = 0,
      radioMarcacion = 0,
      formaPago = 'C',
      localidadId = '',
      idFormaPago = '',
      heightModalPlanAct = 0.65,
      muestraCarga,
    } 
  ) : positionMenu = positionMenu ?? 0,
      positionFormaPago = positionFormaPago ?? 0,
      coordenadasMapa = coordenadasMapa ?? 0,
      radioMarcacion = radioMarcacion ?? 0,
      formaPago = formaPago ?? 'C',
      localidadId = localidadId ?? '',
      idFormaPago = idFormaPago ?? '',
      heightModalPlanAct = heightModalPlanAct ?? 0.65,
      muestraCarga = muestraCarga ?? false;
  

  GenericState copyWith({
    int? positionMenu,
    int? positionFormaPago,
    double? coordenadasMapa,
    double? radioMarcacion,
    String? formaPago,
    String? localidadId,
    String? idFormaPago,
    double? heightModalPlanAct,
    bool? muestraCarga
  }) 
  => GenericState(
    positionMenu: positionMenu ?? this.positionMenu,
    positionFormaPago: positionFormaPago ?? this.positionFormaPago,
    coordenadasMapa: coordenadasMapa ?? this.coordenadasMapa,
    radioMarcacion: radioMarcacion ?? this.radioMarcacion,
    formaPago: formaPago ?? this.formaPago,
    localidadId: localidadId ?? this.localidadId,
    idFormaPago: idFormaPago ?? this.idFormaPago,
    heightModalPlanAct: heightModalPlanAct ?? this.heightModalPlanAct,
    muestraCarga: muestraCarga ?? this.muestraCarga
  );


  @override
  List<Object> get props => [positionMenu,positionFormaPago,coordenadasMapa,radioMarcacion,formaPago,localidadId,idFormaPago, heightModalPlanAct, muestraCarga];

  Future<String> readPrincipalPage() async {

    try{
      final registraProspecto = await storage.read(key: 'registraProspecto') ?? '';
      final registraActividad = await storage.read(key: 'RegistraActividad') ?? '';
      
      var connectivityResult = await ValidacionesUtils().validaInternet();

      String rspRegistro = '';

      if(registraProspecto.isNotEmpty && connectivityResult.isEmpty){
        var objReg = jsonDecode(registraProspecto);

        Map<String, dynamic> jsonMap = jsonDecode(objReg);        

        DatumCrmLead  objGuardar = DatumCrmLead.fromMap2(jsonMap);

        await ProspectoTypeService().registraProspecto(objGuardar);
        await storage.delete(key: 'registraProspecto');

        rspRegistro = 'G';
      }

      if(registraActividad.isNotEmpty && connectivityResult.isEmpty){

        var objReg = jsonDecode(registraActividad);

        try{

          var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
          var objLogDecode = json.decode(objLog);

          List<Map<String, dynamic>> lstMem = [];
          
          for(int i = 0; i < objReg.length; i++){
            ActivitiesTypeRequestModel objGuardar = ActivitiesTypeRequestModel.fromJson(objReg[i]);
            //await ActivitiesService().registroActividades(objGuardar);            

            lstMem.add(
              {
                "date_deadline": DateFormat('yyyy-MM-dd', 'es').format(objGuardar.dateDeadline!),
                "create_date": DateFormat('yyyy-MM-dd', 'es').format(objGuardar.createDate!),
                "create_uid": objLogDecode['result']['uid'],
                "active": true,
                "previous_activity_type_id": objGuardar.previousActivityTypeId,
                "display_name": objGuardar.displayName,
                "activity_type_id": objGuardar.activityTypeId,
                "res_model_id": 501,
                "user_id": objGuardar.userId,
                "res_id": objGuardar.resId,
                "summary": objGuardar.note,
                "note": objGuardar.note,
              }
            );

          }

          await ActivitiesService().registroListadoActividades(lstMem);

          await storage.delete(key: 'RegistraActividad');

          rspRegistro = 'G';
        }
        catch(_){
          //print('Test: $ex');
          rspRegistro = 'EG';
        }
        
      }

      final resp = await storage.read(key: 'RespuestaLogin') ?? '';

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
          Rutas().rutaAgenda,
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

      final jsonString = serializeItemBotonMenuList(items);      

      respCmbLst = '$rspRegistro---${json.encode(lstRsp)}---$jsonString---${objPermisos.mainMenu.cardSales}---${objPermisos.mainMenu.cardCollection}';

      return respCmbLst;
    }
    catch(ex){
      return '';
    }
  }

  Future<String> waitCarga() async {
    
    return await Future.delayed(
      const Duration(milliseconds: 2500), 
        () => 'ok'
      ); 
  }
  
  readCombosGen() async {
    
    String cmbCamp = await storage.read(key: 'cmbCampania') ?? '';
    String cmbOrigen = await storage.read(key: 'cmbOrigen') ?? '';
    String cmbMedia = await storage.read(key: 'cmbMedia') ?? '';
    String cmbAct = await storage.read(key: 'cmbActividades') ?? '';
    String cmbPais = await storage.read(key: 'cmbPaises') ?? '';
    String cmbLstAct = await storage.read(key: 'cmbLstActividades') ?? '';

    return "$cmbCamp---$cmbOrigen---$cmbMedia---$cmbAct---$cmbPais---$cmbLstAct";
  }

  readDatosPerfil() async {    
    String objLogin = await storage.read(key: 'RespuestaLogin') ?? '';

    return objLogin;
  }

  
  Future<String> lstProspectos() async {
    var rsp = await storage.read(key: 'RespuestaProspectos') ?? '';
    //print('Lst Prsp: $rsp');
    return rsp;
  }

  Future<String> lstClientes() async {
    var rsp = await storage.read(key: 'RespuestaClientes') ?? '';    
    return rsp;
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

}


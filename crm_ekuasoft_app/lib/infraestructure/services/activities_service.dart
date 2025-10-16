import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:intl/intl.dart';

const storageAct = FlutterSecureStorage();
final objMensajesAlertasAct = MensajesAlertas();

class ActivitiesService extends ChangeNotifier{

  static final jsonRpc = EnvironmentsProd().jsonrpc;

  final TokenManager tokenManager = TokenManager();

  final String endPoint = CadenaConexion().apiEndpoint;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  getActivities() async {
    try{

      var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

      var objRspIrModel = await storageDataInicial.read(key: 'IdIrModelForAct') ?? '';
      int resModelId = int.parse(objRspIrModel);
      
      List<MultiModel> lstMultiModel = [];

      lstMultiModel.add(
        MultiModel(model: 'mail.activity')
      );

      final models = [
        {
          "model": EnvironmentsProd().modMailAct,
          "filters": [
            ["user_id", "=", objLogDecode['result']['uid']],
            ["res_model_id","=",resModelId]
          ]
        },
      ];

      var codImei = await storageProspecto.read(key: 'codImei') ?? '';

      var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      ConsultaMultiModelRequestModel objReq = ConsultaMultiModelRequestModel(
        jsonrpc: jsonRpc,
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

      String ruta = '';
      final objStr = await storageAct.read(key: 'RespuestaRegistro') ?? '';
      
      if(objStr.isNotEmpty)
      {  
        var obj = RegisterDeviceResponseModel.fromJson(objStr);
        ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/data/multi/models';
      }

      String tockenValidDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(objReq.params.tockenValidDate);

      final requestBody = {
        "jsonrpc": jsonRpc,
        "params": {
          "key": objReq.params.key,
          "tocken": objReq.params.tocken,
          "imei": objReq.params.imei,
          "uid": objReq.params.uid,
          "company": objReq.params.company,
          "bearer": objReq.params.bearer,
          "tocken_valid_date": tockenValidDate,
          "models": models
        }
      };

      final headers = {
        "Content-Type": EnvironmentsProd().contentType//"application/json",
      };

      final response = await http.post(
        Uri.parse(ruta),
        headers: headers,
        body: jsonEncode(requestBody), 
      );
      
      //var rspValidacion = json.decode(response.body);

    //print('Lst gen: ${response.body}');

      var rsp = AppResponseModel.fromRawJson(response.body);


      await storageAct.write(key: 'cmbLstActividades', value: json.encode(rsp.result.data.mailActivity));


      String cmbLstAct = await storageAct.read(key: 'cmbLstActividades') ?? '';

      ActivitiesResponseModel objActividades = ActivitiesResponseModel.fromRawJson(cmbLstAct);
      
      return objActividades;
    }
    on SocketException catch (_) {
      Fluttertoast.showToast(
        msg: objMensajesProspectoService.mensajeFallaInternet,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );  
    }
  }

  getActivitiesById(id) async {
    try{

      var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

      var objRspIrModel = await storageDataInicial.read(key: 'IdIrModelForAct') ?? '';
      int resModelId = int.parse(objRspIrModel);
      
      if(id == 0){
        var strMem = await storageAct.read(key: 'idMem') ?? '';

        id = int.parse(strMem);
      }

      List<MultiModel> lstMultiModel = [];

      lstMultiModel.add(
        MultiModel(model: 'mail.activity')
      );

      final models = [
        {
          "model": EnvironmentsProd().modMailAct,
          "filters": [
            ["user_id", "=", objLogDecode['result']['uid']],
            ["date_deadline","=",DateFormat('yyyy-MM-dd', 'es').format(DateTime.now())],
            ["res_id","=",id],
            ["res_model_id","=",resModelId]
          ]
        },
      ];

      var codImei = await storageProspecto.read(key: 'codImei') ?? '';

      var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      ConsultaMultiModelRequestModel objReq = ConsultaMultiModelRequestModel(
        jsonrpc: jsonRpc,
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

      String ruta = '';
      final objStr = await storageAct.read(key: 'RespuestaRegistro') ?? '';
      
      if(objStr.isNotEmpty)
      {  
        var obj = RegisterDeviceResponseModel.fromJson(objStr);
        ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/data/multi/models';
      }

      String tockenValidDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(objReq.params.tockenValidDate);

      final requestBody = {
        "jsonrpc": jsonRpc,
        "params": {
          "key": objReq.params.key,
          "tocken": objReq.params.tocken,
          "imei": objReq.params.imei,
          "uid": objReq.params.uid,
          "company": objReq.params.company,
          "bearer": objReq.params.bearer,
          "tocken_valid_date": tockenValidDate,
          "models": models
        }
      };

      final headers = {
        "Content-Type": EnvironmentsProd().contentType//"application/json",
      };

      final response = await http.post(
        Uri.parse(ruta),
        headers: headers,
        body: jsonEncode(requestBody), 
      );
      
      //var rspValidacion = json.decode(response.body);

    //print('Lst gen: ${response.body}');

      var rsp = AppResponseModel.fromRawJson(response.body);


      await storageAct.write(key: 'cmbLstActividades', value: json.encode(rsp.result.data.mailActivity));


      String cmbLstAct = await storageAct.read(key: 'cmbLstActividades') ?? '';

      ActivitiesResponseModel objActividades = ActivitiesResponseModel.fromRawJson(cmbLstAct);
      
      return objActividades;
    }
    on SocketException catch (_) {
      Fluttertoast.showToast(
        msg: objMensajesProspectoService.mensajeFallaInternet,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );  
    }
  }

  getActivitiesByFecha(fecha) async {
    try{

      var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

      var objRspIrModel = await storageDataInicial.read(key: 'IdIrModelForAct') ?? '';
      int resModelId = int.parse(objRspIrModel);

      List<MultiModel> lstMultiModel = [];

      lstMultiModel.add(
        MultiModel(model: 'mail.activity')
      );

      final models = [
        {
          "model": EnvironmentsProd().modMailAct,
          "filters": [
            ["user_id", "=", objLogDecode['result']['uid']],
            ["date_deadline","=",fecha],            
            ["res_model_id","=",resModelId]
          ]
        },
      ];

      var codImei = await storageProspecto.read(key: 'codImei') ?? '';

      var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      ConsultaMultiModelRequestModel objReq = ConsultaMultiModelRequestModel(
        jsonrpc: jsonRpc,
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

      String ruta = '';
      final objStr = await storageAct.read(key: 'RespuestaRegistro') ?? '';
      
      if(objStr.isNotEmpty)
      {  
        var obj = RegisterDeviceResponseModel.fromJson(objStr);
        ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/data/multi/models';
      }

      String tockenValidDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(objReq.params.tockenValidDate);

      final requestBody = {
        "jsonrpc": jsonRpc,
        "params": {
          "key": objReq.params.key,
          "tocken": objReq.params.tocken,
          "imei": objReq.params.imei,
          "uid": objReq.params.uid,
          "company": objReq.params.company,
          "bearer": objReq.params.bearer,
          "tocken_valid_date": tockenValidDate,
          "models": models
        }
      };

      final headers = {
        "Content-Type": EnvironmentsProd().contentType//"application/json",
      };

      final response = await http.post(
        Uri.parse(ruta),
        headers: headers,
        body: jsonEncode(requestBody), 
      );
      
      //var rspValidacion = json.decode(response.body);

    //print('Lst gen: ${response.body}');

      var rsp = AppResponseModel.fromRawJson(response.body);


      await storageAct.write(key: 'cmbLstActividades', value: json.encode(rsp.result.data.mailActivity));


      String cmbLstAct = await storageAct.read(key: 'cmbLstActividades') ?? '';

      ActivitiesResponseModel objActividades = ActivitiesResponseModel.fromRawJson(cmbLstAct);
      
      return objActividades;
    }
    on SocketException catch (_) {
      Fluttertoast.showToast(
        msg: objMensajesProspectoService.mensajeFallaInternet,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );  
    }
  }

  getTipoActividades() async {
    var cmbAct = await storageAct.read(key: 'cmbActividades') ?? '';

    if(cmbAct.isNotEmpty){
      MailActivityTypeAppModel  objFinAct = MailActivityTypeAppModel.fromRawJson(cmbAct);

      return objFinAct;
    }

  }

  getActivitiesDiariasByProspecto(fechas, resId) async {
    String internet = await ValidacionesUtils().validaInternet();
    
    //VALIDACIÓN DE INTERNET
    if(internet == 'N') return;

    try{

      var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

      var objRspIrModel = await storageDataInicial.read(key: 'IdIrModelForAct') ?? '';
      int resModelId = int.parse(objRspIrModel);

      var connectivityResult = await ValidacionesUtils().validaInternet();

      var cmbAct = await storageAct.read(key: 'cmbActividades') ?? '';

      MailActivityTypeAppModel  objFinAct = MailActivityTypeAppModel.fromRawJson(cmbAct);

      if(objFinAct.data.isEmpty){

        var objAct = json.decode(cmbAct);
        try{
          //var rst2 = objAct['result']['data']['mail.activity.type'];
          var rst = objAct['result']['data']['mail.activity.type'];
          objFinAct = MailActivityTypeAppModel.fromJson(rst);
        }
        catch(ex){
          //print(ex);
        }

        try{
          if(objFinAct.data.isEmpty){
          
            var codImei = await storageAct.read(key: 'codImei') ?? '';
            var objReg = await storageAct.read(key: 'RespuestaRegistro') ?? '';
            var obj = RegisterDeviceResponseModel.fromJson(objReg);
            var objLog = await storageAct.read(key: 'RespuestaLogin') ?? '';
            var objLogDecode = json.decode(objLog);

            List<MultiModel> lstMultiModel = [];

            lstMultiModel.add(
              MultiModel(model: 'crm.lead')
            );

            final models = [        
              {
                "model": EnvironmentsProd().modActiv,//"mail.activity.type",
                "filters": [
                  ["res_model","=",false]
                ]
              },
            ];


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
                models: lstMultiModel
              )
            );

            var rsp = await GenericService().getMultiModelosGenNoMemoria(objReq, models);

            var objAct = json.decode(rsp);
        
            var rst = objAct['result']['data']['mail.activity.type'];
            objFinAct = MailActivityTypeAppModel.fromJson(rst);
            
            //objFinAct = MailActivityTypeAppModel.fromJson();
            
            }
        }
        catch(ex){
          //print(ex);
        }
      }

      if(connectivityResult.isNotEmpty){
        ActivitiesPageModel objRspFinal = ActivitiesPageModel(
        activities: ActivitiesResponseModel(
          data: [],
          fields: FieldsActivities(code: 'NO_INTERNET', name: '', stateIds: ''),
          length: 0
        ),
        lead: DatumCrmLead(
          activityIds: [], campaignId: CampaignId(id: 0, name: ''), countryId: StructCombos(id: 0, name: ''),
          dayClose: 0, emailFrom: '', expectedRevenue: 0, id: 0, lostReasonId: CampaignId(id: 0, name: ''),
          mediumId: StructCombos(id: 0, name: ''), mobile: '', name: '', partnerId: PartnerId(id: 0, name: '', tradeName: '', cantonId: StructCombos(id: 0, name: ''), regionId: StructCombos(id: 0, name: ''), sectorId: StructCombos(id: 0, name: ''), channelId: StructCombos(id: 0, name: ''), cityId: StructCombos(id: 0, name: ''), clasificationId: StructCombos(id: 0, name: ''), email: ''),
          priority: '', sourceId: StructCombos(id: 0, name: ''), stageId: StructCombos(id: 0, name: ''),
          stateId: StructCombos(id: 0, name: ''), tagIds: [], title: CampaignId(id: 0, name: ''),
          type: '', city: '', contactName: '', dateClose: null, dateDeadline: null, dateOpen: null, description: '',
          emailCc: '', partnerName: '', phone: '', probability: 0, referred: '', street: '',
          userId: StructCombos(id: 0, name: '')
        ),
        objMailAct: objFinAct
      );

        return objRspFinal;
      }

      String modeloConsulta = EnvironmentsProd().modMailAct;

      List<MultiModel> lstMultiModel = [];

      lstMultiModel.add(
        MultiModel(model: 'mail.activity')
      );

      if(resId != null && resId == 0){        
        var idMem = await storageProspecto.read(key: 'idMem') ?? '';

        if(idMem.isNotEmpty){
          resId = int.parse(idMem);
        }        
      }

      var models = [];

      if(fechas == 'mem'){
        var fecMem = await storageProspecto.read(key: 'fecMem') ?? '';

        if(fecMem.isNotEmpty){
          DateTime fecha = DateTime.parse(fecMem);
          fechas = null;
          fechas = [];
          fechas.add(fecha);
        } else {
          fechas = null;
        }
      } else {
        var fecMem = await storageProspecto.read(key: 'fecMem') ?? '';

        if(fecMem.isNotEmpty){
          DateTime fecha = DateTime.parse(fecMem);

          fechas = null;
          fechas = [];

          fechas.add(fecha);
        }
      }

      String fechaBusqueda = '';
      
      if(fechas == null){

        fechaBusqueda = DateFormat('yyyy-MM-dd', 'es').format(DateTime.now());
        fechas = [];
        fechas.add(DateTime.now());

        models = [
          {
            "model": modeloConsulta,
            "filters": [            
              ["user_id", "=", objLogDecode['result']['uid']],
              ["date_deadline","=",DateFormat('yyyy-MM-dd', 'es').format(DateTime.now())],            
              ["res_model_id", "=", resModelId],
              if(resId != null && resId > 0)
              ["res_id", "=", resId]
            ]
          },
        ];
      } else {
        try{
          fechaBusqueda = DateFormat('yyyy-MM-dd', 'es').format(fechas[1]);

          models = [
            {
            "model": modeloConsulta,
            "filters": [            
              ["user_id", "=", objLogDecode['result']['uid']],
              ["date_deadline",">=",DateFormat('yyyy-MM-dd', 'es').format(fechas[0])],            
              ["date_deadline","<=",DateFormat('yyyy-MM-dd', 'es').format(fechas[1])],
              ["res_model_id", "=", resModelId],
              if(resId != null && resId > 0)
              ["res_id", "=", resId]
            ]
          },
        ];
        }
        catch(_)
        {
          fechaBusqueda = DateFormat('yyyy-MM-dd', 'es').format(fechas[0]);

          models = [
              {
              "model": modeloConsulta,
              "filters": [            
                ["user_id", "=", objLogDecode['result']['uid']],
                ["date_deadline","=",DateFormat('yyyy-MM-dd', 'es').format(fechas[0])],            
                ["res_model_id", "=", resModelId],
                if(resId != null && resId > 0)
                ["res_id", "=", resId]
              ]
            },
          ];
        }
      }

      var codImei = await storageProspecto.read(key: 'codImei') ?? '';

      var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      ConsultaMultiModelRequestModel objReq = ConsultaMultiModelRequestModel(
        jsonrpc: jsonRpc,
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

      String ruta = '';
      final objStr = await storageAct.read(key: 'RespuestaRegistro') ?? '';
      
      if(objStr.isNotEmpty)
      {  
        var obj = RegisterDeviceResponseModel.fromJson(objStr);
        ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/data/multi/models';
      }

      String tockenValidDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(objReq.params.tockenValidDate);

      final requestBody = {
        "jsonrpc": jsonRpc,
        "params": {
          "key": objReq.params.key,
          "tocken": objReq.params.tocken,
          "imei": objReq.params.imei,
          "uid": objReq.params.uid,
          "company": objReq.params.company,
          "bearer": objReq.params.bearer,
          "tocken_valid_date": tockenValidDate,
          "models": models
        }
      };

      final headers = {
        "Content-Type": EnvironmentsProd().contentType
      };

      final response = await http.post(
        Uri.parse(ruta),
        headers: headers,
        body: jsonEncode(requestBody), 
      );
      
      var rsp = AppResponseModel.fromRawJson(response.body);

      //print('Consulta agenda: ${response.body}');

      String cmbLstAct = json.encode(rsp.result.data.mailActivity);//await storageAct.read(key: 'cmbLstActividades') ?? '';

      ActivitiesResponseModel objActividades = ActivitiesResponseModel.fromRawJson(cmbLstAct);

      var lstProsp = await storageAct.read(key: 'RespuestaProspectos') ?? '';

      var objLogDecode2 = json.decode(lstProsp);      

      CrmLeadAppModel apiResponse = CrmLeadAppModel.fromJson(objLogDecode2);

      CrmLeadDatumAppModel? objFin;
      
      for(int i = 0; i < apiResponse.data.length; i++){
        if(apiResponse.data[i].id == resId){
          objFin = apiResponse.data[i];
        }
      }

      DatumCrmLead objDatumCrmLeadFin = DatumCrmLead(
        activityIds: [],
        campaignId: CampaignId(
          id: objFin?.campaignId.id ?? 0,
          name: objFin?.campaignId.name ?? ''
        ),
        countryId: StructCombos(
          id: objFin?.countryId.id ?? 0,
          name: objFin?.countryId.name ?? ''
        ),
        dayClose: 0,//objFin.dateClose,
        emailFrom: objFin?.emailFrom ?? '',
        expectedRevenue: objFin?.expectedRevenue ?? 0,
        id: objFin?.id ?? 0,
        lostReasonId: CampaignId(
          id: objFin?.lostReasonId.id ?? 0,
          name: objFin?.lostReasonId.name ?? ''
        ),
        mediumId: StructCombos(
          id: objFin?.mediumId.id ?? 0,
          name: objFin?.mediumId.name ?? ''
        ),
        name: objFin?.name ?? '',
        partnerId: PartnerId(
          tradeName: '',
          cantonId: StructCombos(id: 0, name: ''),
          regionId: StructCombos(id: 0, name: ''),
          sectorId: StructCombos(id: 0, name: ''),
          id: objFin?.partnerId.id ?? 0,
          name: objFin?.partnerId.name ?? '',
          channelId: StructCombos(id: 0, name: ''),
          cityId: StructCombos(id: 0, name: ''),
          clasificationId: StructCombos(id: 0, name: ''),
          email: ''
        ),
        priority: objFin?.priority ?? '',
        sourceId: StructCombos(
          id: objFin?.sourceId.id ?? 0,
          name: objFin?.sourceId.name ?? ''
        ),
        stageId: StructCombos(
          id: objFin?.stageId.id ?? 0,
          name: objFin?.stageId.name ?? ''
        ),
        stateId: StructCombos(
          id: objFin?.stateId.id ?? 0,
          name: objFin?.stateId.name ?? ''
        ),
        tagIds: objFin?.tagIds ?? [],
        title: CampaignId(
          id: objFin?.title.id ?? 0,
          name: objFin?.title.name ?? ''
        ),
        type: objFin?.type ?? '',
        //city: objFin!.cit
        contactName: objFin?.contactName,
        dateClose: objFin?.dateClose,
        dateDeadline: objFin?.dateDeadline,
        dateOpen: objFin?.dateOpen,
        description: objFin?.description,
        //emailCc: objFin!.em
        mobile: '',
        city: '',
        emailCc: '',
        partnerName: objFin?.partnerId.name ?? '',
        phone: objFin?.phone,
        probability: objFin?.probability,
        referred: objFin?.referred,
        street: objFin?.street,
        userId: StructCombos(
          id: objFin?.userId.id ?? 0,
          name: objFin?.userId.name ?? ''
        ),
      );

      final lstEncr = await storageAct.read(key: 'LstActividadesAbiertasCerradas') ?? '';

      String internet = await ValidacionesUtils().validaInternet();
    

      if(lstEncr.isNotEmpty && internet.isNotEmpty){
        ActivitiesResponseModel  objMem = ActivitiesResponseModel.fromRawJson(lstEncr);

        for(int i = 0; i < objMem.data.length; i++){
          String fec = DateFormat('yyyy-MM-dd').format(objMem.data[i].dateDeadline);

          if(fec == fechaBusqueda){
            objActividades.data.add(objMem.data[i]);
          }
        }
      }
      
      ActivitiesPageModel objRspFinal = ActivitiesPageModel(
        activities: objActividades,
        lead: objDatumCrmLeadFin,
        objMailAct: objFinAct,
      );

      return objRspFinal;
    }
    catch(_){
     //print('Test: $ex');
    }
  }

  Future<ActivitiesPageModel> getActivitiesByRangoFechas(fechas, resId) async {
    var cmbAct = await storageAct.read(key: 'cmbActividades') ?? '';

    MailActivityTypeAppModel  objFinAct = MailActivityTypeAppModel.fromRawJson(cmbAct);

    try{

      var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

      var objRspIrModel = await storageDataInicial.read(key: 'IdIrModelForAct') ?? '';
      int resModelId = int.parse(objRspIrModel);

      var connectivityResult = await ValidacionesUtils().validaInternet();

      

      if(connectivityResult.isNotEmpty){
        ActivitiesPageModel objRspFinal = ActivitiesPageModel(
        activities: ActivitiesResponseModel(
          data: [],
          fields: FieldsActivities(code: 'NO_INTERNET', name: '', stateIds: ''),
          length: 0
        ),
        lead: DatumCrmLead(
          activityIds: [], campaignId: CampaignId(id: 0, name: ''), countryId: StructCombos(id: 0, name: ''),
          dayClose: 0, emailFrom: '', expectedRevenue: 0, id: 0, lostReasonId: CampaignId(id: 0, name: ''),
          mediumId: StructCombos(id: 0, name: ''), mobile: '', name: '', partnerId: PartnerId(id: 0, name: '', tradeName: '', cantonId: StructCombos(id: 0, name: ''), regionId: StructCombos(id: 0, name: ''), sectorId: StructCombos(id: 0, name: ''), channelId: StructCombos(id: 0, name: ''), cityId: StructCombos(id: 0, name: ''),clasificationId: StructCombos(id: 0, name: ''), email: ''),
          priority: '', sourceId: StructCombos(id: 0, name: ''), stageId: StructCombos(id: 0, name: ''),
          stateId: StructCombos(id: 0, name: ''), tagIds: [], title: CampaignId(id: 0, name: ''),
          type: '', city: '', contactName: '', dateClose: null, dateDeadline: null, dateOpen: null, description: '',
          emailCc: '', partnerName: '', phone: '', probability: 0, referred: '', street: '',
          userId: StructCombos(id: 0, name: '')
        ),
        objMailAct: objFinAct
      );

        return objRspFinal;
      }

      String modeloConsulta = EnvironmentsProd().modMailAct;

      List<MultiModel> lstMultiModel = [];

      lstMultiModel.add(
        MultiModel(model: 'mail.activity')
      );

      if(resId != null && resId == 0){        
        var idMem = await storageProspecto.read(key: 'idMem') ?? '';

        if(idMem.isNotEmpty){
          resId = int.parse(idMem);
        }        
      }

      var models = [];

      if(fechas == 'mem'){
        var fecMem = await storageProspecto.read(key: 'fecMem') ?? '';

        if(fecMem.isNotEmpty){
          DateTime fecha = DateTime.parse(fecMem);
          fechas = null;
          fechas = [];
          fechas.add(fecha);
        } else {
          fechas = null;
        }
      } else {
        var fecMem = await storageProspecto.read(key: 'fecMem') ?? '';

        if(fecMem.isNotEmpty){
          DateTime fecha = DateTime.parse(fecMem);

          fechas = null;
          fechas = [];

          fechas.add(fecha);
        }
      }

      String fechaBusqueda = '';
      
      if(fechas == null){

        fechaBusqueda = DateFormat('yyyy-MM-dd', 'es').format(DateTime.now());
        fechas = [];
        fechas.add(DateTime.now());

        models = [
          {
            "model": modeloConsulta,
            "filters": [            
              ["date_deadline","=",DateFormat('yyyy-MM-dd', 'es').format(DateTime.now())],            
              ["res_model_id", "=", resModelId],
              ["user_id", "=", objLogDecode['result']['uid']],
              if(resId != null && resId > 0)
              ["res_id", "=", resId]
            ]
          },
        ];
      } else {
        try{
          fechaBusqueda = DateFormat('yyyy-MM-dd', 'es').format(fechas[1]);

          models = [
            {
            "model": modeloConsulta,
            "filters": [            
              ["date_deadline",">=",DateFormat('yyyy-MM-dd', 'es').format(fechas[0])],            
              ["date_deadline","<=",DateFormat('yyyy-MM-dd', 'es').format(fechas[1])],
              ["user_id", "=", objLogDecode['result']['uid']],
              ["res_model_id", "=", resModelId],
              if(resId != null && resId > 0)
              ["res_id", "=", resId]
            ]
          },
        ];
        }
        catch(_)
        {
          fechaBusqueda = DateFormat('yyyy-MM-dd', 'es').format(fechas[0]);

          models = [
              {
              "model": modeloConsulta,
              "filters": [           
                ["user_id", "=", objLogDecode['result']['uid']], 
                ["date_deadline","=",DateFormat('yyyy-MM-dd', 'es').format(fechas[0])],            
                ["res_model_id", "=", resModelId],
                if(resId != null && resId > 0)
                ["res_id", "=", resId]
              ]
            },
          ];
        }
      }

      var codImei = await storageProspecto.read(key: 'codImei') ?? '';

      var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      ConsultaMultiModelRequestModel objReq = ConsultaMultiModelRequestModel(
        jsonrpc: jsonRpc,
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

      String ruta = '';
      final objStr = await storageAct.read(key: 'RespuestaRegistro') ?? '';
      
      if(objStr.isNotEmpty)
      {  
        var obj = RegisterDeviceResponseModel.fromJson(objStr);
        ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/data/multi/models';
      }

      String tockenValidDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(objReq.params.tockenValidDate);

      final requestBody = {
        "jsonrpc": jsonRpc,
        "params": {
          "key": objReq.params.key,
          "tocken": objReq.params.tocken,
          "imei": objReq.params.imei,
          "uid": objReq.params.uid,
          "company": objReq.params.company,
          "bearer": objReq.params.bearer,
          "tocken_valid_date": tockenValidDate,
          "models": models
        }
      };

      final headers = {
        "Content-Type": EnvironmentsProd().contentType
      };

      final response = await http.post(
        Uri.parse(ruta),
        headers: headers,
        body: jsonEncode(requestBody), 
      );
      
      var rsp = AppResponseModel.fromRawJson(response.body);

      //print('Consulta agenda: ${response.body}');

      String cmbLstAct = json.encode(rsp.result.data.mailActivity);//await storageAct.read(key: 'cmbLstActividades') ?? '';

      ActivitiesResponseModel objActividades = ActivitiesResponseModel.fromRawJson(cmbLstAct);

      var lstProsp = await storageAct.read(key: 'RespuestaProspectos') ?? '';

      var objLogDecode2 = json.decode(lstProsp);      

      CrmLeadAppModel apiResponse = CrmLeadAppModel.fromJson(objLogDecode2);

      CrmLeadDatumAppModel? objFin;
      
      for(int i = 0; i < apiResponse.data.length; i++){
        if(apiResponse.data[i].id == resId){
          objFin = apiResponse.data[i];
        }
      }

      DatumCrmLead objDatumCrmLeadFin = DatumCrmLead(
        activityIds: [],
        campaignId: CampaignId(
          id: objFin?.campaignId.id ?? 0,
          name: objFin?.campaignId.name ?? ''
        ),
        countryId: StructCombos(
          id: objFin?.countryId.id ?? 0,
          name: objFin?.countryId.name ?? ''
        ),
        dayClose: 0,//objFin.dateClose,
        emailFrom: objFin?.emailFrom ?? '',
        expectedRevenue: objFin?.expectedRevenue ?? 0,
        id: objFin?.id ?? 0,
        lostReasonId: CampaignId(
          id: objFin?.lostReasonId.id ?? 0,
          name: objFin?.lostReasonId.name ?? ''
        ),
        mediumId: StructCombos(
          id: objFin?.mediumId.id ?? 0,
          name: objFin?.mediumId.name ?? ''
        ),
        name: objFin?.name ?? '',
        partnerId: PartnerId(
          id: objFin?.partnerId.id ?? 0,
          tradeName: '',
          name: objFin?.partnerId.name ?? '',
          channelId: StructCombos(id: 0, name: ''),
          cityId: StructCombos(id: 0, name: ''),
          clasificationId: StructCombos(id: 0, name: ''),
          email: '',
          cantonId: StructCombos(id: 0, name: ''),
          regionId: StructCombos(id: 0, name: ''),
          sectorId: StructCombos(id: 0, name: '')
        ),
        priority: objFin?.priority ?? '',
        sourceId: StructCombos(
          id: objFin?.sourceId.id ?? 0,
          name: objFin?.sourceId.name ?? ''
        ),
        stageId: StructCombos(
          id: objFin?.stageId.id ?? 0,
          name: objFin?.stageId.name ?? ''
        ),
        stateId: StructCombos(
          id: objFin?.stateId.id ?? 0,
          name: objFin?.stateId.name ?? ''
        ),
        tagIds: objFin?.tagIds ?? [],
        title: CampaignId(
          id: objFin?.title.id ?? 0,
          name: objFin?.title.name ?? ''
        ),
        type: objFin?.type ?? '',
        //city: objFin!.cit
        contactName: objFin?.contactName,
        dateClose: objFin?.dateClose,
        dateDeadline: objFin?.dateDeadline,
        dateOpen: objFin?.dateOpen,
        description: objFin?.description,
        //emailCc: objFin!.em
        mobile: '',
        city: '',
        emailCc: '',
        partnerName: objFin?.partnerId.name ?? '',
        phone: objFin?.phone,
        probability: objFin?.probability,
        referred: objFin?.referred,
        street: objFin?.street,
        userId: StructCombos(
          id: objFin?.userId.id ?? 0,
          name: objFin?.userId.name ?? ''
        ),
      );

      final lstEncr = await storageAct.read(key: 'LstActividadesAbiertasCerradas') ?? '';

      String internet = await ValidacionesUtils().validaInternet();    

      if(lstEncr.isNotEmpty && internet.isNotEmpty){
        ActivitiesResponseModel  objMem = ActivitiesResponseModel.fromRawJson(lstEncr);

        for(int i = 0; i < objMem.data.length; i++){
          String fec = DateFormat('yyyy-MM-dd').format(objMem.data[i].dateDeadline);

          if(fec == fechaBusqueda){
            objActividades.data.add(objMem.data[i]);
          }
        }
      }

      if(internet.isEmpty){
        MailMessageResponseModel? objRsp = await getActivitiesCerradasByRangoFechas(fechas, resId);
        
        if(objRsp != null && objRsp.result.data.mailMessage.length > 0){
          
          for(int i = 0; i < objRsp.result.data.mailMessage.data.length; i++)
          {
              objActividades.data.add(
                DatumActivitiesResponse(
                  activityTypeId: IdActivities(
                    id: objRsp.result.data.mailMessage.data[i].mailActivityTypeId.id,
                    name: objRsp.result.data.mailMessage.data[i].mailActivityTypeId.name
                  ),
                  cerrado: true,
                  dateDeadline: objRsp.result.data.mailMessage.data[i].dateDeadLine,
                  id: objRsp.result.data.mailMessage.data[i].id,
                  resId: objRsp.result.data.mailMessage.data[i].resId,
                  resModel: 'Mail.Message',
                  summary: objRsp.result.data.mailMessage.data[i].description,
                  userId: IdActivities(
                    id: 0,
                    name: '',
                  ),
                  leadName: objRsp.result.data.mailMessage.data[i].recordName,
                  contactName: objRsp.result.data.mailMessage.data[i].recordName,
                  dateCreate: objRsp.result.data.mailMessage.data[i].date,
                  activityCategory: '',
                  cell: '',
                  mail: ''
                )
              );
          }
        }        

      }
      
      ActivitiesPageModel objRspFinal = ActivitiesPageModel(
        activities: objActividades,
        lead: objDatumCrmLeadFin,
        objMailAct: objFinAct,
      );

      return objRspFinal;
    }
    catch(_){
     //print('Test: $ex');
     return ActivitiesPageModel(
        activities: ActivitiesResponseModel(
          data: [],
          fields: FieldsActivities(code: 'ERROR_CATCH', name: '', stateIds: ''),
          length: 0
        ),
        lead: DatumCrmLead(
          activityIds: [], campaignId: CampaignId(id: 0, name: ''), countryId: StructCombos(id: 0, name: ''),
          dayClose: 0, emailFrom: '', expectedRevenue: 0, id: 0, lostReasonId: CampaignId(id: 0, name: ''),
          mediumId: StructCombos(id: 0, name: ''), mobile: '', name: '', partnerId: PartnerId(id: 0, name: '', tradeName: '', cantonId: StructCombos(id: 0, name: ''), regionId: StructCombos(id: 0, name: ''), sectorId: StructCombos(id: 0, name: ''), channelId: StructCombos(id: 0, name: ''), cityId: StructCombos(id: 0, name: ''),clasificationId: StructCombos(id: 0, name: ''), email: ''),
          priority: '', sourceId: StructCombos(id: 0, name: ''), stageId: StructCombos(id: 0, name: ''),
          stateId: StructCombos(id: 0, name: ''), tagIds: [], title: CampaignId(id: 0, name: ''),
          type: '', city: '', contactName: '', dateClose: null, dateDeadline: null, dateOpen: null, description: '',
          emailCc: '', partnerName: '', phone: '', probability: 0, referred: '', street: '',
          userId: StructCombos(id: 0, name: '')
        ),
        objMailAct: objFinAct
      );
    }
  }

  getActivitiesCerradasByRangoFechas(fechas, resId) async {
    try{

      var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

      String modeloConsulta = EnvironmentsProd().modMailMessage;

      if(resId == 0){        
        var idMem = await storageProspecto.read(key: 'idMem') ?? '';

        if(idMem.isNotEmpty){
          resId = int.parse(idMem);
        }        
      }

      var models = [];

      if(fechas == 'mem'){
        var fecMem = await storageProspecto.read(key: 'fecMem') ?? '';

        if(fecMem.isNotEmpty){
          DateTime fecha = DateTime.parse(fecMem);
          fechas = null;
          fechas = [];
          fechas.add(fecha);
        } else {
          fechas = null;
        }
      } else {
        var fecMem = await storageProspecto.read(key: 'fecMem') ?? '';

        if(fecMem.isNotEmpty){
          DateTime fecha = DateTime.parse(fecMem);

          fechas = null;
          fechas = [];

          fechas.add(fecha);
        }
      }

      //String fechaBusqueda = '';

      if(fechas == null){

        //fechaBusqueda = DateFormat('yyyy-MM-dd', 'es').format(DateTime.now());

        models = [
          {
            "model": modeloConsulta,
            "filters": [
              ["user_id", "=", objLogDecode['result']['uid']],
              ["activity_due_date","=",DateFormat('yyyy-MM-dd', 'es').format(DateTime.now())],
            ]
          },
        ];
      } else {
        try{
          //fechaBusqueda = DateFormat('yyyy-MM-dd', 'es').format(fechas[1]);

          models = [
            {
            "model": modeloConsulta,
            "filters": [
              ["user_id", "=", objLogDecode['result']['uid']],
              ["activity_due_date",">=",DateFormat('yyyy-MM-dd', 'es').format(fechas[0])],            
              ["activity_due_date","<=",DateFormat('yyyy-MM-dd', 'es').format(fechas[1])],              
            ]
          },
        ];
        }
        catch(_)
        {
          //fechaBusqueda = DateFormat('yyyy-MM-dd', 'es').format(fechas[0]);

          models = [
              {
              "model": modeloConsulta,
              "filters": [
                ["user_id", "=", objLogDecode['result']['uid']],
                ["activity_due_date",">=",DateFormat('yyyy-MM-dd', 'es').format(fechas[0])],
                ["activity_due_date","<=",DateFormat('yyyy-MM-dd', 'es').format(fechas[0])],
              ]
            },
          ];
        }
      }

      var codImei = await storageProspecto.read(key: 'codImei') ?? '';

      var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      ConsultaMultiModelRequestModel objReq = ConsultaMultiModelRequestModel(
        jsonrpc: jsonRpc,
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

      String ruta = '';
      final objStr = await storageAct.read(key: 'RespuestaRegistro') ?? '';
      
      if(objStr.isNotEmpty)
      {  
        var obj = RegisterDeviceResponseModel.fromJson(objStr);
        ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/data/multi/models';
      }

      String tockenValidDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(objReq.params.tockenValidDate);

      final requestBody = {
        "jsonrpc": jsonRpc,
        "params": {
          "key": objReq.params.key,
          "tocken": objReq.params.tocken,
          "imei": objReq.params.imei,
          "uid": objReq.params.uid,
          "company": objReq.params.company,
          "bearer": objReq.params.bearer,
          "tocken_valid_date": tockenValidDate,
          "models": models
        }
      };

      final headers = {
        "Content-Type": EnvironmentsProd().contentType
      };

      final response = await http.post(
        Uri.parse(ruta),
        headers: headers,
        body: jsonEncode(requestBody), 
      );

      //print('Test de error: ${response.body}');
      
      var rsp = MailMessageResponseModel.fromRawJson(response.body);

      return rsp;
    }
    catch(ex){
     //print('Test: $ex');
    }
  }

  getActivitiesByFiltros(nombre, phone, idTpAct, resId) async {
    try{

      var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

      var objRspIrModel = await storageDataInicial.read(key: 'IdIrModelForAct') ?? '';
      int resModelId = int.parse(objRspIrModel);

      var connectivityResult = await ValidacionesUtils().validaInternet();

      var cmbAct = await storageAct.read(key: 'cmbActividades') ?? '';

      MailActivityTypeAppModel  objFinAct = MailActivityTypeAppModel.fromRawJson(cmbAct);

      if(connectivityResult.isNotEmpty){
        ActivitiesPageModel objRspFinal = ActivitiesPageModel(
        activities: ActivitiesResponseModel(
          data: [],
          fields: FieldsActivities(code: 'NO_INTERNET', name: '', stateIds: ''),
          length: 0
        ),
        lead: DatumCrmLead(
          activityIds: [], campaignId: CampaignId(id: 0, name: ''), countryId: StructCombos(id: 0, name: ''),
          dayClose: 0, emailFrom: '', expectedRevenue: 0, id: 0, lostReasonId: CampaignId(id: 0, name: ''),
          mediumId: StructCombos(id: 0, name: ''), mobile: '', name: '', partnerId: PartnerId(id: 0, tradeName: '', name: '', cantonId: StructCombos(id: 0, name: ''), regionId: StructCombos(id: 0, name: ''), sectorId: StructCombos(id: 0, name: ''), channelId: StructCombos(id: 0, name: ''), cityId: StructCombos(id: 0, name: ''), clasificationId: StructCombos(id: 0, name: ''), email: ''),
          priority: '', sourceId: StructCombos(id: 0, name: ''), stageId: StructCombos(id: 0, name: ''),
          stateId: StructCombos(id: 0, name: ''), tagIds: [], title: CampaignId(id: 0, name: ''),
          type: '', city: '', contactName: '', dateClose: null, dateDeadline: null, dateOpen: null, description: '',
          emailCc: '', partnerName: '', phone: '', probability: 0, referred: '', street: '',
          userId: StructCombos(id: 0, name: '')
        ),
        objMailAct: objFinAct
      );

        return objRspFinal;
      }

      String modeloConsulta = EnvironmentsProd().modMailAct;

      List<MultiModel> lstMultiModel = [];

      lstMultiModel.add(
        MultiModel(model: 'mail.activity')
      );

      if(resId == 0){        
        var idMem = await storageProspecto.read(key: 'idMem') ?? '';

        if(idMem.isNotEmpty){
          resId = int.parse(idMem);
        }        
      }

      var models = [];

      if(nombre != null && nombre.isNotEmpty){
        models = [
          {
            "model": modeloConsulta,
            "filters": [
              ["user_id", "=", objLogDecode['result']['uid']],
              ["res_model_id", "=", resModelId],
              ["lead_name","ilike",nombre]
            ]
          },
        ];
      }

      if(phone != null && phone.isNotEmpty){

        String newPhone = limpiarNumero(phone);

        models = [
          {
            "model": modeloConsulta,
            "filters": [
              ["user_id", "=", objLogDecode['result']['uid']],
              ["res_model_id", "=", resModelId],
              ["lead_phone","ilike",newPhone]              
            ]
          },
        ];
      }

      if(idTpAct != null && idTpAct != 0){
        models = [
          {
            "model": modeloConsulta,
            "filters": [  
              ["user_id", "=", objLogDecode['result']['uid']],                        
              ["res_model_id", "=", resModelId],
              ["activity_type_id","=",idTpAct]
            ]
          },
        ];
      }

      if(nombre != null && nombre.isNotEmpty && phone != null && phone.isNotEmpty){
        String newPhone = limpiarNumero(phone);

        models = [];
        models = [
          {
            "model": modeloConsulta,
            "filters": [
              ["user_id", "=", objLogDecode['result']['uid']],
              ["res_model_id", "=", resModelId],
              ["lead_name","ilike",nombre.toLowerCase()],
              ["lead_phone","ilike",newPhone],
            ]
          },
        ];
      }

      if(nombre != null && nombre.isNotEmpty && idTpAct != null && idTpAct != 0 && (phone == null || phone.isEmpty)){
        models = [];
        models = [
          {
            "model": modeloConsulta,
            "filters": [
              ["user_id", "=", objLogDecode['result']['uid']],
              ["res_model_id", "=", resModelId],
              ["lead_name","ilike",nombre],
              ["activity_type_id","=",idTpAct]
            ]
          },
        ];
      }

      if(phone != null && phone.isNotEmpty && idTpAct != null && idTpAct != 0 && (nombre == null || nombre.isEmpty)){
        models = [];

        String newPhone = limpiarNumero(phone);

        models = [
          {
            "model": modeloConsulta,
            "filters": [
              ["user_id", "=", objLogDecode['result']['uid']],
              ["res_model_id", "=", resModelId],
              ["lead_phone","ilike",newPhone],
              ["activity_type_id","=",idTpAct]
            ]
          },
        ];
      }

      if(nombre != null && nombre.isNotEmpty && phone != null && phone.isNotEmpty
      && idTpAct != null && idTpAct != 0){
        
        models = [];

        String newPhone = limpiarNumero(phone);

        models = [
          {
            "model": modeloConsulta,
            "filters": [      
              ["user_id", "=", objLogDecode['result']['uid']],                    
              ["res_model_id", "=", resModelId],
              ["lead_name","ilike",nombre],
              ["lead_phone","ilike",newPhone],
              ["activity_type_id","=",idTpAct]
            ]
          },
        ];
      }

      var codImei = await storageProspecto.read(key: 'codImei') ?? '';

      var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      ConsultaMultiModelRequestModel objReq = ConsultaMultiModelRequestModel(
        jsonrpc: jsonRpc,
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

      String ruta = '';
      final objStr = await storageAct.read(key: 'RespuestaRegistro') ?? '';
      
      if(objStr.isNotEmpty)
      {  
        var obj = RegisterDeviceResponseModel.fromJson(objStr);
        ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/data/multi/models';
      }

      String tockenValidDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(objReq.params.tockenValidDate);

      final requestBody = {
        "jsonrpc": jsonRpc,
        "params": {
          "key": objReq.params.key,
          "tocken": objReq.params.tocken,
          "imei": objReq.params.imei,
          "uid": objReq.params.uid,
          "company": objReq.params.company,
          "bearer": objReq.params.bearer,
          "tocken_valid_date": tockenValidDate,
          "models": models
        }
      };

      final headers = {
        "Content-Type": EnvironmentsProd().contentType
      };

      final response = await http.post(
        Uri.parse(ruta),
        headers: headers,
        body: jsonEncode(requestBody), 
      );

      //print('NUEVA CONSULTA: ${response.body}');
      
      var rsp = AppResponseModel.fromRawJson(response.body);

      String cmbLstAct = json.encode(rsp.result.data.mailActivity);

      ActivitiesResponseModel objActividades = ActivitiesResponseModel.fromRawJson(cmbLstAct);

      var lstProsp = await storageAct.read(key: 'RespuestaProspectos') ?? '';

      var objLogDecode2 = json.decode(lstProsp);      

      CrmLeadAppModel apiResponse = CrmLeadAppModel.fromJson(objLogDecode2);

      CrmLeadDatumAppModel? objFin;
      
      for(int i = 0; i < apiResponse.data.length; i++){
        if(apiResponse.data[i].id == resId){
          objFin = apiResponse.data[i];
        }
      }

      DatumCrmLead objDatumCrmLeadFin = DatumCrmLead(
        activityIds: [],
        campaignId: CampaignId(
          id: objFin?.campaignId.id ?? 0,
          name: objFin?.campaignId.name ?? ''
        ),
        countryId: StructCombos(
          id: objFin?.countryId.id ?? 0,
          name: objFin?.countryId.name ?? ''
        ),
        dayClose: 0,//objFin.dateClose,
        emailFrom: objFin?.emailFrom ?? '',
        expectedRevenue: objFin?.expectedRevenue ?? 0,
        id: objFin?.id ?? 0,
        lostReasonId: CampaignId(
          id: objFin?.lostReasonId.id ?? 0,
          name: objFin?.lostReasonId.name ?? ''
        ),
        mediumId: StructCombos(
          id: objFin?.mediumId.id ?? 0,
          name: objFin?.mediumId.name ?? ''
        ),
        name: objFin?.name ?? '',
        partnerId: PartnerId(
          tradeName: '',
          id: objFin?.partnerId.id ?? 0,
          name: objFin?.partnerId.name ?? '',
          channelId: StructCombos(id: 0, name: ''),
          cityId: StructCombos(id: 0, name: ''),
          clasificationId: StructCombos(id: 0, name: ''),
          email: '',
          cantonId: StructCombos(id: 0, name: ''),
          regionId: StructCombos(id: 0, name: ''),
          sectorId: StructCombos(id: 0, name: '')
        ),
        priority: objFin?.priority ?? '',
        sourceId: StructCombos(
          id: objFin?.sourceId.id ?? 0,
          name: objFin?.sourceId.name ?? ''
        ),
        stageId: StructCombos(
          id: objFin?.stageId.id ?? 0,
          name: objFin?.stageId.name ?? ''
        ),
        stateId: StructCombos(
          id: objFin?.stateId.id ?? 0,
          name: objFin?.stateId.name ?? ''
        ),
        tagIds: objFin?.tagIds ?? [],
        title: CampaignId(
          id: objFin?.title.id ?? 0,
          name: objFin?.title.name ?? ''
        ),
        type: objFin?.type ?? '',
        //city: objFin!.cit
        contactName: objFin?.contactName,
        dateClose: objFin?.dateClose,
        dateDeadline: objFin?.dateDeadline,
        dateOpen: objFin?.dateOpen,
        description: objFin?.description,
        //emailCc: objFin!.em
        mobile: '',
        city: '',
        emailCc: '',
        partnerName: objFin?.partnerId.name ?? '',
        phone: objFin?.phone,
        probability: objFin?.probability,
        referred: objFin?.referred,
        street: objFin?.street,
        userId: StructCombos(
          id: objFin?.userId.id ?? 0,
          name: objFin?.userId.name ?? ''
        ),
      );

      final lstEncr = await storageAct.read(key: 'LstActividadesAbiertasCerradas') ?? '';

      String internet = await ValidacionesUtils().validaInternet();
    

      if(lstEncr.isNotEmpty && internet.isEmpty && objActividades.data.isNotEmpty){
        ActivitiesResponseModel  objMem = ActivitiesResponseModel .fromRawJson(lstEncr);

        for(int i = 0; i < objMem.data.length; i++){
          if(objActividades.data[0].resId == objMem.data[i].resId){
            objActividades.data.add(objMem.data[i]);
          }          
        }
      }

      ActivitiesPageModel objRspFinal = ActivitiesPageModel(
        activities: objActividades,
        lead: objDatumCrmLeadFin,
        objMailAct: objFinAct,
      );

      return objRspFinal;
    }
    catch(ex){
     print('Test: $ex');
    }
  }

  getActivitiesHistoricasByProspecto(resId) async {
    String internet = await ValidacionesUtils().validaInternet();
    
    //VALIDACIÓN DE INTERNET
    if(internet == 'N') return;

    try{

      var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

      var objRspIrModel = await storageDataInicial.read(key: 'IdIrModelForAct') ?? '';
      int resModelId = int.parse(objRspIrModel);

      var connectivityResult = await ValidacionesUtils().validaInternet();

      var cmbAct = await storageAct.read(key: 'cmbActividades') ?? '';

      MailActivityTypeAppModel  objFinAct = MailActivityTypeAppModel.fromRawJson(cmbAct);

      if(objFinAct.data.isEmpty){

        var objAct = json.decode(cmbAct);
        try{
          //var rst2 = objAct['result']['data']['mail.activity.type'];
          var rst = objAct['result']['data']['mail.activity.type'];
          objFinAct = MailActivityTypeAppModel.fromJson(rst);
        }
        catch(ex){
          //print(ex);
        }

        try{
          if(objFinAct.data.isEmpty){
          
            var codImei = await storageAct.read(key: 'codImei') ?? '';
            var objReg = await storageAct.read(key: 'RespuestaRegistro') ?? '';
            var obj = RegisterDeviceResponseModel.fromJson(objReg);
            var objLog = await storageAct.read(key: 'RespuestaLogin') ?? '';
            var objLogDecode = json.decode(objLog);

            List<MultiModel> lstMultiModel = [];

            lstMultiModel.add(
              MultiModel(model: 'crm.lead')
            );

            final models = [        
              {
                "model": EnvironmentsProd().modActiv,//"mail.activity.type",
                "filters": [
                  ["res_model","=",false]
                ]
              },
            ];


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
                models: lstMultiModel
              )
            );

            var rsp = await GenericService().getMultiModelosGenNoMemoria(objReq, models);

            var objAct = json.decode(rsp);
        
            var rst = objAct['result']['data']['mail.activity.type'];
            objFinAct = MailActivityTypeAppModel.fromJson(rst);
            
            //objFinAct = MailActivityTypeAppModel.fromJson();
            
            }
        }
        catch(ex){
          //print(ex);
        }
      }

      if(connectivityResult.isNotEmpty){
        ActivitiesPageModel objRspFinal = ActivitiesPageModel(
        activities: ActivitiesResponseModel(
          data: [],
          fields: FieldsActivities(code: 'NO_INTERNET', name: '', stateIds: ''),
          length: 0
        ),
        lead: DatumCrmLead(
          activityIds: [], campaignId: CampaignId(id: 0, name: ''), countryId: StructCombos(id: 0, name: ''),
          dayClose: 0, emailFrom: '', expectedRevenue: 0, id: 0, lostReasonId: CampaignId(id: 0, name: ''),
          mediumId: StructCombos(id: 0, name: ''), mobile: '', name: '', partnerId: PartnerId(id: 0, name: '', tradeName: '', cantonId: StructCombos(id: 0, name: ''), regionId: StructCombos(id: 0, name: ''), sectorId: StructCombos(id: 0, name: ''), channelId: StructCombos(id: 0, name: ''), cityId: StructCombos(id: 0, name: ''), clasificationId: StructCombos(id: 0, name: ''), email: ''),
          priority: '', sourceId: StructCombos(id: 0, name: ''), stageId: StructCombos(id: 0, name: ''),
          stateId: StructCombos(id: 0, name: ''), tagIds: [], title: CampaignId(id: 0, name: ''),
          type: '', city: '', contactName: '', dateClose: null, dateDeadline: null, dateOpen: null, description: '',
          emailCc: '', partnerName: '', phone: '', probability: 0, referred: '', street: '',
          userId: StructCombos(id: 0, name: '')
        ),
        objMailAct: objFinAct
      );

        return objRspFinal;
      }

      String modeloConsulta = EnvironmentsProd().modMailAct;
      String modeloConsultaMailMessage = EnvironmentsProd().modMailMessage;

      List<MultiModel> lstMultiModel = [];

      lstMultiModel.add(
        MultiModel(model: 'mail.activity')
      );

      if(resId != null && resId == 0){        
        var idMem = await storageProspecto.read(key: 'idMem') ?? '';

        if(idMem.isNotEmpty){
          resId = int.parse(idMem);
        }        
      }

      var models = [
      {
        "model": modeloConsulta,
        "filters": [            
          ["user_id", "=", objLogDecode['result']['uid']],
          ["res_model_id", "=", resModelId],
          if(resId != null && resId > 0)
          ["res_id", "=", resId]
        ]
      },
    ];

      var codImei = await storageProspecto.read(key: 'codImei') ?? '';

      var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      ConsultaMultiModelRequestModel objReq = ConsultaMultiModelRequestModel(
        jsonrpc: jsonRpc,
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

      String ruta = '';
      final objStr = await storageAct.read(key: 'RespuestaRegistro') ?? '';
      
      if(objStr.isNotEmpty)
      {  
        var obj = RegisterDeviceResponseModel.fromJson(objStr);
        ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/data/multi/models';
      }

      String tockenValidDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(objReq.params.tockenValidDate);

      final requestBody = {
        "jsonrpc": jsonRpc,
        "params": {
          "key": objReq.params.key,
          "tocken": objReq.params.tocken,
          "imei": objReq.params.imei,
          "uid": objReq.params.uid,
          "company": objReq.params.company,
          "bearer": objReq.params.bearer,
          "tocken_valid_date": tockenValidDate,
          "models": models
        }
      };

      final headers = {
        "Content-Type": EnvironmentsProd().contentType
      };

      final response = await http.post(
        Uri.parse(ruta),
        headers: headers,
        body: jsonEncode(requestBody), 
      );
      
      var rsp = AppResponseModel.fromRawJson(response.body);

      //print('Consulta agenda: ${response.body}');

      String cmbLstAct = json.encode(rsp.result.data.mailActivity);//await storageAct.read(key: 'cmbLstActividades') ?? '';

      ActivitiesResponseModel objActividades = ActivitiesResponseModel.fromRawJson(cmbLstAct);

      var lstProsp = await storageAct.read(key: 'RespuestaProspectos') ?? '';

      var objLogDecode2 = json.decode(lstProsp);      

      CrmLeadAppModel apiResponse = CrmLeadAppModel.fromJson(objLogDecode2);

      CrmLeadDatumAppModel? objFin;
      
      for(int i = 0; i < apiResponse.data.length; i++){
        if(apiResponse.data[i].id == resId){
          objFin = apiResponse.data[i];
        }
      }

      DatumCrmLead objDatumCrmLeadFin = DatumCrmLead(
        activityIds: [],
        campaignId: CampaignId(
          id: objFin?.campaignId.id ?? 0,
          name: objFin?.campaignId.name ?? ''
        ),
        countryId: StructCombos(
          id: objFin?.countryId.id ?? 0,
          name: objFin?.countryId.name ?? ''
        ),
        dayClose: 0,//objFin.dateClose,
        emailFrom: objFin?.emailFrom ?? '',
        expectedRevenue: objFin?.expectedRevenue ?? 0,
        id: objFin?.id ?? 0,
        lostReasonId: CampaignId(
          id: objFin?.lostReasonId.id ?? 0,
          name: objFin?.lostReasonId.name ?? ''
        ),
        mediumId: StructCombos(
          id: objFin?.mediumId.id ?? 0,
          name: objFin?.mediumId.name ?? ''
        ),
        name: objFin?.name ?? '',
        partnerId: PartnerId(
          tradeName: '',
          cantonId: StructCombos(id: 0, name: ''),
          regionId: StructCombos(id: 0, name: ''),
          sectorId: StructCombos(id: 0, name: ''),
          id: objFin?.partnerId.id ?? 0,
          name: objFin?.partnerId.name ?? '',
          channelId: StructCombos(id: 0, name: ''),
          cityId: StructCombos(id: 0, name: ''),
          clasificationId: StructCombos(id: 0, name: ''),
          email: ''
        ),
        priority: objFin?.priority ?? '',
        sourceId: StructCombos(
          id: objFin?.sourceId.id ?? 0,
          name: objFin?.sourceId.name ?? ''
        ),
        stageId: StructCombos(
          id: objFin?.stageId.id ?? 0,
          name: objFin?.stageId.name ?? ''
        ),
        stateId: StructCombos(
          id: objFin?.stateId.id ?? 0,
          name: objFin?.stateId.name ?? ''
        ),
        tagIds: objFin?.tagIds ?? [],
        title: CampaignId(
          id: objFin?.title.id ?? 0,
          name: objFin?.title.name ?? ''
        ),
        type: objFin?.type ?? '',
        //city: objFin!.cit
        contactName: objFin?.contactName,
        dateClose: objFin?.dateClose,
        dateDeadline: objFin?.dateDeadline,
        dateOpen: objFin?.dateOpen,
        description: objFin?.description,
        //emailCc: objFin!.em
        mobile: '',
        city: '',
        emailCc: '',
        partnerName: objFin?.partnerId.name ?? '',
        phone: objFin?.phone,
        probability: objFin?.probability,
        referred: objFin?.referred,
        street: objFin?.street,
        userId: StructCombos(
          id: objFin?.userId.id ?? 0,
          name: objFin?.userId.name ?? ''
        ),
      );

      var models2 = [
        {
          "model": modeloConsultaMailMessage,
          "filters": [            
            ["user_id", "=", objLogDecode['result']['uid']],          
          ]
        },
      ];

      
      final requestBody2 = {
        "jsonrpc": jsonRpc,
        "params": {
          "key": objReq.params.key,
          "tocken": objReq.params.tocken,
          "imei": objReq.params.imei,
          "uid": objReq.params.uid,
          "company": objReq.params.company,
          "bearer": objReq.params.bearer,
          "tocken_valid_date": tockenValidDate,
          "models": models2
        }
      };

      final response2 = await http.post(
        Uri.parse(ruta),
        headers: headers,
        body: jsonEncode(requestBody2), 
      );
      
      var rsp2 = AppResponseModel.fromRawJson(response2.body);

      final lstEncr = await storageAct.read(key: 'LstActividadesAbiertasCerradas') ?? '';

      String internet = await ValidacionesUtils().validaInternet();
    

      if(lstEncr.isNotEmpty && internet.isEmpty){
        ActivitiesResponseModel  objMem = ActivitiesResponseModel.fromRawJson(lstEncr);

        for(int i = 0; i < objMem.data.length; i++) {
          if(objMem.data[i].resId == resId){
            objActividades.data.add(objMem.data[i]);
          }
        }
      }
      
      ActivitiesPageModel objRspFinal = ActivitiesPageModel(
        activities: objActividades,
        lead: objDatumCrmLeadFin,
        objMailAct: objFinAct,
      );

      return objRspFinal;
    }
    catch(_){
     //print('Test: $ex');
    }
  }


  registroActividades(ActivitiesTypeRequestModel objActividad) async {
    String internet = await ValidacionesUtils().validaInternet();
    
    //VALIDACIÓN DE INTERNET
    if(internet.isEmpty){
      
      try{

        var objRspIrModel = await storageDataInicial.read(key: 'IdIrModelForAct') ?? '';        
        int resModelId = int.parse(objRspIrModel);

        var codImei = await storageProspecto.read(key: 'codImei') ?? '';

        var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
        var obj = RegisterDeviceResponseModel.fromJson(objReg);

        var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
        var objLogDecode = json.decode(objLog);

        //print('Test DatosLogin: $objLog');

        List<MultiModel> lstMultiModel = [];

        lstMultiModel.add(
          MultiModel(model: "mail.activity")
        );

        ConsultaMultiModelRequestModel objReq = ConsultaMultiModelRequestModel(
          jsonrpc: jsonRpc,
          params: ParamsMultiModels(
            bearer: obj.result.bearer,
            company: objLogDecode['result']['current_company'],
            imei: codImei,
            key: obj.result.key,
            tocken: obj.result.tocken,
            tockenValidDate: obj.result.tockenValidDate,
            uid: objLogDecode['result']['uid'],
            models: lstMultiModel
          )
        );

        String tockenValidDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(objReq.params.tockenValidDate);

        //int resModelId = objIrModel.data.firstWhere((x) => x.model == "crm.lead").id;

        final requestBody = {
          "jsonrpc": jsonRpc,
          "params": {
            "key": objReq.params.key,
            "tocken": objReq.params.tocken,
            "imei": objReq.params.imei,
            "uid": objReq.params.uid,
            "company": objReq.params.company,
            "bearer": objReq.params.bearer,
            "tocken_valid_date": tockenValidDate,
            "create": {
              "date_deadline": DateFormat('yyyy-MM-dd', 'es').format(objActividad.dateDeadline!),//date_deadline
              "activity_type_id": objActividad.activityTypeId,
              "res_model_id": resModelId,
              "res_id": objActividad.resId,
              "summary": objActividad.note,
              "note": objActividad.note,
              "lead_name": objActividad.leadName,
              "lead_phone": objActividad.leadPhone,
              "is_done_app": true,
              "user_id": objReq.params.uid,
              "lead_contact_name": objActividad.contactName
            },
          }
        };

        final headers = {
          "Content-Type": EnvironmentsProd().contentType
        };

        String ruta = '';
        final objStr = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
        
        if(objStr.isNotEmpty)
        {
          var obj = RegisterDeviceResponseModel.fromJson(objStr);
          ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/create/mail.activity/model';
        }

        final response = await http.post(
          Uri.parse(ruta),
          headers: headers,
          body: jsonEncode(requestBody), 
        );

        //print('respuesta: ${response.body}');
      
        var rspValidacion = json.decode(response.body);

        if(rspValidacion['result']['mensaje'] != null && (rspValidacion['result']['mensaje'].toString().toLowerCase().contains(MensajeValidacion().tockenNoValido) || rspValidacion['result']['mensaje'].toString().toLowerCase().contains(MensajeValidacion().tockenExpirado))){
          await tokenManager.checkTokenExpiration();
          await registroActividades(objActividad);
        }

        var objRespuestaFinal = ActividadRegistroResponseModel.fromRawJson(response.body);

/*
        var objRspPrsp = await storageProspecto.read(key: 'RegistraActividad') ?? '';

        ActividadRegistroResponseModel objLead = ActividadRegistroResponseModel(
          id: 0,
          jsonrpc: '',
          result: ResultActividad(
            data: [],
            estado: 0,
            mensaje: ''
          )
        );

        if(objRspPrsp.isNotEmpty){
          objLead = ActividadRegistroResponseModel.fromRawJson(objRspPrsp);

          objLead.result.data.length = objLead.result.data.length;
        }

        for(int i = 0; i < objLead.result.data.length; i++)
        {
          Datum objCrmLeadDatumAppModel = Datum(
            activityTypeId: objLead.result.data[i].activityTypeId,
            dateDeadline: objLead.result.data[i].dateDeadline,
            id: objLead.result.data[i].id,
            resId: objLead.result.data[i].resId,
            resModel: objLead.result.data[i].resModel,
            userId: objLead.result.data[i].userId
          );

          objRespuestaFinal.result.data.add(objCrmLeadDatumAppModel);

        }
        */

        //await storageProspecto.write(key: 'RegistraActividad', value: jsonEncode(objRespuestaFinal.toJson()));

        return objRespuestaFinal;
      } 
      catch(_){
        //print('Error al grabar: $ex');
      }
    } else {
      List<ActivitiesTypeRequestModel> lstAct = [];

      final tstAct = await storageProspecto.read(key: 'RegistraActividad') ?? '';

      if(tstAct.isNotEmpty){
        var varDecod = jsonDecode(tstAct);

        for(int i = 0; i < varDecod.length; i++){
          ActivitiesTypeRequestModel objGuardar = ActivitiesTypeRequestModel.fromJson(varDecod[i]);
          lstAct.add(objGuardar);
        }
        
      }

      lstAct.add(objActividad);
      
      await storageProspecto.write(key: 'RegistraActividad', value: jsonEncode(lstAct));

      return ActividadRegistroResponseModel(
        id: 0,
        jsonrpc: '',
        result: ResultActividad(
          data: [],
          estado: 0,
          mensaje: objMensajesAlertasAct.mensajeOffLine
        )
      );
    }

  }

  registroListadoActividades(List<Map<String, dynamic>> lstActividades) async {

    String internet = await ValidacionesUtils().validaInternet();
    
    //VALIDACIÓN DE INTERNET
    if(internet.isEmpty){
      
      try{

        var codImei = await storageProspecto.read(key: 'codImei') ?? '';

        var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
        var obj = RegisterDeviceResponseModel.fromJson(objReg);

        var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
        var objLogDecode = json.decode(objLog);

        //print('Test DatosLogin: $objLog');

        List<MultiModel> lstMultiModel = [];

        lstMultiModel.add(
          MultiModel(model: "mail.activity")
        );

        ConsultaMultiModelRequestModel objReq = ConsultaMultiModelRequestModel(
          jsonrpc: jsonRpc,
          params: ParamsMultiModels(
            bearer: obj.result.bearer,
            company: objLogDecode['result']['current_company'],
            imei: codImei,
            key: obj.result.key,
            tocken: obj.result.tocken,
            tockenValidDate: obj.result.tockenValidDate,
            uid: objLogDecode['result']['uid'],
            models: lstMultiModel
          )
        );

        String tockenValidDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(objReq.params.tockenValidDate);

        final requestBody = {
          "jsonrpc": jsonRpc,
          "params": {
            "key": objReq.params.key,
            "tocken": objReq.params.tocken,
            "imei": objReq.params.imei,
            "uid": objReq.params.uid,
            "company": objReq.params.company,
            "bearer": objReq.params.bearer,
            "tocken_valid_date": tockenValidDate,
            "create": lstActividades
          }
        };

        final headers = {
          "Content-Type": EnvironmentsProd().contentType
        };

        String ruta = '';
        final objStr = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
        
        if(objStr.isNotEmpty)
        {
          var obj = RegisterDeviceResponseModel.fromJson(objStr);
          ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/create/mail.activity/model';
        }

        final response = await http.post(
          Uri.parse(ruta),
          headers: headers,
          body: jsonEncode(requestBody), 
        );
      
        var rspValidacion = json.decode(response.body);

        if(rspValidacion['result']['mensaje'] != null && (rspValidacion['result']['mensaje'].toString().toLowerCase().contains(MensajeValidacion().tockenNoValido) || rspValidacion['result']['mensaje'].toString().toLowerCase().contains(MensajeValidacion().tockenExpirado))){
          await tokenManager.checkTokenExpiration();
          await registroListadoActividades(lstActividades);
        }

        var objRespuestaFinal = ActividadRegistroResponseModel.fromRawJson(response.body);

        return objRespuestaFinal;
      } 
      catch(_){
        //print('Error al grabar: $ex');
      }
    }
    
  }
  
  cierreActividadesXId(ActivitiesTypeRequestModel objActividad) async {
    String internet = await ValidacionesUtils().validaInternet();
    
    //VALIDACIÓN DE INTERNET
    if(internet.isEmpty){
      
      var objRspIrModel = await storageDataInicial.read(key: 'IdIrModelForAct') ?? '';
      int resModelId = int.parse(objRspIrModel);

      try{

        var codImei = await storageProspecto.read(key: 'codImei') ?? '';

        var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
        var obj = RegisterDeviceResponseModel.fromJson(objReg);

        var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
        var objLogDecode = json.decode(objLog);

        //print('Test DatosLogin: $objLog');

        List<MultiModel> lstMultiModel = [];

        lstMultiModel.add(
          MultiModel(model: "mail.activity")
        );

        ConsultaMultiModelRequestModel objReq = ConsultaMultiModelRequestModel(
          jsonrpc: jsonRpc,
          params: ParamsMultiModels(
            bearer: obj.result.bearer,
            company: objLogDecode['result']['current_company'],
            imei: codImei,
            key: obj.result.key,
            tocken: obj.result.tocken,
            tockenValidDate: obj.result.tockenValidDate,
            uid: objLogDecode['result']['uid'],
            models: lstMultiModel
          )
        );

        String tockenValidDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(objReq.params.tockenValidDate);

        final requestBody = {
          "jsonrpc": jsonRpc,
          "params": {
            "key": objReq.params.key,
            "tocken": objReq.params.tocken,
            "imei": objReq.params.imei,
            "uid": objReq.params.uid,
            "company": objReq.params.company,
            "bearer": objReq.params.bearer,
            "tocken_valid_date": tockenValidDate,
            "id": objActividad.actId,
            "write": {
              "res_model_id": resModelId,
              "user_id": objActividad.userId,
              "res_id": objActividad.resId,
              "note": objActividad.note,
              "working_time": objActividad.workingTime,
            },
          }
        };

        final headers = {
          "Content-Type": EnvironmentsProd().contentType
        };

        String ruta = '';
        final objStr = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
        
        if(objStr.isNotEmpty)
        {
          var obj = RegisterDeviceResponseModel.fromJson(objStr);
          ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/write/mail.activity/model';
        }

        final response = await http.post(
          Uri.parse(ruta),
          headers: headers,
          body: jsonEncode(requestBody), 
        );

        String rspMsm = '';
        int cod = 0;

        CierreActividadesResponseModel objCierre = CierreActividadesResponseModel.fromRawJson(response.body);

        if(objCierre.result.mensaje.toLowerCase().contains('record does not exist or has been deleted')){
          rspMsm = 'Actividad cerrada exitosamente';
          cod = 200;
        }

        ActividadRegistroResponseModel objRsp = ActividadRegistroResponseModel(
          id: 0,
          jsonrpc: '',
          result: ResultActividad(
            data: [],
            estado: cod,
            mensaje: rspMsm
          )
        );

        final lstEncr = await storageAct.read(key: 'LstActividadesAbiertasCerradas') ?? '';

        if(lstEncr.isNotEmpty){
          ActivitiesResponseModel  objMem = ActivitiesResponseModel.fromRawJson(lstEncr);

          objMem.data.add(
            DatumActivitiesResponse(
              activityTypeId: IdActivities (id: objMem.data.length, name: 'Test ${objMem.data.length}'),
              dateDeadline: DateTime.now(),
              id: objActividad.actId,
              resId: objActividad.resId,
              resModel: 'Test ${objMem.data.length}',
              summary: objActividad.summary,
              userId: IdActivities (id: objMem.data.length, name: 'Test ${objMem.data.length}'),
              cerrado: true,
              leadName: '',
              contactName: '',
              dateCreate: DateTime.now(),
              activityCategory: '',
              cell: '',
              mail: ''
            )
          );

          await storageAct.write(key: 'LstActividadesAbiertasCerradas', value: jsonEncode(objMem.toJson()));
        }
        else {

          ActivitiesResponseModel  objMem = ActivitiesResponseModel(            
            data: [
              DatumActivitiesResponse(
                activityTypeId: IdActivities (id: 1, name: 'Test 1'),
                dateDeadline: DateTime.now(),
                id: objActividad.actId,
                resId: objActividad.resId,
                resModel: 'Test 1',
                summary: objActividad.summary,
                userId: IdActivities (id: 1, name: 'Test 1'),
                cerrado: true,
                leadName: '',
                contactName: '',
                dateCreate: DateTime.now(),
                activityCategory: '',
                cell: '',
                mail: ''
              )
            ],
            length: 0,
            fields: FieldsActivities(code: '', name: '',stateIds: '')
          );

          await storageAct.write(key: 'LstActividadesAbiertasCerradas', value: jsonEncode(objMem.toJson()));
        }

        return objRsp;
      } 
      catch(_){
        //print('Error al grabar: $ex');
      }
    } else {
      await storageProspecto.write(key: 'RegistraActividad', value: jsonEncode(objActividad.toJson()));

      return ProspectoRegistroResponseModel(
        id: 0,
        jsonrpc: '',
        result: ProspectoRegistroModel(
          estado: 0, 
          mensaje: '', 
          data: []
        ),
        mensaje: objMensajesAlertasAct.mensajeOffLine
      );
    }

  }

  cierreActividadesXIdLista(List<ActivitiesTypeRequestModel> lstActividades) async {
    String internet = await ValidacionesUtils().validaInternet();
    
    //VALIDACIÓN DE INTERNET
    if(internet.isEmpty){
      
      var objRspIrModel = await storageDataInicial.read(key: 'IdIrModelForAct') ?? '';
      int resModelId = int.parse(objRspIrModel);

      try{

        var codImei = await storageProspecto.read(key: 'codImei') ?? '';

        var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
        var obj = RegisterDeviceResponseModel.fromJson(objReg);

        var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
        var objLogDecode = json.decode(objLog);

        //print('Test DatosLogin: $objLog');

        List<MultiModel> lstMultiModel = [];

        lstMultiModel.add(
          MultiModel(model: "mail.activity")
        );

        ConsultaMultiModelRequestModel objReq = ConsultaMultiModelRequestModel(
          jsonrpc: jsonRpc,
          params: ParamsMultiModels(
            bearer: obj.result.bearer,
            company: objLogDecode['result']['current_company'],
            imei: codImei,
            key: obj.result.key,
            tocken: obj.result.tocken,
            tockenValidDate: obj.result.tockenValidDate,
            uid: objLogDecode['result']['uid'],
            models: lstMultiModel
          )
        );

        String tockenValidDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(objReq.params.tockenValidDate);

        List<Map<String, dynamic>> writeList = [];

        for (int i = 0; i < lstActividades.length; i++) {
          writeList.add({
            "id": lstActividades[i].actId,
            "write": {
              "res_model_id": resModelId,
              "user_id": lstActividades[i].userId,
              "res_id": lstActividades[i].resId,
              "note": lstActividades[i].note,
              "working_time": lstActividades[i].workingTime,
            }
          });
        }

        final requestBody = {
          "jsonrpc": jsonRpc,
          "params": {
            "key": objReq.params.key,
            "tocken": objReq.params.tocken,
            "imei": objReq.params.imei,
            "uid": objReq.params.uid,
            "company": objReq.params.company,
            "bearer": objReq.params.bearer,
            "tocken_valid_date": tockenValidDate,
            "write_list": writeList,
          }
        };

        final headers = {
          "Content-Type": EnvironmentsProd().contentType
        };

        String ruta = '';
        final objStr = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
        
        if(objStr.isNotEmpty)
        {
          var obj = RegisterDeviceResponseModel.fromJson(objStr);
          ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/write/mail.activity/model';
        }

        final response = await http.post(
          Uri.parse(ruta),
          headers: headers,
          body: jsonEncode(requestBody), 
        );

        CierreActividadesResponseModel objCierre = CierreActividadesResponseModel.fromRawJson(response.body);

        ActividadRegistroResponseModel objRsp = ActividadRegistroResponseModel(
          id: 0,
          jsonrpc: '',
          result: ResultActividad(
            data: [],
            estado: objCierre.result.estado,//cod,
            mensaje: objCierre.result.mensaje //rspMsm
          )
        );

        final lstEncr = await storageAct.read(key: 'LstActividadesAbiertasCerradas') ?? '';

        if(lstEncr.isNotEmpty){
          ActivitiesResponseModel  objMem = ActivitiesResponseModel.fromRawJson(lstEncr);

          for(int i = 0; i < lstActividades.length; i++){
            objMem.data.add(
              DatumActivitiesResponse(
                activityTypeId: IdActivities (id: objMem.data.length, name: 'Test ${objMem.data.length}'),
                dateDeadline: DateTime.now(),
                id: lstActividades[i].actId,
                resId: lstActividades[i].resId,
                resModel: 'Test ${objMem.data.length}',
                summary: lstActividades[i].summary,
                userId: IdActivities (id: objMem.data.length, name: 'Test ${objMem.data.length}'),
                cerrado: true,
                leadName: '',
                contactName: '',
                dateCreate: DateTime.now(),
                activityCategory: '',
                cell: '',
                mail: ''
              )
            );
          }

          await storageAct.write(key: 'LstActividadesAbiertasCerradas', value: jsonEncode(objMem.toJson()));
        }
        else {

          for(int i = 0; i < lstActividades.length; i++){
            ActivitiesResponseModel  objMem = ActivitiesResponseModel(            
              data: [
                DatumActivitiesResponse(
                  activityTypeId: IdActivities (id: 1, name: 'Test 1'),
                  dateDeadline: DateTime.now(),
                  id: lstActividades[i].actId,
                  resId: lstActividades[i].resId,
                  resModel: 'Test 1',
                  summary: lstActividades[i].summary,
                  userId: IdActivities (id: 1, name: 'Test 1'),
                  cerrado: true,
                  leadName: '',
                  contactName: '',
                  dateCreate: DateTime.now(),
                  activityCategory: '',
                  cell: '',
                  mail: ''
                )
              ],
              length: 0,
              fields: FieldsActivities(code: '', name: '',stateIds: '')
            );

            await storageAct.write(key: 'LstActividadesAbiertasCerradas', value: jsonEncode(objMem.toJson()));
          }
        }

        return objRsp;
      } 
      catch(_){
        //print('Error al grabar: $ex');
      }
    } else {

      String jsonLista = jsonEncode(lstActividades.map((e) => e.toJson()).toList());

      await storageProspecto.write(key: 'RegistraActividad', value: jsonLista);

      return ProspectoRegistroResponseModel(
        id: 0,
        jsonrpc: '',
        result: ProspectoRegistroModel(
          estado: 0, 
          mensaje: '', 
          data: []
        ),
        mensaje: objMensajesAlertasAct.mensajeOffLine
      );
    }

  }

  String limpiarNumero(String numero) {
    if (numero.startsWith('0')) {
      return numero.substring(1);
    }
    return numero;
  }
}


import 'dart:convert';
import 'dart:io';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:intl/intl.dart';

const storageProspecto = FlutterSecureStorage();
MensajesAlertas objMensajesProspectoService = MensajesAlertas();
ResponseValidation objResponseValidationService = ResponseValidation();
final envPrsp = CadenaConexion();

class ProspectoTypeService extends ChangeNotifier{

  final String endPoint = CadenaConexion().apiEndpoint;

  final TokenManager tokenManager = TokenManager();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isValidForm(){
    return formKey.currentState?.validate() ?? false;
  }

  getProspectos() async {
    try{
      var codImei = await storageProspecto.read(key: 'codImei') ?? '';
      var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);
      var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

      List<MultiModel> lstMultiModel = [];

      lstMultiModel.add(
        MultiModel(model: 'crm.lead')
      );

      final models = [
        {
          "model": EnvironmentsProd().modCrmLead,//"crm.lead"
          "filters": [
            ['user_id', '=', objLogDecode['result']['uid']],
            '|',['active','=',false],['active','=',true]
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

      var objRsp = await GenericService().getMultiModelosGenNoMemoria(objReq, models);

      var rsp = AppResponseModel.fromRawJson(objRsp);

      //print('Lst Prsp 1: ${json.encode(rsp.result.data.crmLead)}');

      List<CrmLeadDatumAppModel> listaDescendente = List.of(rsp.result.data.crmLead.data)
      ..sort((a, b) => b.priority!.compareTo(a.priority!));

      rsp.result.data.crmLead.data = listaDescendente;

      await storageProspecto.write(key: 'RespuestaProspectos', value: '');
      await storageProspecto.write(key: 'RespuestaProspectos', value: json.encode(rsp.result.data.crmLead));

      return json.encode(objRsp);
      
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

  getProspecto(String tipoIdent,String numIdent) async {
    try{

      String tipoProspecto = await storageProspecto.read(key: 'tipoCliente') ?? '';
      final baseURL = '${endPoint}Prospectos/$tipoProspecto/$tipoIdent/$numIdent';

      final varResponse = await http.get(Uri.parse(baseURL));
      if(varResponse.statusCode != 200) return null;
      
      notifyListeners();
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

  Future<bool> llenaData(ProspectoType objPrpTp) async {
    bool frmValido = true;

    //String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    //RegExp regExp  = RegExp(pattern);

    if(objPrpTp.fechaNacimiento.trim() == '' || objPrpTp.genero.trim() == null || objPrpTp.genero.trim() == 'S' || objPrpTp.direccion.trim() == null || objPrpTp.direccion.trim() == '') {
      frmValido = false;
    }

    return frmValido;
  }

  getProspectoRegistrado(String phoneProsp, String codIsoPhone, String dialCodePhone) async {
    try{
      
      var codImei = await storageProspecto.read(key: 'codImei') ?? '';

      var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

      List<MultiModel> lstMultiModel = [];

      lstMultiModel.add(
        MultiModel(model: 'crm.lead')
      );

      
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

      String tockenValidDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(objReq.params.tockenValidDate);

      final headers = {
        "Content-Type": EnvironmentsProd().contentType//"application/json",
      };

      String ruta = '';
      final objStr = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
      
      if(objStr.isNotEmpty)
      {  
        var obj = RegisterDeviceResponseModel.fromJson(objStr);
        ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/crm/lead/status';
      }

      final requestBody = {
        "jsonrpc": EnvironmentsProd().jsonrpc,
        "params": {
          "key": objReq.params.key,
          "tocken": objReq.params.tocken,
          "imei": objReq.params.imei,
          "uid": objReq.params.uid,
          "company": objReq.params.company,
          "bearer": objReq.params.bearer,
          "tocken_valid_date": tockenValidDate,
          "phone": phoneProsp,
          "country_code": codIsoPhone,
          "dial_code": dialCodePhone
        }
      };

      final response = await http.post(
        Uri.parse(ruta),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      var rspValidacion = json.decode(response.body);

      if(rspValidacion['result']['mensaje'] != null && (rspValidacion['result']['mensaje'].toString().toLowerCase().contains(MensajeValidacion().tockenNoValido) || rspValidacion['result']['mensaje'].toString().toLowerCase().contains(MensajeValidacion().tockenExpirado))){
        await tokenManager.checkTokenExpiration();
        await getProspectoRegistrado(phoneProsp, codIsoPhone, dialCodePhone);
      }

      return response.body;
      
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

  registraProspecto(DatumCrmLead objProspecto) async {
    String internet = await ValidacionesUtils().validaInternet();
    
    //VALIDACIÓN DE INTERNET
    if(internet.isEmpty){
      
      try{

        var codImei = await storageProspecto.read(key: 'codImei') ?? '';

        var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
        var obj = RegisterDeviceResponseModel.fromJson(objReg);

        var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
        var objLogDecode = json.decode(objLog);

        List<MultiModel> lstMultiModel = [];

        lstMultiModel.add(
          MultiModel(model: 'crm.lead')
        );

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

        String tockenValidDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(objReq.params.tockenValidDate);

        final requestBody = {
          "jsonrpc": EnvironmentsProd().jsonrpc,
          "params": {
            "key": objReq.params.key,
            "tocken": objReq.params.tocken,
            "imei": objReq.params.imei,
            "uid": objReq.params.uid,
            "company": objReq.params.company,
            "bearer": objReq.params.bearer,
            "tocken_valid_date": tockenValidDate,
            "create": {
              "name": objProspecto.name,
              "phone": objProspecto.phone,          
              "contact_name": objProspecto.contactName,
              "partner_name": objProspecto.partnerName,
              "date_deadline": DateFormat('yyyy-MM-dd', 'es').format(objProspecto.dateDeadline!),
              "email_from": objProspecto.emailFrom,
              "street": objProspecto.street,
              "expected_revenue": objProspecto.expectedRevenue,
              "referred": objProspecto.referred,
              "description": objProspecto.description,
              "probability": objProspecto.probability,
              "campaign_id": objProspecto.campaignId!.id,
              "source_id": objProspecto.sourceId.id,
              "medium_id": objProspecto.mediumId.id,
              "country_id": objProspecto.countryId.id,
              "is_done_app": true
            }
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
          ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/create/crm.lead/model';
        }

        //print('Test: ${jsonEncode(requestBody)}');

        final response = await http.post(
          Uri.parse(ruta),
          headers: headers,
          body: jsonEncode(requestBody), 
        );
      
        var rspValidacion = json.decode(response.body);

        if(rspValidacion['result']['mensaje'] != null && (rspValidacion['result']['mensaje'].toString().toLowerCase().contains(MensajeValidacion().tockenNoValido) || rspValidacion['result']['mensaje'].toString().toLowerCase().contains(MensajeValidacion().tockenExpirado))){
          await tokenManager.checkTokenExpiration();
          await registraProspecto(objProspecto);
        } 

        var objRspPrsp = await storageProspecto.read(key: 'RespuestaProspectos') ?? '';

        CrmLeadAppModel objLead = CrmLeadAppModel(
          data: [],
          fields: CrmLeadFieldsAppModel(
            activityIds: '',
            campaignId: '',
            city: '',
            contactName: '',
            countryId: '',
            dateClosed: '',
            dateDeadline: '',
            dateOpen: '',
            dayClose: '',
            description: '',
            emailCc: '',
            emailFrom: '',
            expectedRevenue: '',
            function: '',
            lostReasonId: '',
            mediumId: '',
            mobile: '',
            name: '',
            partnerId: '',
            partnerName: '',
            phone: '',
            priority: '',
            referred: '',
            sourceId: '',
            stageId: '',
            stateId: '',
            street: '',
            tagIds: '',
            title: '',
            type: '',
            userId: ''
          ),
          length: 0
        );        

        if(objRspPrsp.isNotEmpty){
          objLead = CrmLeadAppModel.fromRawJson(objRspPrsp);

          objLead.length = objLead.data.length + 1;
        }

        var objRespuestaFinal = ProspectoRegistroResponseModel.fromRawJson(response.body);

        for(int i = 0; i < objRespuestaFinal.result.data.length; i++)
        {
          List<CombosAppModel> lstActivTmp = [];
          List<CombosAppModel> lstTagsTmp = [];
          CombosAppModel objCampaTmp = CombosAppModel (id: objRespuestaFinal.result.data[i].campaignId?.id ?? 0, name: objRespuestaFinal.result.data[i].campaignId?.name ?? '');
          CombosAppModel objPaisTmp = CombosAppModel (id: objRespuestaFinal.result.data[i].countryId?.id ?? 0, name: objRespuestaFinal.result.data[i].countryId?.name ?? '');
          CombosAppModel objReasonTmp = CombosAppModel(id: objRespuestaFinal.result.data[i].lostReasonId?.id ?? 0, name: objRespuestaFinal.result.data[i].lostReasonId?.name ?? '');
          CombosAppModel objMediumTmp = CombosAppModel(id: objRespuestaFinal.result.data[i].mediumId?.id ?? 0, name: objRespuestaFinal.result.data[i].mediumId?.name ?? '');
          CombosAppModel objPartnerTmp = CombosAppModel(id: objRespuestaFinal.result.data[i].partnerId?.id ?? 0, name: objRespuestaFinal.result.data[i].partnerId?.name ?? '');
          CombosAppModel objSourceTmp = CombosAppModel(id: objRespuestaFinal.result.data[i].sourceId?.id ?? 0, name: objRespuestaFinal.result.data[i].sourceId?.name ?? '');
          StageIdApp objStageTmp = StageIdApp(id: objRespuestaFinal.result.data[i].stageId?.id ?? 0, name: objRespuestaFinal.result.data[i].stageId?.name ?? '', isWon: false);
          CombosAppModel objStateTmp = CombosAppModel(id: objRespuestaFinal.result.data[i].stateId?.id ?? 0, name: objRespuestaFinal.result.data[i].stateId?.name ?? '');
          CombosAppModel objTittleTmp = CombosAppModel(id: objRespuestaFinal.result.data[i].title?.id ?? 0, name: objRespuestaFinal.result.data[i].title?.name ?? '');
          CombosAppModel objUserTmp = CombosAppModel(id: objRespuestaFinal.result.data[i].userId?.id ?? 0, name: objRespuestaFinal.result.data[i].userId?.name ?? '');

          for(int i = 0; i < objProspecto.activityIds.length; i++){
            lstActivTmp.add(
              CombosAppModel(id: objProspecto.activityIds[i].id, name: objProspecto.activityIds[i].name)
            );
          }

          for(int i = 0; i < objProspecto.tagIds.length; i++){
            lstTagsTmp.add(
              CombosAppModel(id: objProspecto.activityIds[i].id, name: objProspecto.activityIds[i].name)
            );
          }

          CrmLeadDatumAppModel objCrmLeadDatumAppModel = CrmLeadDatumAppModel(
            dateDeadline:  DateTime.now(),
            dateClose: DateTime.now(),
            probability: objProspecto.probability ?? 0,
            street: objProspecto.street,
            referred: objProspecto.referred,
            activityIds: lstActivTmp,
            campaignId: objCampaTmp,
            contactName: objProspecto.contactName,
            countryId: objPaisTmp,
            dateOpen: objProspecto.dateOpen ?? DateTime.now(),
            dayClose: objProspecto.dayClose,
            emailFrom: objProspecto.emailFrom,
            expectedRevenue: objProspecto.expectedRevenue,
            id: objRespuestaFinal.result.data[i].id,
            lostReasonId: objReasonTmp,
            mediumId: objMediumTmp,
            name: objProspecto.name,
            partnerId: objPartnerTmp,
            phone: objProspecto.phone,
            priority: objProspecto.priority,
            sourceId: objSourceTmp,
            stageId: objStageTmp,
            stateId: objStateTmp,
            type: objProspecto.type,
            title: objTittleTmp,
            userId: objUserTmp,
            tagIds: lstTagsTmp,
            description: objProspecto.description,
            active: true
          );

          objLead.data.add(objCrmLeadDatumAppModel);

        }

        List<CrmLeadDatumAppModel> listaDescendente = List.of(objLead.data)
        ..sort((a, b) => b.priority!.compareTo(a.priority!));

        objLead.data = listaDescendente;

        await storageProspecto.write(key: 'RespuestaProspectos', value: '');
        await storageProspecto.write(key: 'RespuestaProspectos', value: json.encode(objLead));

        return objRespuestaFinal;
      } 
      catch(_){
        //print('Error al grabar: $ex');
      }
    } else {
      //await storageProspecto.write(key: 'registraProspecto', value: jsonEncode(objProspecto.toJson()));
      //await storageProspecto.write(key: 'TienePendienteRegistros', value: 'S');

      return ProspectoRegistroResponseModel(
        id: -1,
        jsonrpc: '',
        result: ProspectoRegistroModel(
          estado: 0, 
          mensaje: '', 
          data: []
        ),
        mensaje: objMensajesProspectoService.mensajeOffLineGenerico
      );
    }

  }

  editaProspecto(DatumCrmLead objProspecto) async {
    String internet = await ValidacionesUtils().validaInternet();
    
    //VALIDACIÓN DE INTERNET
    if(internet.isEmpty){
      
      try{

        var codImei = await storageProspecto.read(key: 'codImei') ?? '';

        var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
        var obj = RegisterDeviceResponseModel.fromJson(objReg);

        var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
        var objLogDecode = json.decode(objLog);

        List<MultiModel> lstMultiModel = [];

        lstMultiModel.add(
          MultiModel(model: 'crm.lead')
        );

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

        String tockenValidDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(objReq.params.tockenValidDate);

        //print('Fecha token: $tockenValidDate');

        final requestBody = {
          "jsonrpc": EnvironmentsProd().jsonrpc,
          "params": {
            "key": objReq.params.key,
            "tocken": objReq.params.tocken,
            "imei": objReq.params.imei,
            "uid": objReq.params.uid,
            "company": objReq.params.company,
            "bearer": objReq.params.bearer,
            "tocken_valid_date": tockenValidDate,
            "id": objProspecto.id,
            "write": {
              "name": objProspecto.name,
              "phone": objProspecto.phone,          
              "contact_name": objProspecto.contactName,
              "partner_name": objProspecto.partnerName,
              "date_deadline": DateFormat('yyyy-MM-dd', 'es').format(objProspecto.dateDeadline!),//date_deadline
              "email_from": objProspecto.emailFrom,
              "street": objProspecto.street,
              "expected_revenue": objProspecto.expectedRevenue,
              "referred": objProspecto.referred,
              "description": objProspecto.description,
              "probability": objProspecto.probability,
              "campaign_id": objProspecto.campaignId!.id == 0 ? null : objProspecto.campaignId!.id,
              "source_id": objProspecto.sourceId.id == 0 ? null : objProspecto.sourceId.id,
              "medium_id": objProspecto.mediumId.id == 0 ? null : objProspecto.mediumId.id,
              "country_id": objProspecto.countryId.id == 0 ? null : objProspecto.countryId.id
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
          ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/write/crm.lead/model';
        }

        //print('Test: ${jsonEncode(requestBody)}');

        final response = await http.post(
          Uri.parse(ruta),
          headers: headers,
          body: jsonEncode(requestBody), 
        );
      
        var rspValidacion = json.decode(response.body);

        String msmRsp = '';

        if(rspValidacion['result']['mensaje'] != null){
          msmRsp = rspValidacion['result']['mensaje'];
        }

        if(msmRsp.isNotEmpty && (msmRsp.toLowerCase().contains(MensajeValidacion().tockenNoValido) || msmRsp.toLowerCase().contains(MensajeValidacion().tockenExpirado))){
          await tokenManager.checkTokenExpiration();
          await editaProspecto(objProspecto);
        } 

        var objRspPrsp = await storageProspecto.read(key: 'RespuestaProspectos') ?? '';

        CrmLeadAppModel objLeadEdit = CrmLeadAppModel(
          data: [],
          fields: CrmLeadFieldsAppModel(
            activityIds: '',
            campaignId: '',
            city: '',
            contactName: '',
            countryId: '',
            dateClosed: '',
            dateDeadline: '',
            dateOpen: '',
            dayClose: '',
            description: '',
            emailCc: '',
            emailFrom: '',
            expectedRevenue: '',
            function: '',
            lostReasonId: '',
            mediumId: '',
            mobile: '',
            name: '',
            partnerId: '',
            partnerName: '',
            phone: '',
            priority: '',
            referred: '',
            sourceId: '',
            stageId: '',
            stateId: '',
            street: '',
            tagIds: '',
            title: '',
            type: '',
            userId: ''
          ),
          length: 0
        );        

        CrmLeadAppModel objLeadEditMemoria = CrmLeadAppModel(
          data: [],
          fields: CrmLeadFieldsAppModel(
            activityIds: '',
            campaignId: '',
            city: '',
            contactName: '',
            countryId: '',
            dateClosed: '',
            dateDeadline: '',
            dateOpen: '',
            dayClose: '',
            description: '',
            emailCc: '',
            emailFrom: '',
            expectedRevenue: '',
            function: '',
            lostReasonId: '',
            mediumId: '',
            mobile: '',
            name: '',
            partnerId: '',
            partnerName: '',
            phone: '',
            priority: '',
            referred: '',
            sourceId: '',
            stageId: '',
            stateId: '',
            street: '',
            tagIds: '',
            title: '',
            type: '',
            userId: ''
          ),
          length: 0
        );

        if(objRspPrsp.isNotEmpty){
          objLeadEdit = CrmLeadAppModel.fromRawJson(objRspPrsp);

          objLeadEdit.length = objLeadEdit.data.length + 1;
          objLeadEditMemoria.length = objLeadEdit.data.length;
        }

        var objRespuestaFinal = ProspectoRegistroResponseModel.fromRawJson(response.body);

        for(int i = 0; i < objLeadEdit.data.length; i++)
        {
          if(objLeadEdit.data[i].id == objProspecto.id){
            List<CombosAppModel> lstActivTmp = [];
            List<CombosAppModel> lstTagsTmp = [];
            CombosAppModel objCampaTmp = CombosAppModel (id: objProspecto.campaignId?.id ?? 0, name: objProspecto.campaignId?.name ?? '');
            CombosAppModel objPaisTmp = CombosAppModel (id: objProspecto.countryId.id, name: objProspecto.countryId.name);
            CombosAppModel objReasonTmp = CombosAppModel(id: objProspecto.lostReasonId.id, name: objProspecto.lostReasonId.name);
            CombosAppModel objMediumTmp = CombosAppModel(id: objProspecto.mediumId.id, name: objProspecto.mediumId.name);
            CombosAppModel objPartnerTmp = CombosAppModel(id: objProspecto.partnerId.id, name: objProspecto.partnerId.name);
            CombosAppModel objSourceTmp = CombosAppModel(id: objProspecto.sourceId.id, name: objProspecto.sourceId.name);
            StageIdApp objStageTmp = StageIdApp(id: objProspecto.stageId.id, name: objProspecto.stageId.name, isWon: objProspecto.stageId.isWon);
            CombosAppModel objStateTmp = CombosAppModel(id: objProspecto.stateId.id, name: objProspecto.stateId.name);
            CombosAppModel objTittleTmp = CombosAppModel(id: objProspecto.title.id, name: objProspecto.title.name);
            CombosAppModel objUserTmp = CombosAppModel(id: objProspecto.userId?.id ?? 0, name: objProspecto.userId?.name ?? '');

            for(int j = 0; j < objProspecto.activityIds.length; j++){
              lstActivTmp.add(
                CombosAppModel(id: objProspecto.activityIds[j].id, name: objProspecto.activityIds[j].name)
              );
            }

            for(int j = 0; j < objProspecto.tagIds.length; j++){
              lstTagsTmp.add(
                CombosAppModel(id: objProspecto.activityIds[j].id, name: objProspecto.activityIds[j].name)
              );
            }
            
            CrmLeadDatumAppModel objCrmLeadDatumAppModel = CrmLeadDatumAppModel(
              dateDeadline:  DateTime.now(),
              dateClose: DateTime.now(),
              probability: objProspecto.probability ?? 0,
              street: objProspecto.street,
              referred: objProspecto.referred,
              activityIds: lstActivTmp,
              campaignId: objCampaTmp,
              contactName: objProspecto.contactName,
              countryId: objPaisTmp,
              dateOpen: objProspecto.dateOpen ?? DateTime.now(),
              dayClose: objProspecto.dayClose,
              emailFrom: objProspecto.emailFrom,
              expectedRevenue: objProspecto.expectedRevenue,
              id: objProspecto.id,
              lostReasonId: objReasonTmp,
              mediumId: objMediumTmp,
              name: objProspecto.name,
              partnerId: objPartnerTmp,
              phone: objProspecto.phone,
              priority: objProspecto.priority,
              sourceId: objSourceTmp,
              stageId: objStageTmp,
              stateId: objStateTmp,
              type: objProspecto.type,
              title: objTittleTmp,
              userId: objUserTmp,
              tagIds: lstTagsTmp,
              description: objProspecto.description,
              active: objProspecto.active
            );

            objLeadEditMemoria.data.add(objCrmLeadDatumAppModel);
          }
          else{
            List<CombosAppModel> lstActivTmp = [];
            List<CombosAppModel> lstTagsTmp = [];
            CombosAppModel objCampaTmp = CombosAppModel (id: objLeadEdit.data[i].campaignId.id, name: objLeadEdit.data[i].campaignId.name ?? '');
            CombosAppModel objPaisTmp = CombosAppModel (id: objLeadEdit.data[i].countryId.id, name: objLeadEdit.data[i].countryId.name);
            CombosAppModel objReasonTmp = CombosAppModel(id: objLeadEdit.data[i].lostReasonId.id, name: objLeadEdit.data[i].lostReasonId.name);
            CombosAppModel objMediumTmp = CombosAppModel(id: objLeadEdit.data[i].mediumId.id, name: objLeadEdit.data[i].mediumId.name);
            CombosAppModel objPartnerTmp = CombosAppModel(id: objLeadEdit.data[i].partnerId.id, name: objLeadEdit.data[i].partnerId.name);
            CombosAppModel objSourceTmp = CombosAppModel(id: objLeadEdit.data[i].sourceId.id, name: objLeadEdit.data[i].sourceId.name);
            StageIdApp objStageTmp = StageIdApp (id: objLeadEdit.data[i].stageId.id, name: objLeadEdit.data[i].stageId.name, isWon: objLeadEdit.data[i].stageId.isWon);
            CombosAppModel objStateTmp = CombosAppModel(id: objLeadEdit.data[i].stateId.id, name: objLeadEdit.data[i].stateId.name);
            CombosAppModel objTittleTmp = CombosAppModel(id: objLeadEdit.data[i].title.id, name: objLeadEdit.data[i].title.name);
            CombosAppModel objUserTmp = CombosAppModel(id: objLeadEdit.data[i].userId.id ?? 0, name: objLeadEdit.data[i].userId.name ?? '');

            for(int j = 0; j < objLeadEdit.data[i].activityIds.length; j++){
              lstActivTmp.add(
                CombosAppModel(id: objLeadEdit.data[i].activityIds[j].id, name: objLeadEdit.data[i].activityIds[j].name)
              );
            }

            for(int j = 0; j < objLeadEdit.data[i].tagIds.length; j++){
              lstTagsTmp.add(
                CombosAppModel(id: objLeadEdit.data[i].activityIds[j].id, name: objLeadEdit.data[i].activityIds[j].name)
              );
            }

            CrmLeadDatumAppModel objCrmLeadDatumAppModel = CrmLeadDatumAppModel(
              dateDeadline:  DateTime.now(),
              dateClose: DateTime.now(),
              probability: objLeadEdit.data[i].probability ?? 0,
              street: objLeadEdit.data[i].street,
              referred: objLeadEdit.data[i].referred,
              activityIds: lstActivTmp,
              campaignId: objCampaTmp,
              contactName: objLeadEdit.data[i].contactName,
              countryId: objPaisTmp,
              dateOpen: objLeadEdit.data[i].dateOpen,
              dayClose: objLeadEdit.data[i].dayClose,
              emailFrom: objLeadEdit.data[i].emailFrom,
              expectedRevenue: objLeadEdit.data[i].expectedRevenue,
              id: objLeadEdit.data[i].id,
              lostReasonId: objReasonTmp,
              mediumId: objMediumTmp,
              name: objLeadEdit.data[i].name,
              partnerId: objPartnerTmp,
              phone: objLeadEdit.data[i].phone,
              priority: objLeadEdit.data[i].priority,
              sourceId: objSourceTmp,
              stageId: objStageTmp,
              stateId: objStateTmp,
              type: objLeadEdit.data[i].type,
              title: objTittleTmp,
              userId: objUserTmp,
              tagIds: lstTagsTmp,
              description: objLeadEdit.data[i].description,
              active: objLeadEdit.data[i].active
            );

            objLeadEditMemoria.data.add(objCrmLeadDatumAppModel);
          }
        }

        List<CrmLeadDatumAppModel> listaDescendente = List.of(objLeadEditMemoria.data)
        ..sort((a, b) => b.priority!.compareTo(a.priority!));

        objLeadEditMemoria.data = listaDescendente;
        
        await storageProspecto.write(key: 'RespuestaProspectos', value: '');
        await storageProspecto.write(key: 'RespuestaProspectos', value: json.encode(objLeadEditMemoria));

        return objRespuestaFinal;
      } 
      catch(ex){
        //ERROR al editar prospecto es de mapeo en línea 659
        print('Error al grabar: $ex');
      }
    } else {
      await storageProspecto.write(key: 'registraProspecto', value: jsonEncode(objProspecto.toJson()));
      //await storageProspecto.write(key: 'TienePendienteRegistros', value: 'S');

      return ProspectoRegistroResponseModel(
        id: 0,
        jsonrpc: '',
        result: ProspectoRegistroModel(
          estado: 0, 
          mensaje: '', 
          data: []
        ),
        mensaje: objMensajesProspectoService.mensajeOffLine
      );
    }

  }

  Future<String> lstProspectosMemoria() async {
    var rsp = await storageProspecto.read(key: 'RespuestaProspectos') ?? '';
    
    return rsp;
  }

  getMotivoPerdidaProspecto() async {

    var codImei = await storageProspecto.read(key: 'codImei') ?? '';
    var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
    var obj = RegisterDeviceResponseModel.fromJson(objReg);
    var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
    var objLogDecode = json.decode(objLog);
    
    final models = [
      {
        "model": EnvironmentsProd().modCrmLostReason,
        "filters": []
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
        models: []
      )
    );

    var rsp = await GenericService().getMultiModelosGenNoMemoria(objReq, models);

    final jsonData = jsonDecode(rsp);
    final crmLostReasonJson = jsonData['result']['data'][EnvironmentsProd().modCrmLostReason];//'crm.lost.reason'];

    await storageProspecto.write(key: 'cmbLstMotivoPerdidaProspecto', value: '');
    
    var objFinal = CrmLostReasonResponse.fromJson(crmLostReasonJson);
    
    await storageProspecto.write(key: 'cmbLstMotivoPerdidaProspecto', value: json.encode(objFinal));

    return objFinal;

  }

  getMotivoPerdidaProspectoMemoria() async {
    var cmbAct = await storageProspecto.read(key: 'cmbLstMotivoPerdidaProspecto') ?? '';

    if(cmbAct.isNotEmpty){
      CrmLostReasonResponse  objFinAct = CrmLostReasonResponse.fromRawJson(cmbAct);

      return objFinAct;
    }
  }

  editaEstadoProspecto(bool estado, bool esGanado, int? motivoPerdida, int idProsp) async {
    String internet = await ValidacionesUtils().validaInternet();
    
    //VALIDACIÓN DE INTERNET
    if(internet.isEmpty){
      
      try{

        var codImei = await storageProspecto.read(key: 'codImei') ?? '';

        var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
        var obj = RegisterDeviceResponseModel.fromJson(objReg);

        var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
        var objLogDecode = json.decode(objLog);

        List<MultiModel> lstMultiModel = [];

        lstMultiModel.add(
          MultiModel(model: 'crm.lead')
        );

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

        String estadoFinal = '';

        String tockenValidDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(objReq.params.tockenValidDate);

        final requestBody = {
          "jsonrpc": EnvironmentsProd().jsonrpc,
          "params": {
            "key": objReq.params.key,
            "tocken": objReq.params.tocken,
            "imei": objReq.params.imei,
            "uid": objReq.params.uid,
            "company": objReq.params.company,
            "bearer": objReq.params.bearer,
            "tocken_valid_date": tockenValidDate,
            "id": idProsp,
            /*
            "write": {
              "active": estado,
              "lost_reason": motivoPerdida,
              "is_lead_lost": true
            },
            */
            //PROSPECTO PERDIDO
            if(!estado)
            "write": {
              "active": estado,
              "lost_reason": motivoPerdida,
              "is_lead_lost": true,
              "is_lead_won": false,
              "is_lead_restored": false
            },

            //PROSPECTO PERDIDO A NUEVO
            if(estado)
            "write": {
              "is_lead_lost": false,
              "is_lead_won": false,
              "is_lead_restored": true
            },

            //PROSPECTO GANADO
            if(esGanado && !estado)
            "write": {
              "is_lead_lost": false,
              "is_lead_won": true,
              "is_lead_restored": false
            }
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
          ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/write/crm.lead/model';
        }

        //print('Test: ${jsonEncode(requestBody)}');

        final response = await http.post(
          Uri.parse(ruta),
          headers: headers,
          body: jsonEncode(requestBody), 
        );
      
        var rspValidacion = json.decode(response.body);

        if(rspValidacion['result']['mensaje'] != null && (rspValidacion['result']['mensaje'].toString().toLowerCase().contains(MensajeValidacion().tockenNoValido) || rspValidacion['result']['mensaje'].toString().toLowerCase().contains(MensajeValidacion().tockenExpirado))){
          await tokenManager.checkTokenExpiration();
          await editaEstadoProspecto( estado, esGanado, motivoPerdida, idProsp);
        }

        //PROSPECTO PERDIDO
        if(!estado){
          estadoFinal = 'perdido';
        }
        
        //PROSPECTO NUEVO
        if(estado){
          estadoFinal = 'nuevo';
        }

        //PROSPECTO GANADO
        if(esGanado && !estado){
          estadoFinal = 'ganado';
        }

        return ResponseGenericModel.fromRawJson(response.body);

      } 
      catch(_){
        //print('Error al grabar: $ex');
      }
    } else {

      return ProspectoRegistroResponseModel(
        id: -1,
        jsonrpc: '',
        result: ProspectoRegistroModel(
          estado: 0, 
          mensaje: '', 
          data: []
        ),
        mensaje: objMensajesProspectoService.mensajeOffLineGenerico
      );
    }

  }

  editaPrioridadProspecto(int calificacion, int idProsp) async {
    String internet = await ValidacionesUtils().validaInternet();
    
    //VALIDACIÓN DE INTERNET
    if(internet.isEmpty){
      
      try{

        var codImei = await storageProspecto.read(key: 'codImei') ?? '';

        var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
        var obj = RegisterDeviceResponseModel.fromJson(objReg);

        var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
        var objLogDecode = json.decode(objLog);

        List<MultiModel> lstMultiModel = [];

        lstMultiModel.add(
          MultiModel(model: 'crm.lead')
        );

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

        String tockenValidDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(objReq.params.tockenValidDate);

        final requestBody = {
          "jsonrpc": EnvironmentsProd().jsonrpc,
          "params": {
            "key": objReq.params.key,
            "tocken": objReq.params.tocken,
            "imei": objReq.params.imei,
            "uid": objReq.params.uid,
            "company": objReq.params.company,
            "bearer": objReq.params.bearer,
            "tocken_valid_date": tockenValidDate,
            "id": idProsp,
            "write": {
              "priority": '$calificacion'
            }
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
          ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/write/crm.lead/model';
        }

        //print('Test: ${jsonEncode(requestBody)}');

        final response = await http.post(
          Uri.parse(ruta),
          headers: headers,
          body: jsonEncode(requestBody), 
        );
      
        var rspValidacion = json.decode(response.body);

        if(rspValidacion['result']['mensaje'] != null && (rspValidacion['result']['mensaje'].toString().toLowerCase().contains(MensajeValidacion().tockenNoValido) || rspValidacion['result']['mensaje'].toString().toLowerCase().contains(MensajeValidacion().tockenExpirado))){
          await tokenManager.checkTokenExpiration();
          await editaPrioridadProspecto( calificacion, idProsp);
        }
/*
        var objRspPrsp = await storageProspecto.read(key: 'RespuestaProspectos') ?? '';

        CrmLeadAppModel objLeadEdit = CrmLeadAppModel(
          data: [],
          fields: CrmLeadFieldsAppModel(
            activityIds: '',
            campaignId: '',
            city: '',
            contactName: '',
            countryId: '',
            dateClosed: '',
            dateDeadline: '',
            dateOpen: '',
            dayClose: '',
            description: '',
            emailCc: '',
            emailFrom: '',
            expectedRevenue: '',
            function: '',
            lostReasonId: '',
            mediumId: '',
            mobile: '',
            name: '',
            partnerId: '',
            partnerName: '',
            phone: '',
            priority: '',
            referred: '',
            sourceId: '',
            stageId: '',
            stateId: '',
            street: '',
            tagIds: '',
            title: '',
            type: '',
            userId: ''
          ),
          length: 0
        );        

        CrmLeadAppModel objLeadEditMemoria = CrmLeadAppModel(
          data: [],
          fields: CrmLeadFieldsAppModel(
            activityIds: '',
            campaignId: '',
            city: '',
            contactName: '',
            countryId: '',
            dateClosed: '',
            dateDeadline: '',
            dateOpen: '',
            dayClose: '',
            description: '',
            emailCc: '',
            emailFrom: '',
            expectedRevenue: '',
            function: '',
            lostReasonId: '',
            mediumId: '',
            mobile: '',
            name: '',
            partnerId: '',
            partnerName: '',
            phone: '',
            priority: '',
            referred: '',
            sourceId: '',
            stageId: '',
            stateId: '',
            street: '',
            tagIds: '',
            title: '',
            type: '',
            userId: ''
          ),
          length: 0
        );

        if(objRspPrsp.isNotEmpty){
          objLeadEdit = CrmLeadAppModel.fromRawJson(objRspPrsp);

          objLeadEdit.length = objLeadEdit.data.length + 1;
          objLeadEditMemoria.length = objLeadEdit.data.length;
        }

        for(int i = 0; i < objLeadEdit.data.length; i++)
        {
          if(objLeadEdit.data[i].id == idProsp){
            List<CombosAppModel> lstActivTmp = [];
            List<CombosAppModel> lstTagsTmp = [];
            CombosAppModel objCampaTmp = CombosAppModel (id: objProspecto.campaignId?.id ?? 0, name: objProspecto.campaignId?.name ?? '');
            CombosAppModel objPaisTmp = CombosAppModel (id: objProspecto.countryId.id, name: objProspecto.countryId.name);
            CombosAppModel objReasonTmp = CombosAppModel(id: objProspecto.lostReasonId.id, name: objProspecto.lostReasonId.name);
            CombosAppModel objMediumTmp = CombosAppModel(id: objProspecto.mediumId.id, name: objProspecto.mediumId.name);
            CombosAppModel objPartnerTmp = CombosAppModel(id: objProspecto.partnerId.id, name: objProspecto.partnerId.name);
            CombosAppModel objSourceTmp = CombosAppModel(id: objProspecto.sourceId.id, name: objProspecto.sourceId.name);
            CombosAppModel objStageTmp = CombosAppModel(id: objProspecto.stageId.id, name: objProspecto.stageId.name);
            CombosAppModel objStateTmp = CombosAppModel(id: objProspecto.stateId.id, name: objProspecto.stateId.name);
            CombosAppModel objTittleTmp = CombosAppModel(id: objProspecto.title.id, name: objProspecto.title.name);
            CombosAppModel objUserTmp = CombosAppModel(id: objProspecto.userId?.id ?? 0, name: objProspecto.userId?.name ?? '');

            for(int j = 0; j < objProspecto.activityIds.length; j++){
              lstActivTmp.add(
                CombosAppModel(id: objProspecto.activityIds[j].id, name: objProspecto.activityIds[j].name)
              );
            }

            for(int j = 0; j < objProspecto.tagIds.length; j++){
              lstTagsTmp.add(
                CombosAppModel(id: objProspecto.activityIds[j].id, name: objProspecto.activityIds[j].name)
              );
            }
            
            CrmLeadDatumAppModel objCrmLeadDatumAppModel = CrmLeadDatumAppModel(
              dateDeadline:  DateTime.now(),
              dateClose: DateTime.now(),
              probability: objProspecto.probability ?? 0,
              street: objProspecto.street,
              referred: objProspecto.referred,
              activityIds: lstActivTmp,
              campaignId: objCampaTmp,
              contactName: objProspecto.contactName,
              countryId: objPaisTmp,
              dateOpen: objProspecto.dateOpen ?? DateTime.now(),
              dayClose: objProspecto.dayClose,
              emailFrom: objProspecto.emailFrom,
              expectedRevenue: objProspecto.expectedRevenue,
              id: objProspecto.id,
              lostReasonId: objReasonTmp,
              mediumId: objMediumTmp,
              name: objProspecto.name,
              partnerId: objPartnerTmp,
              phone: objProspecto.phone,
              priority: objProspecto.priority,
              sourceId: objSourceTmp,
              stageId: objStageTmp,
              stateId: objStateTmp,
              type: objProspecto.type,
              title: objTittleTmp,
              userId: objUserTmp,
              tagIds: lstTagsTmp,
              description: objProspecto.description,
              active: objProspecto.active,
              
            );

            objLeadEditMemoria.data.add(objCrmLeadDatumAppModel);
          }
          
        }

        List<CrmLeadDatumAppModel> listaDescendente = List.of(objLeadEditMemoria.data)
        ..sort((a, b) => b.priority!.compareTo(a.priority!));

        objLeadEditMemoria.data = listaDescendente;
        
        await storageProspecto.write(key: 'RespuestaProspectos', value: '');
        await storageProspecto.write(key: 'RespuestaProspectos', value: json.encode(objLeadEditMemoria));
*/

        return ResponseGenericModel.fromRawJson(response.body);

      } 
      catch(_){
        //print('Error al grabar: $ex');
      }
    } else {
      //await storageProspecto.write(key: 'registraProspecto', value: jsonEncode(objProspecto.toJson()));
      //await storageProspecto.write(key: 'TienePendienteRegistros', value: 'S');

      return ProspectoRegistroResponseModel(
        id: -1,
        jsonrpc: '',
        result: ProspectoRegistroModel(
          estado: 0, 
          mensaje: '', 
          data: []
        ),
        mensaje: objMensajesProspectoService.mensajeOffLineGenerico
      );
    }

  }


}

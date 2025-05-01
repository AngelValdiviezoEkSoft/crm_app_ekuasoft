
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

  /*
  ProspectoTypeService(){
    //getProspecto(tipoIdent, numIdent);
  }
  */

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

      var objRsp = await GenericService().getMultiModelos(objReq, "crm.lead");

      var rsp = AppResponseModel.fromRawJson(objRsp);

      //print('Lst Prsp 1: ${json.encode(rsp.result.data.crmLead)}');

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

  getProspectoRegistrado(String phoneProsp) async {
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
          "phone": phoneProsp
        }
      };

      final response = await http.post(
        Uri.parse(ruta),
        headers: headers,
        body: jsonEncode(requestBody), 
      );

      var rspValidacion = json.decode(response.body);

      if(rspValidacion['result']['mensaje'] != null && (rspValidacion['result']['mensaje'].toString().trim().toLowerCase() == MensajeValidacion().tockenNoValido || rspValidacion['result']['mensaje'].toString().trim().toLowerCase() == MensajeValidacion().tockenExpirado)){
        await tokenManager.checkTokenExpiration();
        await getProspectoRegistrado(phoneProsp);
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
            "create": {
              "name": objProspecto.name,
              "phone": objProspecto.phone,          
              "contact_name": objProspecto.contactName,
              "partner_name": objProspecto.partnerName,
              //"date_closed": DateFormat('yyyy-MM-dd', 'es').format(objProspecto.dateClose!),
              "date_deadline": DateFormat('yyyy-MM-dd', 'es').format(objProspecto.dateDeadline!),//date_deadline
              "email_from": objProspecto.emailFrom,
              "street": objProspecto.street,
              "expected_revenue": objProspecto.expectedRevenue,
              "referred": objProspecto.referred,
              "description": objProspecto.description,
              "probability": objProspecto.probability,
              "campaign_id": objProspecto.campaignId!.id,
              "source_id": objProspecto.sourceId.id,
              "medium_id": objProspecto.mediumId.id,
              "country_id": objProspecto.countryId.id
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
          ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/create/crm.lead/model';
        }

        //print('Test: ${jsonEncode(requestBody)}');

        final response = await http.post(
          Uri.parse(ruta),
          headers: headers,
          body: jsonEncode(requestBody), 
        );
      
        var rspValidacion = json.decode(response.body);

        if(rspValidacion['result']['mensaje'] != null && (rspValidacion['result']['mensaje'].toString().trim().toLowerCase() == MensajeValidacion().tockenNoValido || rspValidacion['result']['mensaje'].toString().trim().toLowerCase() == MensajeValidacion().tockenExpirado)){
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
          CombosAppModel objStageTmp = CombosAppModel(id: objRespuestaFinal.result.data[i].stageId?.id ?? 0, name: objRespuestaFinal.result.data[i].stageId?.name ?? '');
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
            description: objProspecto.description            
          );

          objLead.data.add(objCrmLeadDatumAppModel);

        }

        await storageProspecto.write(key: 'RespuestaProspectos', value: '');
        await storageProspecto.write(key: 'RespuestaProspectos', value: json.encode(objLead));

        return objRespuestaFinal;
      } 
      catch(_){
        //print('Error al grabar: $ex');
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

}

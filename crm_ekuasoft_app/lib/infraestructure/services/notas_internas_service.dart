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

const storageNotInt = FlutterSecureStorage();
final objMensajesAlertasNotInt = MensajesAlertas();

class NotasInternasService extends ChangeNotifier{

  static final jsonRpc = EnvironmentsProd().jsonrpc;

  final TokenManager tokenManager = TokenManager();

  final String endPoint = CadenaConexion().apiEndpoint;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  getNotasInternas(resId) async {
    try{

      var objLog = await storageNotInt.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);
      
      final models = [
        {
          "model": EnvironmentsProd().modMailMessage,
          "filters": [
            ['model', '=', EnvironmentsProd().modCrmLead],
            ['res_id', '=', resId],
            ['is_done_app', '=', true],
            ['message_type', '=', 'comment'],
            ['subtype_id', '=', 2]
          ]
        },
      ];

      var codImei = await storageNotInt.read(key: 'codImei') ?? '';

      var objReg = await storageNotInt.read(key: 'RespuestaRegistro') ?? '';
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
      final objStr = await storageNotInt.read(key: 'RespuestaRegistro') ?? '';
      
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

      var rsp = NotasInternasResponse.fromRawJson(response.body);

      return rsp.result?.data?.mailMessage?.data ?? [];
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

  registroNotasInternas(ActivitiesTypeRequestModel objActividad, String notaInterna) async {
    String internet = await ValidacionesUtils().validaInternet();
    
    //VALIDACIÓN DE INTERNET
    if(internet.isEmpty){
      
      try{

        var codImei = await storageNotInt.read(key: 'codImei') ?? '';

        var objReg = await storageNotInt.read(key: 'RespuestaRegistro') ?? '';
        var obj = RegisterDeviceResponseModel.fromJson(objReg);

        var objLog = await storageNotInt.read(key: 'RespuestaLogin') ?? '';
        var objLogDecode = json.decode(objLog);

        final rspLogin = await storageNotInt.read(key: 'DataUser') ?? '';

        final jsonLog = json.decode(rspLogin);

        String userName = jsonLog["result"]["data"][0]["display_name"];

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
            "create": {
              'message_type': 'comment',      //(Esto es para que Odoo sepa que se trata de una nota)              
              'body': notaInterna,          //(Texto que el usuario escriba como nota)
              'email_from': userName,    //(Nombre del usuario)
              'is_done_app': true,            //(Indica que se creó desde la app)
              'user_id': objActividad.userId,             //(ID del usuurio)
              'model': EnvironmentsProd().modCrmLead,            //(Nombre del modelo al que se relacionadará la nota)
              'res_id': objActividad.resId,                //(ID del prospecto al que se relacionará la nota)
              'lead_name': 'Posible terreno', //(Nombre del prospecto)
              'lead_phone': objActividad.leadPhone,       // (Teléfono del prospecto)
              'lead_contact_name': objActividad.contactName,  //   (Nombre del contacto del prospecto)
              'lead_email': objActividad.leadEmail,  //     (Correo del contacto)
            },
          }
        };

        final headers = {
          "Content-Type": EnvironmentsProd().contentType
        };

        String ruta = '';
        final objStr = await storageNotInt.read(key: 'RespuestaRegistro') ?? '';
        
        if(objStr.isNotEmpty)
        {
          var obj = RegisterDeviceResponseModel.fromJson(objStr);
          ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/create/mail.message/model';
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
          await registroNotasInternas(objActividad, notaInterna);
        }

        var objRespuestaFinal = ActividadRegistroResponseModel.fromRawJson(response.body);

/*
        var objRspPrsp = await storageNotInt.read(key: 'RegistraActividad') ?? '';

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

        //await storageNotInt.write(key: 'RegistraActividad', value: jsonEncode(objRespuestaFinal.toJson()));

        return objRespuestaFinal;
      } 
      catch(_){
        //print('Error al grabar: $ex');
      }
    } else {
      List<ActivitiesTypeRequestModel> lstAct = [];

      final tstAct = await storageNotInt.read(key: 'RegistraActividad') ?? '';

      if(tstAct.isNotEmpty){
        var varDecod = jsonDecode(tstAct);

        for(int i = 0; i < varDecod.length; i++){
          ActivitiesTypeRequestModel objGuardar = ActivitiesTypeRequestModel.fromJson(varDecod[i]);
          lstAct.add(objGuardar);
        }
        
      }

      lstAct.add(objActividad);
      
      await storageNotInt.write(key: 'RegistraActividad', value: jsonEncode(lstAct));

      return ActividadRegistroResponseModel(
        id: 0,
        jsonrpc: '',
        result: ResultActividad(
          data: [],
          estado: 0,
          mensaje: objMensajesAlertasNotInt.mensajeOffLine
        )
      );
    }

  }

}

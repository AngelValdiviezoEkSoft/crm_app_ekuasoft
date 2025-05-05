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

const storageInfo = FlutterSecureStorage();

class InformativeService extends ChangeNotifier{

  final TokenManager tokenManager = TokenManager();

  final String endPoint = CadenaConexion().apiEndpoint;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  getLinksInformation() async {
    try{

      List<MultiModel> lstMultiModel = [];

      lstMultiModel.add(
        MultiModel(model: 'blog.post')
      );

      final models = [
        {
          "model": EnvironmentsProd().modBlogPost,          
        },
      ];

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

      String ruta = '';
      final objStr = await storageCamp.read(key: 'RespuestaRegistro') ?? '';
      
      if(objStr.isNotEmpty)
      {  
        var obj = RegisterDeviceResponseModel.fromJson(objStr);
        ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/data/multi/models';
      }

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

      //print('Resultado: ${response.body}');
      
      var rsp = AppResponseModel.fromRawJson(response.body);

      String cmbLstAct = json.encode(rsp.result.data.mailActivity);

      ActivitiesResponseModel _ = ActivitiesResponseModel.fromRawJson(cmbLstAct);

      var lstProsp = await storageCamp.read(key: 'RespuestaProspectos') ?? '';

      var objLogDecode2 = json.decode(lstProsp);      

      CrmLeadAppModel apiResponse = CrmLeadAppModel.fromJson(objLogDecode2);
      
      return apiResponse;
    }
    /*
    catch(_){
     //print('Test: $ex');
    }
    */
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

}

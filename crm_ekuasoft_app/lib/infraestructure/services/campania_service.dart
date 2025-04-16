
import 'dart:convert';
import 'dart:io';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';

const storageCamp = FlutterSecureStorage();

class CampaniaService extends ChangeNotifier{

  final String endPoint = CadenaConexion().apiEndpoint;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TokenManager tokenManager = TokenManager();
  
  getCompanias() async {
    try{

      var codImei = await storageCamp.read(key: 'codImei') ?? '';

      var objReg = await storageCamp.read(key: 'RespuestaRegistro') ?? '';
      //print('Tst camp: $objReg');
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      var objLog = await storageCamp.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

      List<MultiModel> lstMultiModel = [];

      lstMultiModel.add(
        MultiModel(model: 'utm.campaign')
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

      tokenManager.startTokenCheck();

      var rsp = await GenericService().getMultiModelos(objReq, "utm.campaign");
      
      //return CampaniaResponseModel.fromJson(rsp);
      
      return rsp;
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

}


import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:intl/intl.dart';

final objMensajesAlertasProf = MensajesAlertas();

class ProfileService extends ChangeNotifier{

  static final jsonRpc = EnvironmentsProd().jsonrpc;

  final TokenManager tokenManager = TokenManager();

  final String endPoint = CadenaConexion().apiEndpoint;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  editPerfil(int idUser, String cell, String email, String direccion) async {
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
            "id": idUser,
            "write": {
              "phone": cell,
              "email": email,
              "street": direccion
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
          ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/write/res.partner/model';
        }

        final response = await http.post(
          Uri.parse(ruta),
          headers: headers,
          body: jsonEncode(requestBody), 
        );

        CierreActividadesResponseModel objCierre = CierreActividadesResponseModel.fromRawJson(response.body);

        return objCierre;
      } 
      catch(_){
        //print('Error al grabar: $ex');
      }
    } else {
      //await storageProspecto.write(key: 'RegistraActividad', value: jsonEncode(objActividad.toJson()));

      return ProspectoRegistroResponseModel(
        id: 0,
        jsonrpc: '',
        result: ProspectoRegistroModel(
          estado: 0, 
          mensaje: '', 
          data: []
        ),
        mensaje: objMensajesAlertasProf.mensajeOffLine
      );
    }

  }

}

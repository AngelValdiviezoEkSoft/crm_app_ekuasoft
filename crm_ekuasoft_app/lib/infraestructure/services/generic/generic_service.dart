import 'dart:async';
import 'dart:convert';
import 'package:crm_ekuasoft_app/config/routes/app_router.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

//import '../../config/routes/routes.dart';

class GenericService extends ChangeNotifier {
  final env = CadenaConexion();
  final storage = const FlutterSecureStorage();
  List<OpcionesMenuModel> lstOp = [];

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TokenManager tokenManager = TokenManager();

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  getModelos(ConsultaModelRequestModel objReq, String modelBusca) async {
    //final ruta = '${env.apiEndpoint}<imei>/done/data/<model>/model';

    String ruta = '';
    final objStr = await storage.read(key: 'RespuestaRegistro') ?? '';
    
    if(objStr.isNotEmpty)
    {  
      var obj = RegisterDeviceResponseModel.fromJson(objStr);
      ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/data/$modelBusca/model';
    }
    
    final Map<String, dynamic> body = 
    {
      "jsonrpc": EnvironmentsProd().jsonrpc,
      "params": {
        "key": objReq.params.key,
        "tocken": objReq.params.tocken,
        "imei": objReq.params.imei,
        "uid": objReq.params.uid,
        "company": objReq.params.company,
        "bearer": objReq.params.bearer,
        "tocken_valid_date": objReq.params.tockenValidDate,
        "filters": ''
      }
    };
    
    final response = await http.post(
      Uri.parse(ruta),
      headers: <String, String>{
        'Content-Type': EnvironmentsProd().contentType//'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
    
    var reponseRs = response.body;

    var rspValidacion = json.decode(response.body);

    //if(rspValidacion['result']['mensaje'] == 'El tocken no es valido'){
    if(rspValidacion['result']['mensaje'] != null && 
      (
        rspValidacion['result']['mensaje'].toString().trim().toLowerCase() == MensajeValidacion().tockenNoValido || 
        rspValidacion['result']['mensaje'].toString().trim().toLowerCase() == MensajeValidacion().tockenExpirado
      )){
      await tokenManager.checkTokenExpiration();
      await getModelos(objReq, modelBusca);
    }

    var obj = RegisterDeviceResponseModel.fromJson(reponseRs);

    await storage.write(key: 'RespuestaRegistro', value: reponseRs);

    return obj;    
  }

  getMultiModelos(ConsultaMultiModelRequestModel objReq, String modelo) async {

    String ruta = '';
    final objStr = await storage.read(key: 'RespuestaRegistro') ?? '';
    
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
        "models": [
          {
            "model": modelo
          }
        ],
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
    
    var rspValidacion = json.decode(response.body);

    //if(rspValidacion['result']['mensaje'] == 'El tocken no es valido'){
    if(rspValidacion['result']['mensaje'] != null && (rspValidacion['result']['mensaje'].toString().trim().toLowerCase() == MensajeValidacion().tockenNoValido || rspValidacion['result']['mensaje'].toString().trim().toLowerCase() == MensajeValidacion().tockenExpirado)){
      await tokenManager.checkTokenExpiration();
      await getMultiModelos(objReq, modelo);
    }

    return response.body;
    
  }
  
  getMultiModelosGen(ConsultaMultiModelRequestModel objReq, List<Map<String, dynamic>> lstModels) async {

    String ruta = '';
    final objStr = await storage.read(key: 'RespuestaRegistro') ?? '';
    
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
        "models": lstModels
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
    
    var rspValidacion = json.decode(response.body);

    //if(rspValidacion['result']['mensaje'] == 'El tocken no es valido'){
    if(rspValidacion['result']['mensaje'] != null && (rspValidacion['result']['mensaje'].toString().trim().toLowerCase() == MensajeValidacion().tockenNoValido || rspValidacion['result']['mensaje'].toString().trim().toLowerCase() == MensajeValidacion().tockenExpirado)){
      await tokenManager.checkTokenExpiration();
      await getMultiModelosGen(objReq, lstModels);
    }

    //print('Lst gen: ${response.body}');

    var rsp = AppResponseModel.fromRawJson(response.body);

    //print('Lst Prsp: ${json.encode(rsp.result.data.crmLead)}'); 

    await storage.write(key: 'RespuestaProspectos', value: json.encode(rsp.result.data.crmLead));
    await storage.write(key: 'RespuestaClientes', value: json.encode(rsp.result.data.resPartner));

    await storage.write(key: 'cmbCampania', value: json.encode(rsp.result.data.utmCampaign));
    await storage.write(key: 'cmbOrigen', value: json.encode(rsp.result.data.utmSource));
    await storage.write(key: 'cmbMedia', value: json.encode(rsp.result.data.utmMedium));
    await storage.write(key: 'cmbActividades', value: json.encode(rsp.result.data.mailActivityType));
    await storage.write(key: 'cmbPaises', value: json.encode(rsp.result.data.resCountry));
    await storage.write(key: 'cmbLstActividades', value: json.encode(rsp.result.data.mailActivity));

    return response.body;
    
  }
  
  Future<dynamic> opcionesMenuPorPerfil(BuildContext context) async {
    lstOp = [
      OpcionesMenuModel(
        descMenu: 'Editar Perfil', 
        icono: Icons.person_pin, 
        onPress: () => context.push(objRutas.rutaEditarPerfil),
      ),
      OpcionesMenuModel(
        descMenu: 'Soporte', 
        icono: Icons.question_mark,
        onPress: () => context.push(objRutas.rutaConstruccion),
      ),
      OpcionesMenuModel(
        descMenu: 'Terminos de uso',
        icono: Icons.info,
        onPress: () => context.push(objRutas.rutaConstruccion),
      ),
    ];
    return lstOp;
  }

}

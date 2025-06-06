import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crm_ekuasoft_app/config/routes/app_router.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

//late Timer _timer;

class AuthService extends ChangeNotifier {

  static final jsonRpc = EnvironmentsProd().jsonrpc;

  final env = CadenaConexion();
  final storage = const FlutterSecureStorage();
  List<OpcionesMenuModel> lstOp = [];

  final TokenManager tokenManager = TokenManager();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String passWord = '';
  String email = '';
  bool _areInputsView = false;
  bool _inputPin = false;

  bool get areInputsView => _areInputsView;
  set areInputsView(bool value) {
    _areInputsView = value;
    notifyListeners();
  }

  bool get inputPin => _inputPin;
  set inputPin(bool value) {
    _inputPin = value;
    notifyListeners();
  }

  bool isLoading = false;
  bool get varIsLoading => isLoading;
  set varIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  bool isLoadingCambioClave = false;
  bool get varIsLoadingCambioClave => isLoadingCambioClave;
  set varIsLoadingCambioClave(bool value) {
    isLoadingCambioClave = value;
    notifyListeners();
  }

  String varCedula = '';
  String varPasaporte = '';

  bool isKeyOscured = true;
  bool get varIsKeyOscured => isKeyOscured;
  set varIsKeyOscured(bool value) {
    isKeyOscured = value;
    notifyListeners();
  }

  bool isOscured = true;
  bool get varIsOscured => isOscured;
  set varIsOscured(bool value) {
    isOscured = value;
    notifyListeners();
  }

  bool isOscuredConf = true;
  bool get varIsOscuredConf => isOscuredConf;
  set varIsOscuredConf(bool value) {
    isOscuredConf = value;
    notifyListeners();
  }

  bool isOscuredConfNew = true;
  bool get varIsOscuredConfNew => isOscuredConfNew;
  set varIsOscuredConfNew(bool value) {
    isOscuredConfNew = value;
    notifyListeners();
  }

  bool isPasaporte = false;
  bool get varIsPasaporte => isPasaporte;
  set varIsPasaporte(bool value) {
    isPasaporte = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  //#region Registro Dispositivo
  doneRegister(RegisterMobileRequestModel objRegister) async {
    final ruta = '${env.apiEndpoint}done/register';

    final Map<String, dynamic> body = {
    "jsonrpc": EnvironmentsProd().jsonrpc,
    "params": {
      "server": objRegister.server,
      "key": objRegister.key,
      "imei": objRegister.imei,
      "lat": objRegister.lat,
      "lon": objRegister.lon,
      "so": objRegister.so
      }
    };
    
    final response = await http.post(
      Uri.parse(ruta),
      headers: <String, String>{
        'Content-Type': EnvironmentsProd().contentType,
      },
      body: jsonEncode(body),
    );
    
    var reponseRs = response.body;

    //print("Test: " + response.body);

    var obj = RegisterDeviceResponseModel.fromJson(reponseRs);

    if(obj.result.estado == 200){
      await storage.write(key: 'codImei', value: objRegister.imei);
      await storage.write(key: 'RespuestaRegistro', value: reponseRs);
    }

    return obj;//RegisterDeviceResponseModel.fromJson(reponseRs);
    
  }
  
  doneGetTocken(String imei, String key) async {
    final ruta = '${env.apiEndpoint}done/$imei/tocken/$key';
    
    final Map<String, dynamic> body = {
      "jsonrpc": EnvironmentsProd().jsonrpc,
      "params": {}
    };
    
    final response = await http.post(
      Uri.parse(ruta),
      headers: <String, String>{
        'Content-Type': EnvironmentsProd().contentType,
      },
      body: jsonEncode(body),
    );
    
    var reponseRs = response.body;

    var obj = RegisterDeviceResponseModel.fromJson(reponseRs);

    await storage.write(key: 'RespuestaRegistro', value: '');
    await storage.write(key: 'RespuestaRegistro', value: reponseRs);

    return obj;    
  }
  
  doneValidateTocken(String imei, String key, String tocken) async {
    final ruta = '${env.apiEndpoint}done/$imei/validate/tocken/$key';
    
    final Map<String, dynamic> body = {
      "jsonrpc": EnvironmentsProd().jsonrpc,
      "params": {
        "tocken": tocken
      }
    };
    
    final response = await http.post(
      Uri.parse(ruta),
      headers: <String, String>{
        'Content-Type': EnvironmentsProd().contentType,
      },
      body: jsonEncode(body),
    );
    
    var reponseRs = response.body;
    //return ValidationTokenResponseModel.fromJson(reponseRs);
    return reponseRs;
  }
  //#endregion

  login(AuthRequest authRequest) async {
    try {

      String resInt = await ValidacionesUtils().validaInternet();

      if(resInt.isNotEmpty){
        return 'NI';
      }

      String ruta = '';
      final objStr = await storage.read(key: 'RespuestaRegistro') ?? '';
    
      if(objStr.isNotEmpty)
      {  
        var obj = RegisterDeviceResponseModel.fromJson(objStr);
        ruta = '${obj.result.url}/web/session/authenticate';
      }

      final Map<String, dynamic> body = {
        "jsonrpc": EnvironmentsProd().jsonrpc,
        "params": {
          "db": authRequest.db,
          "login": authRequest.login,
          "password": authRequest.password
        },
        "id": null
      };
      
      final response = await http.post(
        Uri.parse(ruta),
        headers: <String, String>{
          'Content-Type': EnvironmentsProd().contentType,
        },
        body: jsonEncode(body),
      );

      //print('Test: ${response.body}');
      
      var rspValidacion = json.decode(response.body);

      if(rspValidacion['error'] != null){
        return response.body;
      }

      
      if(rspValidacion['result']['mensaje'] != null && (rspValidacion['result']['mensaje'].toString().trim().toLowerCase() == MensajeValidacion().tockenNoValido || rspValidacion['result']['mensaje'].toString().trim().toLowerCase() == MensajeValidacion().tockenExpirado)){
        await tokenManager.checkTokenExpiration();
        await login(authRequest);
      }

      final models = [        
        {
          "model": EnvironmentsProd().modProsp,//"crm.lead",
          "filters": []
        },
        {
          "model": EnvironmentsProd().modClien,//"res.partner",
          "filters": []
        },
        {
          "model": EnvironmentsProd().modCampa,//"utm.campaign",
          "filters": []
        },
        {
          "model": EnvironmentsProd().modOrige,//"utm.source",
          "filters": []
        },
        {
          "model": EnvironmentsProd().modMedio,//"utm.medium",
          "filters": []
        },
        {
          "model": EnvironmentsProd().modActiv,//"mail.activity.type",
          "filters": [
            ["res_model","=",false]
          ]
        },
        {
          "model": EnvironmentsProd().modPaise,//"res.country",
          "filters": []
        },
        {
          "model": EnvironmentsProd().modIrModel,//"ir.model",
          "filters": [
            ["model","=",EnvironmentsProd().modCrmLead]//"crm.lead"
          ]
        },
      ];

      await storage.write(key: 'RespuestaLogin', value: response.body);

      //print('Result Login: ${response.body}');
      
      await DataInicialService().readModelosApp(models);

      //#region ConsultaCorreo
      var objReg = await storage.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      var objLog = await storage.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

      var codImei = await storage.read(key: 'codImei') ?? '';

      ConsultaModelRequestModel objRqst = ConsultaModelRequestModel(
        jsonrpc: '',
        params: ParamsConsultaModel(
          bearer: obj.result.bearer,
          company: objLogDecode['result']['current_company'],
          imei: codImei,
          key: obj.result.key,
          models: [],
          tocken: obj.result.tocken,
          tockenValidDate: obj.result.tockenValidDate,
          uid: objLogDecode['result']['uid'],
        )
      );

      String rsp = await GenericService().getModelosByUidUser(objRqst, 'res.users');

      var rspCorreo = json.decode(rsp);

      String emailUser = rspCorreo["result"]["data"][0]["email"];

      await storage.write(key: 'CorreoUser', value: emailUser);
      //#endregion

      return response.body;
    } catch (_) {
      //print('Test Error1: $ex');
    }
  }

  consultaUsuarios(ConsultaDatosRequestModel authRequest, String imei, String key) async {
    final ruta = '${env.apiEndpoint}<imei>/done/data/<model>/model';
    
     final response = await http.post(
      Uri.parse(ruta),
      headers: <String, String>{
        'Content-Type': EnvironmentsProd().contentType,
      },
      body: jsonEncode(
        <String, String>
        {
          "key": authRequest.key,
          "tocken": authRequest.token,
          "imei": authRequest.imei,
          "uid": authRequest.uid,
          "company": authRequest.company,
          "bearer": authRequest.bearer,
          "tocken_valid_date": authRequest.tokenValidDate,
          //"filters": objRegister.so  //PEDIR EJEMPLO
        }
      ),
    );
    
    var reponseRs = response.body;

    var rspValidacion = json.decode(response.body);

    if(rspValidacion['result']['mensaje'] == 'El tocken no es valido'){
      await tokenManager.checkTokenExpiration();
      await consultaUsuarios(authRequest,imei, key);
    }

    return RegisterDeviceResponseModel.fromJson(reponseRs);
    
  }
  
  getIrModel() async {
    try{

      var codImei = await storagePais.read(key: 'codImei') ?? '';

      var objReg = await storagePais.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      var objLog = await storagePais.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

      List<MultiModel> lstMultiModel = [];

      lstMultiModel.add(
        MultiModel(model: 'ir.model')
      );
/*
      final models = [
        {
          "model": EnvironmentsProd().modIrModel,
          "filters": [
            ["model","=",EnvironmentsProd().modCrmLead],
          ]
        },
      ];
      */


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

      var rsp = await GenericService().getMultiModelos(objReq, "ir.model");
      
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

  Future<dynamic> opcionesMenuPorPerfil(BuildContext context) async {

    var objLogin = await storage.read(key: 'RespuestaLogin') ?? '';

    final data = json.decode(objLogin);

    lstOp = [
      OpcionesMenuModel(
        descMenu: 'Editar Perfil', 
        icono: Icons.person_pin, 
        onPress: () => context.push(objRutas.rutaEditarPerfil),
      ),
      OpcionesMenuModel(
        descMenu: 'Soporte', 
        icono: Icons.question_mark,
        onPress: () async =>  await launchUrl(Uri.parse(data["result"]["done_support_url"]), mode: LaunchMode.externalApplication),
      ),
      OpcionesMenuModel(
        descMenu: 'Términos de uso',
        icono: Icons.info,
        onPress: () async =>  await launchUrl(Uri.parse(data["result"]["done_terms_of_use_url"]), mode: LaunchMode.externalApplication),
      ),
    ];
    return lstOp;
  }

  cambioDeClave(String anteriorClave, String nuevaClave, int idUser, String userName) async {
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
            "login": userName,
            "old_password": anteriorClave,
            "new_password": nuevaClave
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
          ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/change_password';          
        }

        final response = await http.post(
          Uri.parse(ruta),
          headers: headers,
          body: jsonEncode(requestBody), 
        );

        CambioClaveResponseModel objCierre = CambioClaveResponseModel.fromRawJson(response.body);

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
        mensaje: objMensajesAlertasAct.mensajeOffLineGenerico
      );
    }

  }

  cambioDeCorreo(String correoNuevo) async {
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

        List<Map<String, dynamic>> writeList = [];

        /* 
        
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
            "write_list": {
              [
                
              ]
            },
          }
        };

        */

        writeList.add({
          "id": objReq.params.uid,
          "write": {              
            "email": correoNuevo,
          }
        });

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
          ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/write/res.users/model';      
        }

        final response = await http.post(
          Uri.parse(ruta),
          headers: headers,
          body: jsonEncode(requestBody), 
        );

        CambioClaveResponseModel objCierre = CambioClaveResponseModel.fromRawJson(response.body);

        await storage.write(key: 'CorreoUser', value: '');
        await storage.write(key: 'CorreoUser', value: correoNuevo);

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
        mensaje: objMensajesAlertasAct.mensajeOffLineGenerico
      );
    }

  }

  Future logOut() async {
    await storage.write(key: 'RespuestaLogin', value: '');
    
    await storage.write(key: 'RespuestaProspectos', value: '');
    await storage.write(key: 'RespuestaClientes', value: '');

    await storage.write(key: 'cmbCampania', value: '');
    await storage.write(key: 'cmbOrigen', value: '');
    await storage.write(key: 'cmbMedia', value: '');
    await storage.write(key: 'cmbActividades', value: '');
    await storage.write(key: 'cmbPaises', value: '');
    await storage.write(key: 'RespuestaIrModel', value: '');
    
    return;
  }

}

import 'dart:async';
import 'dart:convert';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:crm_ekuasoft_app/infraestructure/services/generic/generic_service.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storageClient = FlutterSecureStorage();
MensajesAlertas objMensajesClienteService = MensajesAlertas();

class ClienteService extends ChangeNotifier {
  
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  List<ClientModelResponse> lstClientes = [];
  
  final storageEcommerce = const FlutterSecureStorage();

  Future<dynamic> getClientesByVendedor() async {

    lstClientes.add(
      ClientModelResponse(id: 1, primerApellido: 'Angel', segundoNombre: 'Elías', primerNombre: 'Valdiviezo', segundoApellido: 'González', direccion: 'Durán', estado: 'Activo', codigoCli: '001', numIdentificacion: '099887766'),      
    );

    lstClientes.add(
      ClientModelResponse(id: 2, primerApellido: 'Angel 2', segundoNombre: 'Elías', primerNombre: 'Valdiviezo', segundoApellido: 'González', direccion: 'Durán', estado: 'Activo', codigoCli: '002', numIdentificacion: '099887765')
    );

    return lstClientes;
  }

  Future<dynamic> getVendedores() async {

    lstClientes.add(
      ClientModelResponse(id: 1, primerApellido: 'Yordani', segundoNombre: '', primerNombre: 'Oliva', segundoApellido: '', direccion: 'Guayacanes', estado: 'Activo', codigoCli: '003', numIdentificacion: '099887764'),
    );

    lstClientes.add(
      ClientModelResponse(id: 2, primerApellido: 'Angel', segundoNombre: 'Elías', primerNombre: 'Valdiviezo', segundoApellido: 'González', direccion: 'Durán', estado: 'Activo', codigoCli: '004', numIdentificacion: '099887763')
    );

    return lstClientes;
  }

  getClientes() async {
    try{

      var codImei = await storage.read(key: 'codImei') ?? '';

      var objReg = await storage.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      var objLog = await storage.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

      List<MultiModel> lstMultiModel = [];

      lstMultiModel.add(
        MultiModel(model: 'res.partner')
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

      var objRsp = await GenericService().getMultiModelos(objReq, "res.partner");
      
      var rsp = AppResponseModel.fromRawJson(objRsp);

      await storageClient.write(key: 'RespuestaClientes', value: '');
      await storageClient.write(key: 'RespuestaClientes', value: json.encode(rsp.result.data.resPartner));

      return json.encode(objRsp);
    }
    catch(ex){
      //print('Error: $ex');
      return null;
    }
    
  }

}

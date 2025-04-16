
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crm_ekuasoft_app/config/config.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

MensajesAlertas objMensajesUserService = MensajesAlertas();

class UserFormService extends ChangeNotifier{

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final String endPoint = CadenaConexion().apiUtilsEndpoint;
  final String apiEndpointEnrolApp = CadenaConexion().apiEndpoint;
  final String apiEndpointEvalCore = CadenaConexion().apiEndPointEvalCore;
  final storageUser = const FlutterSecureStorage();
  FeatureApp objFeatures = FeatureApp();

  bool isValidForm(){
    return formKey.currentState?.validate() ?? false;
  }

  bool login(String varUser, String varPassWord){
    bool varPermiteIngreso = true;

    if(varUser != 'avaldiviezo@riasem.com.ec' && varPassWord != '1234'){
      varPermiteIngreso = false;
    }

    return varPermiteIngreso;
  }

  Future<String> getFotoCarnet(String numIdentificacion) async {
    try{
      final baseURL = '${endPoint}Adjuntos/GetAdjunto?identificacion=$numIdentificacion}';

      String tokenUser = await storageUser.read(key: 'jwtEnrolApp') ?? ''; 

      final responseLogin = await http.get(
        Uri.parse(baseURL),
        headers: <String, String>{
          'Content-Type': EnvironmentsProd().contentType,//'application/json; charset=UTF-8',
          'Authorization': 'Bearer $tokenUser',
        },
      );
      
      final resp = AdjuntosTypeResponse.fromJson(responseLogin.body);

      String rutaFinal = '';

      if(resp.succeeded && resp.statusCode == '000') {
        if(resp.data.length - 1 >= 0) {
          rutaFinal = 'https://imagenes.enrolapp.ec/${resp.data[0].rutaAcceso}';
        }
      }

      return rutaFinal;
    } catch(_) {
      return '';
    }
  }

  Future<ClientTypeResponse?> cambioContrasenia(String varNumIdent, String varContrasenaAnterior,String varContrasenaNueva) async {
    try { 
      final baseURL = '${apiEndpointEnrolApp}Clientes/UpdateContrasenaColaborador';
      String tokenUser = await storageUser.read(key: 'jwtEnrolApp') ?? '';
      String tipoCliente = await storageUser.read(key: 'tipoCliente') ?? '';

      final response = await http.put(
        Uri.parse(baseURL),
        headers: <String, String>{
          'Content-Type': EnvironmentsProd().contentType,//'application/json; charset=UTF-8',
          'Authorization': 'Bearer $tokenUser',
        },
        body: jsonEncode(<String, String>{
            "identificacion": varNumIdent,
            "contrasenaAnterior": varContrasenaAnterior,
            "contrasenaNueva": varContrasenaNueva,
            "tipoColaborador": tipoCliente
          }
        )
      );

      final rspVacacion = ClientTypeResponse.fromJson(response.body); 
      return rspVacacion;
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(
          msg: objMensajesUserService.mensajeTiempoEspera,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: objMensajesUserService.mensajeFallaInternet,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } on HttpException catch (_) {
      Fluttertoast.showToast(
          msg: objMensajesUserService.mensajePeticion,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } on FormatException catch (_) {
      Fluttertoast.showToast(
        msg: objMensajesUserService.mensajeErrorFormato,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
    return null;
  }

  Future<dynamic> consultaDataPerfil(String numIdent) async {
    try {
      String baseURL = '';
      String tipoCliente = await storageUser.read(key: 'tipoCliente') ?? '';
      if(tipoCliente.toLowerCase() == 'c') {
        baseURL = '${apiEndpointEnrolApp}Clientes/GetListadoColaboradores?colaborador=$numIdent';
      } else {
        baseURL = '${apiEndpointEnrolApp}Familiares/GetInfoFamiliarColaborador?identificacionFamiliar=$numIdent';
      }
      

      String tokenUser = await storageUser.read(key: 'jwtEnrolApp') ?? ''; 

      final responseDatosUsuario = await http.get(
        Uri.parse(baseURL),
        headers: <String, String>{
          'Content-Type': EnvironmentsProd().contentType,//'application/json; charset=UTF-8',
          'Authorization': 'Bearer $tokenUser',
        },
      );

      if(responseDatosUsuario.statusCode != 200) return UsuarioListTypeResponse(data: [], errors: null, message: 'Error', statusCode: '', succeeded: false);
      
      final resp = UsuarioListTypeResponse.fromJson(responseDatosUsuario.body);

      return resp;
    } catch(_) {
      return null;
    }
  }

  Future<dynamic> verificacionFotoPerfil(DatosPersonalesUserModel? objDataPersonal, FotoPerfilModel? objFotoPerfil) async {
    try {
      final baseURL = '${apiEndpointEvalCore}Biometria/VerificacionFacial';

      String tokenUser = await storageUser.read(key: 'jwtEnrolApp') ?? ''; 

      if(objDataPersonal != null) {
        final response = await http.post(
          Uri.parse(baseURL),
          headers: <String, String>{
            'Content-Type': EnvironmentsProd().contentType,//'application/json; charset=UTF-8',
            'Authorization': 'Bearer $tokenUser',
          },
          body: jsonEncode(<String, dynamic>{
              "base64": objDataPersonal.adjunto?.base64,
              "nombre": objDataPersonal.adjunto?.nombre,
              "extension": objDataPersonal.adjunto?.extension
            }
          )
        );

        if(response.statusCode != 200) {
          return ClientTypeResponse(succeeded: false, data: 'Error al verificar foto',errors: Errors(),message: '',statusCode: '001');
        }

        final rspVacacion = ClientTypeResponse.fromJson(response.body); 
        return rspVacacion;
      }

      if(objFotoPerfil != null) {
        final response = await http.post(
          Uri.parse(baseURL),
          headers: <String, String>{
            'Content-Type': EnvironmentsProd().contentType,//'application/json; charset=UTF-8',
            'Authorization': 'Bearer $tokenUser',
          },
          body: jsonEncode(<String, dynamic>{
              "base64": objFotoPerfil.base64,
              "nombre": objFotoPerfil.nombre,
              "extension": objFotoPerfil.extension
            }
          )
        );

        if(response.statusCode != 200) {
          return ClientTypeResponse(succeeded: false, data: 'Error al verificar foto',errors: Errors(),message: '',statusCode: '001');
        }

        final rspVacacion = ClientTypeResponse.fromJson(response.body); 
        return rspVacacion;
      }
      
    } catch(_) {
      return null;
    }
  }

  Future<dynamic> editaDataPerfil(DatosPersonalesUserModel objDataPersonal) async {

    try {
      final baseURL = '${apiEndpointEnrolApp}Clientes/UpdateInfoPersonalColaborador';

      String tokenUser = await storageUser.read(key: 'jwtEnrolApp') ?? ''; 

      final response = await http.put(
        Uri.parse(baseURL),
        headers: <String, String>{
          'Content-Type': EnvironmentsProd().contentType,//'application/json; charset=UTF-8',
          'Authorization': 'Bearer $tokenUser',
        },
        body: 
          jsonEncode(<String, dynamic>{
            "id": objDataPersonal.id,
            "codUdn": objDataPersonal.codUdn,
            "udn": objDataPersonal.udn,
            "codArea": objDataPersonal.codArea,
            "area": objDataPersonal.area,
            "codScc": objDataPersonal.codScc,
            "scc": objDataPersonal.scc,
            "colaborador": objDataPersonal.colaborador,
            "cedula": objDataPersonal.cedula,
            "codigo": objDataPersonal.codigo,
            "cargo": objDataPersonal.cargo,
            "celular": objDataPersonal.celular,
            "direccion": objDataPersonal.direccion,
            "correo": objDataPersonal.correo,
            "idJefe": objDataPersonal.idJefe,
            "jefe": objDataPersonal.jefe,
            "idReemplazo": objDataPersonal.idReemplazo,
            "reemplazo": objDataPersonal.reemplazo,
            //"fotoPerfil": objDataPersonal.fotoPerfil,
            "latitud": objDataPersonal.latitud,
            "longitud": objDataPersonal.longitud,
            "adjunto": {
              "base64": objDataPersonal.adjunto?.base64,
              "nombre": objDataPersonal.adjunto?.nombre,
              "extension": objDataPersonal.adjunto?.extension
            }
          }
        )
      );

      if(response.statusCode != 200) {
        return ClientTypeResponse(succeeded: false, data: 'Error al actualizar los datos',errors: Errors(),message: '',statusCode: '001');
      }

      final rspVacacion = ClientTypeResponse.fromJson(response.body); 
      return rspVacacion;
    } catch(_) {
      return null;
    }
  }

}
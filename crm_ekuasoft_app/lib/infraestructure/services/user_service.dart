import 'dart:async';
import 'dart:io';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:device_imei/device_imei.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';

const storageClient = FlutterSecureStorage();

class UserService extends ChangeNotifier {
 
  final _deviceImeiPlugin = DeviceImei();
  DeviceInfo? deviceInfo;
  String? deviceImei;
  bool getPermission = false;
  String message = "Please allow permission request!";

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

  Future<String> getImei() async {
    String imeiFinal = '';
    var permission = await Permission.phone.status;

    if (permission.isDenied) {
      // Si está denegado, solicita el permiso
      permission = await Permission.phone.request();
    }

    DeviceInfo? dInfo = await _deviceImeiPlugin.getDeviceInfo();

    if (dInfo != null) {
      deviceInfo = dInfo;
    }

    if (Platform.isAndroid) {
      if (permission.isGranted) {
        String? imei = await _deviceImeiPlugin.getDeviceImei();
        if (imei != null) {
          getPermission = true;
          deviceImei = imei;
        }
      } else {
        PermissionStatus status = await Permission.phone.request();
        if (status == PermissionStatus.granted) {
          getPermission = false;
          getImei();
        } else {
          getPermission = false;
          message = "Permission not granted, please allow permission";
        }
      }
    } else {
      String? imei = await _deviceImeiPlugin.getDeviceImei();
      if (imei != null) {
        getPermission = true;
        deviceImei = imei;
      }
    }

    imeiFinal = deviceImei ?? '';

    return imeiFinal;
  }
}

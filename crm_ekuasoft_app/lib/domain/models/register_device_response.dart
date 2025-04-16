/*
import 'dart:convert';

class RegisterDeviceResponseModel {
    String jsonrpc;
    dynamic id;
    RegisterDeviceModel result;

    RegisterDeviceResponseModel({
        required this.jsonrpc,
        required this.id,
        required this.result,
    });

    factory RegisterDeviceResponseModel.fromJson(String str) => RegisterDeviceResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RegisterDeviceResponseModel.fromMap(Map<String, dynamic> json) => RegisterDeviceResponseModel(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: RegisterDeviceModel.fromJson(json["result"]),
    );

    Map<String, dynamic> toMap() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result.toJson(),
    };

}
*/

import 'dart:convert';
import 'package:crm_ekuasoft_app/domain/models/models.dart';

class RegisterDeviceResponseModel {
    String jsonrpc;
    dynamic id;
    RegisterDeviceModel result;

    RegisterDeviceResponseModel({
        required this.jsonrpc,
        required this.id,
        required this.result,
    });

    /*
    factory RegisterDeviceResponseModel.fromRawJson(String str) => RegisterDeviceResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory RegisterDeviceResponseModel.fromJson(Map<String, dynamic> json) => RegisterDeviceResponseModel(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: RegisterDeviceModel.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result.toJson(),
    };
    */

    factory RegisterDeviceResponseModel.fromJson(String str) => RegisterDeviceResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RegisterDeviceResponseModel.fromMap(Map<String, dynamic> json) => RegisterDeviceResponseModel(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: json["result"] != null ? RegisterDeviceModel.fromMap(json["result"]) 
          : RegisterDeviceModel(bearer: '', database: '', estado: 0, key: '', serverUrl: '', tocken: '', tockenValidDate: DateTime.now(), url: '', msmError: ''),
    );

    Map<String, dynamic> toMap() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result.toJson(),
    };
}

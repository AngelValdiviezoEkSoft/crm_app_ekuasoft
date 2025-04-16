import 'dart:convert';

import 'package:crm_ekuasoft_app/domain/domain.dart';

class ValidationTokenResponseModel {
    String jsonrpc;
    dynamic id;
    ValidationTokenModel result;

    ValidationTokenResponseModel({
        required this.jsonrpc,
        required this.id,
        required this.result,
    });

    factory ValidationTokenResponseModel.fromJson(String str) => ValidationTokenResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ValidationTokenResponseModel.fromMap(Map<String, dynamic> json) => ValidationTokenResponseModel(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: ValidationTokenModel.fromJson(json["result"]),
    );

    Map<String, dynamic> toMap() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result.toJson(),
    };
}

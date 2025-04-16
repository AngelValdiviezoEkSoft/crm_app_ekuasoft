
import 'dart:convert';
import 'package:crm_ekuasoft_app/domain/domain.dart';

class UsuarioListTypeResponse {
    UsuarioListTypeResponse({
      required this.succeeded,
      required this.message,
      required this.statusCode,
      required this.errors,
      required this.data,
    });

    bool succeeded;
    String message;
    String statusCode;
    Errors? errors;
    List<DatosPersonalesUserModel> data;

    factory UsuarioListTypeResponse.fromJson(String str) => UsuarioListTypeResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UsuarioListTypeResponse.fromMap(Map<String, dynamic> json) => UsuarioListTypeResponse(
        succeeded: json["succeeded"],
        message: json["message"],
        statusCode: json["statusCode"],
        errors: Errors.fromMap(json["errors"]),
        data: List<DatosPersonalesUserModel>.from(json["data"].map((x) => DatosPersonalesUserModel.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "succeeded": succeeded,
        "message": message,
        "statusCode": statusCode,
        "errors": errors!.toMap(),
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
    };
}

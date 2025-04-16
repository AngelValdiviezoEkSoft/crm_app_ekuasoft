
import 'dart:convert';

import 'package:crm_ekuasoft_app/domain/domain.dart';

class AdjuntosTypeResponse {
    AdjuntosTypeResponse({
      required this.succeeded,
      required this.message,
      required this.statusCode,
      required this.errors,
      required this.data,
    });

    bool succeeded;
    String message;
    String statusCode;
    Errors errors;
    List<AdjuntosType> data;

    factory AdjuntosTypeResponse.fromJson(String str) => AdjuntosTypeResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AdjuntosTypeResponse.fromMap(Map<String, dynamic> json) => AdjuntosTypeResponse(
        succeeded: json["succeeded"] ?? false,
        message: json["message"] ?? '',
        statusCode: json["statusCode"]?.toString() ?? '',
        errors: Errors.fromMap(json["errors"]),
        data: json["data"] != null ? List<AdjuntosType>.from(json["data"].map((x) => AdjuntosType.fromMap(x))) : [],
    );

    Map<String, dynamic> toMap() => {
        "succeeded": succeeded,
        "message": message,
        "statusCode": statusCode,
        "errors": errors.toMap(),
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
    };
}


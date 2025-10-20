import 'dart:convert';

class ResponseGenericModel {
    String jsonrpc;
    dynamic id;
    GenericModel result;

    ResponseGenericModel({
        required this.jsonrpc,
        required this.id,
        required this.result,
    });

    factory ResponseGenericModel.fromRawJson(String str) => ResponseGenericModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ResponseGenericModel.fromJson(Map<String, dynamic> json) => ResponseGenericModel(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: GenericModel.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result.toJson(),
    };
}

class GenericModel {
    int estado;
    String mensaje;

    GenericModel({
        required this.estado,
        required this.mensaje,
    });

    factory GenericModel.fromRawJson(String str) => GenericModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GenericModel.fromJson(Map<String, dynamic> json) => GenericModel(
        estado: json["estado"],
        mensaje: json["mensaje"],
    );

    Map<String, dynamic> toJson() => {
        "estado": estado,
        "mensaje": mensaje,
    };
}

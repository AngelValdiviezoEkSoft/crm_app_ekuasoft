import 'dart:convert';

class CierreActividadesResponseModel {
    String jsonrpc;
    dynamic id;
    ResultCierre result;

    CierreActividadesResponseModel({
        required this.jsonrpc,
        required this.id,
        required this.result,
    });

    factory CierreActividadesResponseModel.fromRawJson(String str) => CierreActividadesResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CierreActividadesResponseModel.fromJson(Map<String, dynamic> json) => CierreActividadesResponseModel(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: ResultCierre.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result.toJson(),
    };
}

class ResultCierre {
    int estado;
    String mensaje;

    ResultCierre({
        required this.estado,
        required this.mensaje,
    });

    factory ResultCierre.fromRawJson(String str) => ResultCierre.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ResultCierre.fromJson(Map<String, dynamic> json) => ResultCierre(
        estado: json["estado"],
        mensaje: json["mensaje"],
    );

    Map<String, dynamic> toJson() => {
        "estado": estado,
        "mensaje": mensaje,
    };
}

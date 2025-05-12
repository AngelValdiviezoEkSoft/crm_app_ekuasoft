import 'dart:convert';
/*
class CambioClaveResponseModel {
    int estado;    
    String mensaje;

    CambioClaveResponseModel({
      required this.estado,      
      required this.mensaje
    });

    factory CambioClaveResponseModel.fromJson(String str) => CambioClaveResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CambioClaveResponseModel.fromMap(Map<String, dynamic> json) => CambioClaveResponseModel(
      estado: json["estado"] ?? '',      
      mensaje: json["mensaje"] ?? ''
    );

    factory CambioClaveResponseModel.fromMap2(Map<String, dynamic> json) {

      return CambioClaveResponseModel(        
        estado: json["estado"],        
        mensaje: json["mensaje"] ?? ''
      );
    }

    Map<String, dynamic> toJson2() {
    return {
      'estado': estado,      
      'mensaje': mensaje
    };
  }

    Map<String, dynamic> toMap() => {
      'estado': estado,      
      'mensaje': mensaje
    };
}
*/

class CambioClaveResponseModel {
    String jsonrpc;
    dynamic id;
    CambioClaveResponseResult result;

    CambioClaveResponseModel({
        required this.jsonrpc,
        required this.id,
        required this.result,
    });

    factory CambioClaveResponseModel.fromRawJson(String str) => CambioClaveResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CambioClaveResponseModel.fromJson(Map<String, dynamic> json) => CambioClaveResponseModel(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: CambioClaveResponseResult.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result.toJson(),
    };
}

class CambioClaveResponseResult {
    int estado;
    String mensaje;

    CambioClaveResponseResult({
        required this.estado,
        required this.mensaje,
    });

    factory CambioClaveResponseResult.fromRawJson(String str) => CambioClaveResponseResult.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CambioClaveResponseResult.fromJson(Map<String, dynamic> json) => CambioClaveResponseResult(
        estado: json["estado"],
        mensaje: json["mensaje"],
    );

    Map<String, dynamic> toJson() => {
        "estado": estado,
        "mensaje": mensaje,
    };
}

import 'dart:convert';

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

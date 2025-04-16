import 'dart:convert';

class ClientModelResponse {
    ClientModelResponse({
      required this.id,
      required this.primerNombre,
      required this.segundoNombre,
      required this.primerApellido,
      required this.segundoApellido,
      required this.direccion,
      required this.estado,
      required this.numIdentificacion,
      required this.codigoCli
    });

    int id;
    String primerNombre;
    String segundoNombre;
    String primerApellido;
    String segundoApellido;
    String direccion;
    String estado;
    String numIdentificacion;
    String codigoCli;

    factory ClientModelResponse.fromJson(String str) => ClientModelResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ClientModelResponse.fromMap(Map<String, dynamic> json) => ClientModelResponse(        
        id: json["id"] ?? '',
        primerNombre: json["primerNombre"] ?? '',
        segundoNombre: json["segundoNombre"] ?? '',
        primerApellido: json["primerApellido"] ?? '',
        segundoApellido: json["segundoApellido"] ?? '',
        direccion: json["direccion"] ?? '',
        estado: json["estado"] ?? '',
        numIdentificacion: json["numIdentificacion"] ?? '',
        codigoCli: json["codigoCli"] ?? ''
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "primerNombre": primerNombre,
        "segundoNombre": segundoNombre,
        "primerApellido": primerApellido,
        "segundoApellido": segundoApellido,
        "direccion": direccion,
        "estado": estado,
        "numIdentificacion": numIdentificacion,
        "codigoCli": codigoCli
    };
}

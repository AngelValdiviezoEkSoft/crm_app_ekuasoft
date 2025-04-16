import 'dart:convert';

class ValidationTokenModel {
    int estado;
    String mensaje;
    DateTime tockenValidDate;

    ValidationTokenModel({
        required this.estado,
        required this.mensaje,
        required this.tockenValidDate,
    });

    factory ValidationTokenModel.fromJson(String str) => ValidationTokenModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ValidationTokenModel.fromMap(Map<String, dynamic> json) => ValidationTokenModel(
        estado: json["estado"],
        mensaje: json["mensaje"],
        tockenValidDate: DateTime.parse(json["tocken_valid_date"]),
    );

    Map<String, dynamic> toMap() => {
        "estado": estado,
        "mensaje": mensaje,
        "tocken_valid_date": tockenValidDate.toIso8601String(),
    };
}

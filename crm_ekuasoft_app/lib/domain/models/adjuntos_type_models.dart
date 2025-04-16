
import 'dart:convert';

class AdjuntosType {
    AdjuntosType({
      required this.id,
      required this.categoria,
      required this.rutaAcceso,
      required this.nombreImagen,
      required this.fechaCreacion,
      //required this.tamanioImagen
    });

    String id;
    int categoria;
    String rutaAcceso;
    String nombreImagen;
    DateTime fechaCreacion;
    //String tamanioImagen;

    factory AdjuntosType.fromJson(String str) => AdjuntosType.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AdjuntosType.fromMap(Map<String, dynamic> json) => AdjuntosType(
      id: json["id"] ?? '',
      categoria: json["categoria"] ?? 0, //int.parse(json["categoria"] ?? '0'),
      rutaAcceso: json["rutaAcceso"] ?? '',
      nombreImagen: json["nombreImagen"] ?? '',
      fechaCreacion:  DateTime.parse(json["fechaCreacion"] ?? DateTime.now().toString()),
      //tamanioImagen: json["tamanioImagen"],
    );

    Map<String, dynamic> toMap() => {
      "id": id,
      "categoria": categoria,
      "rutaAcceso": rutaAcceso,
      "nombreImagen": nombreImagen,
      "fechaCreacion": fechaCreacion,
      //"tamanioImagen": tamanioImagen,
    };
}
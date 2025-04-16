
import 'dart:convert';

class DatosPersonalesUserModel {
    DatosPersonalesUserModel({
        required this.id,
        required this.nombres,
        required this.apellidos,
        required this.codUdn,
        required this.udn,
        required this.codArea,
        required this.area,
        required this.codScc,
        required this.scc,
        required this.colaborador,
        required this.cedula,
        required this.codigo,
        required this.cargo,
        required this.celular,
        required this.direccion,
        required this.correo,
        //required this.lstLocalidad,
        required this.idJefe,
        required this.jefe,
        this.idReemplazo,
        required this.reemplazo,
        required this.fotoPerfil,
        required this.latitud,
        required this.longitud,
        this.adjunto,
        required this.facialPersonId
    });

    String id;
    String nombres;
    String apellidos;
    String codUdn;
    String udn;
    String codArea;
    String area;
    String codScc;
    String scc;
    String colaborador;
    String cedula;
    String codigo;
    String cargo;
    String celular;
    String direccion;
    String correo;
    //List<LocalidadType> lstLocalidad;
    String idJefe;
    String jefe;
    dynamic idReemplazo;
    String reemplazo;
    String fotoPerfil;
    double latitud;
    double longitud;
    dynamic adjunto;
    String facialPersonId;

    factory DatosPersonalesUserModel.fromJson(String str) => DatosPersonalesUserModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DatosPersonalesUserModel.fromMap(Map<String, dynamic> json) => DatosPersonalesUserModel(
        id: json["id"] ?? '',
        codUdn: json["codUdn"] ?? '',
        nombres: json["nombres"] ?? '',
        apellidos: json["apellidos"] ?? '',
        udn: json["udn"] ?? '',
        codArea: json["codArea"] ?? '',
        area: json["area"] ?? '',
        codScc: json["codScc"] ?? '',
        scc: json["scc"] ?? '',
        colaborador: json["colaborador"] ?? '',
        cedula: json["cedula"] ?? '',
        codigo: json["codigo"] ?? '',
        cargo: json["cargo"] ?? '',
        celular: json["celular"] ?? '',
        direccion: json["direccion"] ?? '',
        correo: json["correo"] ?? '',
        //lstLocalidad: json["lstLocalidad"] != null ? List<LocalidadType>.from(json["lstLocalidad"].map((x) => LocalidadType.fromMap(x))) : [],
        idJefe: json["idJefe"] ?? '',
        jefe: json["jefe"] ?? '',
        idReemplazo: json["idReemplazo"],
        reemplazo: json["reemplazo"] ?? '',
        fotoPerfil: json["fotoPerfil"] ?? '',
        latitud: json["latitud"]?.toDouble() ?? 0.0,
        longitud: json["longitud"]?.toDouble() ?? 0.0,
        adjunto: json["adjunto"],
        facialPersonId: json["facialPersonId"] ?? ''
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "codUdn": codUdn,
        "udn": udn,
        "codArea": codArea,
        "area": area,
        "codScc": codScc,
        "scc": scc,
        "colaborador": colaborador,
        "cedula": cedula,
        "codigo": codigo,
        "cargo": cargo,
        "celular": celular,
        "direccion": direccion,
        "correo": correo,
        //"lstLocalidad": List<dynamic>.from(lstLocalidad.map((x) => x.toMap())),
        "idJefe": idJefe,
        "jefe": jefe,
        "idReemplazo": idReemplazo,
        "reemplazo": reemplazo,
        "fotoPerfil": fotoPerfil,
        "latitud": latitud,
        "longitud": longitud,
        "adjunto": adjunto,
        "facialPersonId": facialPersonId
    };
}

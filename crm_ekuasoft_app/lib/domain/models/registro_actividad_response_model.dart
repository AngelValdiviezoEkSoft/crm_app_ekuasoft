import 'dart:convert';

class ActividadRegistroResponseModel {
    String jsonrpc;
    dynamic id;
    ResultActividad result;

    ActividadRegistroResponseModel({
        required this.jsonrpc,
        required this.id,
        required this.result,
    });

    factory ActividadRegistroResponseModel.fromRawJson(String str) => ActividadRegistroResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ActividadRegistroResponseModel.fromJson(Map<String, dynamic> json) => ActividadRegistroResponseModel(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: ResultActividad.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result.toJson(),
    };
}

class ResultActividad {
    int estado;
    String mensaje;
    List<Datum> data;

    ResultActividad({
        required this.estado,
        required this.mensaje,
        required this.data,
    });

    factory ResultActividad.fromRawJson(String str) => ResultActividad.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ResultActividad.fromJson(Map<String, dynamic> json) => ResultActividad(
        estado: json["estado"],
        mensaje: json["mensaje"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "estado": estado,
        "mensaje": mensaje,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int id;
    Id activityTypeId;
    DateTime dateDeadline;
    int resId;
    String resModel;
    Id userId;

    Datum({
        required this.id,
        required this.activityTypeId,
        required this.dateDeadline,
        required this.resId,
        required this.resModel,
        required this.userId,
    });

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        activityTypeId: Id.fromJson(json["activity_type_id"]),
        dateDeadline: DateTime.parse(json["date_deadline"]),
        resId: json["res_id"],
        resModel: json["res_model"],
        userId: Id.fromJson(json["user_id"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "activity_type_id": activityTypeId.toJson(),
        "date_deadline": "${dateDeadline.year.toString().padLeft(4, '0')}-${dateDeadline.month.toString().padLeft(2, '0')}-${dateDeadline.day.toString().padLeft(2, '0')}",
        "res_id": resId,
        "res_model": resModel,
        "user_id": userId.toJson(),
    };
}

class Id {
    int id;
    String name;

    Id({
        required this.id,
        required this.name,
    });

    factory Id.fromRawJson(String str) => Id.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Id.fromJson(Map<String, dynamic> json) => Id(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}

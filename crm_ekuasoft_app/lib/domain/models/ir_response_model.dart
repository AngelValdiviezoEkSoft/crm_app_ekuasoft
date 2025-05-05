import 'dart:convert';

class IrResponseModel {
    String jsonrpc;
    dynamic id;
    ResultIr result;

    IrResponseModel({
        required this.jsonrpc,
        required this.id,
        required this.result,
    });

    factory IrResponseModel.fromRawJson(String str) => IrResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory IrResponseModel.fromJson(Map<String, dynamic> json) => IrResponseModel(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: ResultIr.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result.toJson(),
    };
}

class ResultIr {
    int estado;
    DataIr data;

    ResultIr({
        required this.estado,
        required this.data,
    });

    factory ResultIr.fromRawJson(String str) => ResultIr.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ResultIr.fromJson(Map<String, dynamic> json) => ResultIr(
        estado: json["estado"],
        data: DataIr.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "estado": estado,
        "data": data.toJson(),
    };
}

class DataIr {
    IrModel irModel;

    DataIr({
        required this.irModel,
    });

    factory DataIr.fromRawJson(String str) => DataIr.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DataIr.fromJson(Map<String, dynamic> json) => DataIr(
        irModel: IrModel.fromJson(json["ir.model"]),
    );

    Map<String, dynamic> toJson() => {
        "ir.model": irModel.toJson(),
    };
}

class IrModel {
    int length;
    FieldsIr fields;
    List<DatumIr> data;

    IrModel({
        required this.length,
        required this.fields,
        required this.data,
    });

    factory IrModel.fromRawJson(String str) => IrModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory IrModel.fromJson(Map<String, dynamic> json) => IrModel(
        length: json["length"],
        fields: FieldsIr.fromJson(json["fields"]),
        data: List<DatumIr>.from(json["data"].map((x) => DatumIr.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "length": length,
        "fields": fields.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DatumIr {
    int id;
    String model;

    DatumIr({
        required this.id,
        required this.model,
    });

    factory DatumIr.fromRawJson(String str) => DatumIr.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DatumIr.fromJson(Map<String, dynamic> json) => DatumIr(
        id: json["id"],
        model: json["model"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "model": model,
    };
}

class FieldsIr {
    String id;
    String model;

    FieldsIr({
        required this.id,
        required this.model,
    });

    factory FieldsIr.fromRawJson(String str) => FieldsIr.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory FieldsIr.fromJson(Map<String, dynamic> json) => FieldsIr(
        id: json["id"],
        model: json["model"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "model": model,
    };
}

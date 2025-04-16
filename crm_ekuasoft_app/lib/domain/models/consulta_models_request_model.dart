import 'dart:convert';

class ConsultaModelRequestModel {
    String jsonrpc;
    ParamsConsultaModel params;

    ConsultaModelRequestModel({
        required this.jsonrpc,
        required this.params,
    });

    factory ConsultaModelRequestModel.fromRawJson(String str) => ConsultaModelRequestModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ConsultaModelRequestModel.fromJson(Map<String, dynamic> json) => ConsultaModelRequestModel(
        jsonrpc: json["jsonrpc"],
        params: ParamsConsultaModel.fromJson(json["params"]),
    );

    Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "params": params.toJson(),
    };
}

class ParamsConsultaModel {
    String key;
    String tocken;
    String imei;
    int uid;
    int company;
    String bearer;
    DateTime tockenValidDate;
    List<Model> models;

    ParamsConsultaModel({
        required this.key,
        required this.tocken,
        required this.imei,
        required this.uid,
        required this.company,
        required this.bearer,
        required this.tockenValidDate,
        required this.models,
    });

    factory ParamsConsultaModel.fromRawJson(String str) => ParamsConsultaModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ParamsConsultaModel.fromJson(Map<String, dynamic> json) => ParamsConsultaModel(
        key: json["key"],
        tocken: json["tocken"],
        imei: json["imei"],
        uid: json["uid"],
        company: json["company"],
        bearer: json["bearer"],
        tockenValidDate: DateTime.parse(json["tocken_valid_date"]),
        models: List<Model>.from(json["models"].map((x) => Model.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "tocken": tocken,
        "imei": imei,
        "uid": uid,
        "company": company,
        "bearer": bearer,
        "tocken_valid_date": tockenValidDate.toIso8601String(),
        "models": List<dynamic>.from(models.map((x) => x.toJson())),
    };
}

class Model {
    String model;

    Model({
        required this.model,
    });

    factory Model.fromRawJson(String str) => Model.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Model.fromJson(Map<String, dynamic> json) => Model(
        model: json["model"],
    );

    Map<String, dynamic> toJson() => {
        "model": model,
    };
}

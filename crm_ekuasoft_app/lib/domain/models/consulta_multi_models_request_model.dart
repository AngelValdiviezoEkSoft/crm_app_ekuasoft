import 'dart:convert';

class ConsultaMultiModelRequestModel {
    String jsonrpc;
    ParamsMultiModels params;

    ConsultaMultiModelRequestModel({
        required this.jsonrpc,
        required this.params,
    });

    factory ConsultaMultiModelRequestModel.fromRawJson(String str) => ConsultaMultiModelRequestModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ConsultaMultiModelRequestModel.fromJson(Map<String, dynamic> json) => ConsultaMultiModelRequestModel(
        jsonrpc: json["jsonrpc"],
        params: ParamsMultiModels.fromJson(json["params"]),
    );

    Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "params": params.toJson(),
    };
}

class ParamsMultiModels {
    String key;
    String tocken;
    String imei;
    int uid;
    int company;
    String bearer;
    DateTime tockenValidDate;
    List<MultiModel> models;

    ParamsMultiModels({
        required this.key,
        required this.tocken,
        required this.imei,
        required this.uid,
        required this.company,
        required this.bearer,
        required this.tockenValidDate,
        required this.models,
    });

    factory ParamsMultiModels.fromRawJson(String str) => ParamsMultiModels.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ParamsMultiModels.fromJson(Map<String, dynamic> json) => ParamsMultiModels(
        key: json["key"],
        tocken: json["tocken"],
        imei: json["imei"],
        uid: json["uid"],
        company: json["company"],
        bearer: json["bearer"],
        tockenValidDate: DateTime.parse(json["tocken_valid_date"]),
        models: List<MultiModel>.from(json["models"].map((x) => MultiModel.fromJson(x))),
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

class MultiModel {
    String model;

    MultiModel({
        required this.model,
    });

    factory MultiModel.fromRawJson(String str) => MultiModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MultiModel.fromJson(Map<String, dynamic> json) => MultiModel(
        model: json["model"],
    );

    Map<String, dynamic> toJson() => {
        "model": model,
    };
}

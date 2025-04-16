import 'dart:convert';

class PaisResponseModel {
    String jsonrpc;
    dynamic id;
    PaisModel result;

    PaisResponseModel({
        required this.jsonrpc,
        required this.id,
        required this.result,
    });

    factory PaisResponseModel.fromRawJson(String str) => PaisResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PaisResponseModel.fromJson(Map<String, dynamic> json) => PaisResponseModel(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: PaisModel.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result.toJson(),
    };
}

class PaisModel {
    int estado;
    DataPais data;

    PaisModel({
        required this.estado,
        required this.data,
    });

    factory PaisModel.fromRawJson(String str) => PaisModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PaisModel.fromJson(Map<String, dynamic> json) => PaisModel(
        estado: json["estado"],
        data: DataPais.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "estado": estado,
        "data": data.toJson(),
    };
}

class DataPais {
    ResCountry resCountry;

    DataPais({
        required this.resCountry,
    });

    factory DataPais.fromRawJson(String str) => DataPais.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DataPais.fromJson(Map<String, dynamic> json) => DataPais(
        resCountry: ResCountry.fromJson(json["res.country"]),
    );

    Map<String, dynamic> toJson() => {
        "res.country": resCountry.toJson(),
    };
}

class ResCountry {
    int length;
    FieldsCountry fields;
    List<DatumCountry> data;

    ResCountry({
        required this.length,
        required this.fields,
        required this.data,
    });

    factory ResCountry.fromRawJson(String str) => ResCountry.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ResCountry.fromJson(Map<String, dynamic> json) => ResCountry(
        length: json["length"],
        fields: FieldsCountry.fromJson(json["fields"]),
        data: List<DatumCountry>.from(json["data"].map((x) => DatumCountry.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "length": length,
        "fields": fields.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DatumCountry {
    int id;
    String code;
    String name;
    List<StateIdCountry> stateIds;

    DatumCountry({
        required this.id,
        required this.code,
        required this.name,
        required this.stateIds,
    });

    factory DatumCountry.fromRawJson(String str) => DatumCountry.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DatumCountry.fromJson(Map<String, dynamic> json) => DatumCountry(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        stateIds: List<StateIdCountry>.from(json["state_ids"].map((x) => StateIdCountry.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "state_ids": List<dynamic>.from(stateIds.map((x) => x.toJson())),
    };
}

class StateIdCountry {
    int id;
    String name;

    StateIdCountry({
        required this.id,
        required this.name,
    });

    factory StateIdCountry.fromRawJson(String str) => StateIdCountry.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory StateIdCountry.fromJson(Map<String, dynamic> json) => StateIdCountry(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}

class FieldsCountry {
    String code;
    String name;
    String stateIds;

    FieldsCountry({
        required this.code,
        required this.name,
        required this.stateIds,
    });

    factory FieldsCountry.fromRawJson(String str) => FieldsCountry.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory FieldsCountry.fromJson(Map<String, dynamic> json) => FieldsCountry(
        code: json["code"],
        name: json["name"],
        stateIds: json["state_ids"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "state_ids": stateIds,
    };
}

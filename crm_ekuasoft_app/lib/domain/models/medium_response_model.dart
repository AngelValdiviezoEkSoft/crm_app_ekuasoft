import 'dart:convert';

class MediumResponseModel {
    String jsonrpc;
    dynamic id;
    Result result;

    MediumResponseModel({
        required this.jsonrpc,
        required this.id,
        required this.result,
    });

    factory MediumResponseModel.fromJson(String str) => MediumResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory MediumResponseModel.fromMap(Map<String, dynamic> json) => MediumResponseModel(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: Result.fromJson(json["result"]),
    );

    Map<String, dynamic> toMap() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result.toMap(),
    };
}

class Result {
    int estado;
    Data data;

    Result({
        required this.estado,
        required this.data,
    });

    factory Result.fromJson(String str) => Result.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Result.fromMap(Map<String, dynamic> json) => Result(
        estado: json["estado"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "estado": estado,
        "data": data.toMap(),
    };
}

class Data {
    UtmMedium utmMedium;

    Data({
        required this.utmMedium,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        utmMedium: UtmMedium.fromJson(json["utm.medium"]),
    );

    Map<String, dynamic> toMap() => {
        "utm.medium": utmMedium.toMap(),
    };
}

class UtmMedium {
    int length;
    Fields fields;
    List<Datum> data;

    UtmMedium({
        required this.length,
        required this.fields,
        required this.data,
    });

    factory UtmMedium.fromJson(String str) => UtmMedium.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UtmMedium.fromMap(Map<String, dynamic> json) => UtmMedium(
        length: json["length"],
        fields: Fields.fromJson(json["fields"]),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toMap() => {
        "length": length,
        "fields": fields.toMap(),
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
    };
}

class Datum {
    int id;
    String name;

    Datum({
        required this.id,
        required this.name,
    });

    factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
    };
}

class Fields {
    String name;

    Fields({
        required this.name,
    });

    factory Fields.fromJson(String str) => Fields.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Fields.fromMap(Map<String, dynamic> json) => Fields(
        name: json["name"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
    };
}

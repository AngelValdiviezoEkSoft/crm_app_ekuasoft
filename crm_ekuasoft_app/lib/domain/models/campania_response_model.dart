import 'dart:convert';

class CampaniaResponseModel {
    String jsonrpc;
    dynamic id;
    CampaniaModel result;

    CampaniaResponseModel({
        required this.jsonrpc,
        required this.id,
        required this.result,
    });

    factory CampaniaResponseModel.fromJson(String str) => CampaniaResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CampaniaResponseModel.fromMap(Map<String, dynamic> json) => CampaniaResponseModel(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: CampaniaModel.fromJson(json["result"]),
    );

    Map<String, dynamic> toMap() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result.toMap(),
    };
}

class CampaniaModel {
    int estado;
    DataCampania data;

    CampaniaModel({
        required this.estado,
        required this.data,
    });

    factory CampaniaModel.fromJson(String str) => CampaniaModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CampaniaModel.fromMap(Map<String, dynamic> json) => CampaniaModel(
        estado: json["estado"],
        data: DataCampania.fromJson(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "estado": estado,
        "data": data.toMap(),
    };
}

class DataCampania {
    UtmCampaign utmCampaign;

    DataCampania({
        required this.utmCampaign,
    });

    factory DataCampania.fromJson(String str) => DataCampania.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DataCampania.fromMap(Map<String, dynamic> json) => DataCampania(
        utmCampaign: UtmCampaign.fromJson(json["utm.campaign"]),
    );

    Map<String, dynamic> toMap() => {
        "utm.campaign": utmCampaign.toMap(),
    };
}

class UtmCampaign {
    int length;
    Fields fields;
    List<DatumCamp> data;

    UtmCampaign({
        required this.length,
        required this.fields,
        required this.data,
    });

    factory UtmCampaign.fromJson(String str) => UtmCampaign.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UtmCampaign.fromMap(Map<String, dynamic> json) => UtmCampaign(
        length: json["length"],
        fields: Fields.fromJson(json["fields"]),
        data: List<DatumCamp>.from(json["data"].map((x) => DatumCamp.fromJson(x))),
    );

    Map<String, dynamic> toMap() => {
        "length": length,
        "fields": fields.toMap(),
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
    };
}

class DatumCamp {
    int id;
    bool active;
    String name;
    String title;

    DatumCamp({
        required this.id,
        required this.active,
        required this.name,
        required this.title,
    });

    factory DatumCamp.fromJson(String str) => DatumCamp.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DatumCamp.fromMap(Map<String, dynamic> json) => DatumCamp(
        id: json["id"],
        active: json["active"],
        name: json["name"],
        title: json["title"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "active": active,
        "name": name,
        "title": title,
    };
}

class Fields {
    String active;
    String name;
    String title;

    Fields({
        required this.active,
        required this.name,
        required this.title,
    });

    factory Fields.fromJson(String str) => Fields.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Fields.fromMap(Map<String, dynamic> json) => Fields(
        active: json["active"],
        name: json["name"],
        title: json["title"],
    );

    Map<String, dynamic> toMap() => {
        "active": active,
        "name": name,
        "title": title,
    };
}

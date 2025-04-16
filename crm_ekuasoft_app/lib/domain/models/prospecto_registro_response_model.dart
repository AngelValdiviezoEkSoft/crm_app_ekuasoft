import 'dart:convert';
/*
class ProspectoRegistroResponseModel {
    String mensaje;
    String jsonrpc;
    dynamic id;
    ProspectoRegistroModel result;

    ProspectoRegistroResponseModel({
        required this.jsonrpc,
        required this.id,
        required this.result,
        required this.mensaje,
    });

    factory ProspectoRegistroResponseModel.fromJson(String str) => ProspectoRegistroResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ProspectoRegistroResponseModel.fromMap(Map<String, dynamic> json) => ProspectoRegistroResponseModel(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: ProspectoRegistroModel.fromMap(json["result"]),
        mensaje: ''
    );

    Map<String, dynamic> toMap() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result.toJson(),
    };
}

class ProspectoRegistroModel {
    int estado;
    String mensaje;
    List<DatumProspectoRegistro> data; //DESCOMENTAR AEVG

    ProspectoRegistroModel({
        required this.estado,
        required this.mensaje,
        required this.data,
    });

    factory ProspectoRegistroModel.fromJson(String str) => ProspectoRegistroModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ProspectoRegistroModel.fromMap(Map<String, dynamic> json) => ProspectoRegistroModel(
        estado: json["estado"],
        mensaje: json["mensaje"],
        data: List<DatumProspectoRegistro>.from(json["data"].map((x) => DatumProspectoRegistro.fromJson(x))),
    );

    Map<String, dynamic> toMap() => {
        "estado": estado,
        "mensaje": mensaje,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DatumProspectoRegistro {
    int id;
    List<dynamic> activityIds;
    CampaignIdPrsp campaignId;
    CampaignIdPrsp countryId;
    DateTime dateOpen;
    int dayClose;
    CampaignIdPrsp lostReasonId;
    CampaignIdPrsp mediumId;
    String name;
    CampaignIdPrsp partnerId;
    String phone;
    String priority;
    CampaignIdPrsp sourceId;
    StageIdPrsp stageId;
    CampaignIdPrsp stateId;
    List<dynamic> tagIds;
    CampaignIdPrsp title;
    String type;
    CampaignIdPrsp userId;

    DatumProspectoRegistro({
        required this.id,
        required this.activityIds,
        required this.campaignId,
        required this.countryId,
        required this.dateOpen,
        required this.dayClose,
        required this.lostReasonId,
        required this.mediumId,
        required this.name,
        required this.partnerId,
        required this.phone,
        required this.priority,
        required this.sourceId,
        required this.stageId,
        required this.stateId,
        required this.tagIds,
        required this.title,
        required this.type,
        required this.userId
    });

    factory DatumProspectoRegistro.fromJson(String str) => DatumProspectoRegistro.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DatumProspectoRegistro.fromMap(Map<String, dynamic> json) => DatumProspectoRegistro(
        id: json["id"],
        activityIds: json["activity_ids"] != null ? List<dynamic>.from(json["activity_ids"].map((x) => x)) : [],
        campaignId: json["campaign_id"] != null ? CampaignIdPrsp.fromJson(json["campaign_id"]) : CampaignIdPrsp(id: 0, name: ''),
        countryId: json["country_id"] != null ? CampaignIdPrsp.fromJson(json["country_id"]) : CampaignIdPrsp(id: 0, name: ''),
        dateOpen: json["date_open"] != null ? DateTime.parse(json["date_open"]) : DateTime.now(),
        dayClose: json["day_close"] ?? 0,
        lostReasonId: json["lost_reason_id"] != null ? CampaignIdPrsp.fromJson(json["lost_reason_id"]) : CampaignIdPrsp(id: 0, name: ''),
        mediumId: json["medium_id"] != null ? CampaignIdPrsp.fromJson(json["medium_id"]) : CampaignIdPrsp(id: 0, name: ''),
        name: json["name"] ?? '',
        partnerId: json["partner_id"] != null ? CampaignIdPrsp.fromJson(json["partner_id"]) : CampaignIdPrsp(id: 0, name: ''),
        phone: json["phone"] ?? '',
        priority: json["priority"] ?? '',
        sourceId: json["source_id"] != null ? CampaignIdPrsp.fromJson(json["source_id"]) : CampaignIdPrsp(id: 0, name: ''),
        stageId: json["stage_id"] != null ? StageIdPrsp.fromJson(json["stage_id"]) : StageIdPrsp(id: 0, name: ''),
        stateId: json["state_id"] != null ? CampaignIdPrsp.fromJson(json["state_id"]) : CampaignIdPrsp(id: 0, name: ''),
        tagIds: json["tag_ids"] != null ? List<dynamic>.from(json["tag_ids"].map((x) => x)) : [],
        title: json["title"] != null ? CampaignIdPrsp.fromJson(json["title"]) : CampaignIdPrsp(id: 0, name: ''),
        type: json["type"] ?? '',
        userId: json["user_id"] != null ? CampaignIdPrsp.fromJson(json["user_id"]) : CampaignIdPrsp(id: 0, name: ''),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "activity_ids": List<dynamic>.from(activityIds.map((x) => x)),
        "campaign_id": campaignId.toJson(),
        "country_id": countryId.toJson(),
        "date_open": dateOpen.toIso8601String(),
        "day_close": dayClose,
        "lost_reason_id": lostReasonId.toJson(),
        "medium_id": mediumId.toJson(),
        "name": name,
        "partner_id": partnerId.toJson(),
        "phone": phone,
        "priority": priority,
        "source_id": sourceId.toJson(),
        "stage_id": stageId.toJson(),
        "state_id": stateId.toJson(),
        "tag_ids": List<dynamic>.from(tagIds.map((x) => x)),
        "title": title.toJson(),
        "type": type,
        "user_id": userId.toJson(),
    };
}

class CampaignIdPrsp {
  int id;
    String name;

    CampaignIdPrsp({
        required this.id,
        required this.name,
    });

    factory CampaignIdPrsp.fromJson(String str) => CampaignIdPrsp.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CampaignIdPrsp.fromMap(Map<String, dynamic> json) => CampaignIdPrsp(
      id: json["id"] ?? 0,
        name: json["name"] ?? '',
    );

    Map<String, dynamic> toMap() => {
      "id": id,
      "name": name,
    };
}

class StageIdPrsp {
    int id;
    String name;

    StageIdPrsp({
        required this.id,
        required this.name,
    });

    factory StageIdPrsp.fromJson(String str) => StageIdPrsp.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory StageIdPrsp.fromMap(Map<String, dynamic> json) => StageIdPrsp(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
    };
}
*/

class ProspectoRegistroResponseModel {
  String mensaje;
    String jsonrpc;
    dynamic id;
    ProspectoRegistroModel result;

    ProspectoRegistroResponseModel({
        required this.jsonrpc,
        required this.id,
        required this.result,
        required this.mensaje
    });

    factory ProspectoRegistroResponseModel.fromRawJson(String str) => ProspectoRegistroResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ProspectoRegistroResponseModel.fromJson(Map<String, dynamic> json) => ProspectoRegistroResponseModel(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: ProspectoRegistroModel.fromJson(json["result"]),
        mensaje: ''
    );

    Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result.toJson(),
        "mensaje": mensaje
    };
}

class ProspectoRegistroModel {
    int estado;
    String mensaje;
    List<DatumProspectoRegistro> data;

    ProspectoRegistroModel({
        required this.estado,
        required this.mensaje,
        required this.data,
    });

    factory ProspectoRegistroModel.fromRawJson(String str) => ProspectoRegistroModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ProspectoRegistroModel.fromJson(Map<String, dynamic> json) => ProspectoRegistroModel(
        estado: json["estado"],
        mensaje: json["mensaje"],
        data: List<DatumProspectoRegistro>.from(json["data"].map((x) => DatumProspectoRegistro.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "estado": estado,
        "mensaje": mensaje,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DatumProspectoRegistro {
    int? id;
    List<dynamic> activityIds;
    DataCombos? campaignId;
    String? contactName;
    DataCombos? countryId;
    DateTime dateOpen;
    double? dayClose;
    String? description;
    String? emailFrom;
    double? expectedRevenue;
    DataCombos? lostReasonId;
    DataCombos? mediumId;
    String? name;
    DataCombos? partnerId;
    String? partnerName;
    String? phone;
    String? priority;
    DataCombos? sourceId;
    DataCombos? stageId;
    DataCombos? stateId;
    String? street;
    List<dynamic> tagIds;
    DataCombos? title;
    String? type;
    DataCombos? userId;

    DatumProspectoRegistro({
        required this.id,
        required this.activityIds,
        required this.campaignId,
        required this.contactName,
        required this.countryId,
        required this.dateOpen,
        required this.dayClose,
        required this.description,
        required this.emailFrom,
        required this.expectedRevenue,
        required this.lostReasonId,
        required this.mediumId,
        required this.name,
        required this.partnerId,
        required this.partnerName,
        required this.phone,
        required this.priority,
        required this.sourceId,
        required this.stageId,
        required this.stateId,
        required this.street,
        required this.tagIds,
        required this.title,
        required this.type,
        required this.userId,
    });

    factory DatumProspectoRegistro.fromRawJson(String str) => DatumProspectoRegistro.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DatumProspectoRegistro.fromJson(Map<String, dynamic> json) => DatumProspectoRegistro(
        id: json["id"] ?? 0,
        activityIds: List<dynamic>.from(json["activity_ids"].map((x) => x)),
        campaignId: json["campaign_id"] != null ? DataCombos.fromJson(json["campaign_id"]) : DataCombos(id: 0, name: ''),
        contactName: json["contact_name"] ?? '',
        countryId: json["country_id"] != null ? DataCombos.fromJson(json["country_id"]) : DataCombos(id: 0, name: ''),
        dateOpen: json["date_open"] != null ? DateTime.parse(json["date_open"]) : DateTime.now(),
        dayClose: json["day_close"] ?? 0,
        description: json["description"] ?? '',
        emailFrom: json["email_from"] ?? '',
        expectedRevenue: json["expected_revenue"] ?? 0,
        lostReasonId: json["lost_reason_id"] != null ? DataCombos.fromJson(json["lost_reason_id"]) : DataCombos(id: 0, name: ''),
        mediumId: json["medium_id"] != null ? DataCombos.fromJson(json["medium_id"]) : DataCombos(id: 0, name: ''),
        name: json["name"] ?? '',
        partnerId: json["partner_id"] != null ? DataCombos.fromJson(json["partner_id"]) : DataCombos(id: 0, name: ''),
        partnerName: json["partner_name"] ?? '',
        phone: json["phone"] ?? '',
        priority: json["priority"] ?? '',
        sourceId: json["source_id"] != null ? DataCombos.fromJson(json["source_id"]) : DataCombos(id: 0, name: ''),
        stageId: json["stage_id"] != null ? DataCombos.fromJson(json["stage_id"]) : DataCombos(id: 0, name: ''),
        stateId: json["state_id"] != null ? DataCombos.fromJson(json["state_id"]) : DataCombos(id: 0, name: ''),
        street: json["street"] ?? '',
        tagIds: json["tag_ids"] != null ? List<dynamic>.from(json["tag_ids"].map((x) => x)) : [],
        title: json["title"] != null ? DataCombos.fromJson(json["title"]) : DataCombos(id: 0, name: ''),
        type: json["type"] ?? '',
        userId: json["user_id"] != null ? DataCombos.fromJson(json["user_id"]) : DataCombos(id: 0, name: ''),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "activity_ids": List<dynamic>.from(activityIds.map((x) => x)),
        "campaign_id": campaignId!.toJson(),
        "contact_name": contactName,
        "country_id": countryId!.toJson(),
        "date_open": dateOpen.toIso8601String(),
        "day_close": dayClose,
        "description": description,
        "email_from": emailFrom,
        "expected_revenue": expectedRevenue,
        "lost_reason_id": lostReasonId!.toJson(),
        "medium_id": mediumId!.toJson(),
        "name": name,
        "partner_id": partnerId!.toJson(),
        "partner_name": partnerName,
        "phone": phone,
        "priority": priority,
        "source_id": sourceId!.toJson(),
        "stage_id": stageId!.toJson(),
        "state_id": stateId!.toJson(),
        "street": street,
        "tag_ids": List<dynamic>.from(tagIds.map((x) => x)),
        "title": title!.toJson(),
        "type": type,
        "user_id": userId!.toJson(),
    };
}

class DataCombos {
    int? id;
    String? name;

    DataCombos({
        required this.id,
        required this.name,
    });

    factory DataCombos.fromRawJson(String str) => DataCombos.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DataCombos.fromJson(Map<String, dynamic> json) => DataCombos(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}

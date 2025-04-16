import 'dart:convert';

class ClienteResponseModel {
    String jsonrpc;
    dynamic id;
    ClienteModel result;

    ClienteResponseModel({
        required this.jsonrpc,
        required this.id,
        required this.result,
    });

    factory ClienteResponseModel.fromJson(String str) => ClienteResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ClienteResponseModel.fromMap(Map<String, dynamic> json) => ClienteResponseModel(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: ClienteModel.fromMap(json["result"]),
    );

    Map<String, dynamic> toMap() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result.toJson(),
    };
}

class ClienteModel {
    int estado;
    ClienteModelData data;

    ClienteModel({
        required this.estado,
        required this.data,
    });

    factory ClienteModel.fromJson(String str) => ClienteModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ClienteModel.fromMap(Map<String, dynamic> json) => ClienteModel(
        estado: json["estado"],
        data: ClienteModelData.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "estado": estado,
        "data": data.toJson(),
    };
}

class ClienteModelData {
    ResPartnerClient resPartner;

    ClienteModelData({
        required this.resPartner,
    });

    factory ClienteModelData.fromJson(String str) => ClienteModelData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ClienteModelData.fromMap(Map<String, dynamic> json) => ClienteModelData(
        resPartner: ResPartnerClient.fromMap(json["res.partner"]),
    );

    Map<String, dynamic> toMap() => {
        "res.partner": resPartner.toJson(),
    };
}

class ResPartnerClient {
    int length;
    List<DatumClienteModelData> data;

    ResPartnerClient({
        required this.length,
        required this.data,
    });

    factory ResPartnerClient.fromJson(String str) => ResPartnerClient.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ResPartnerClient.fromMap(Map<String, dynamic> json) => ResPartnerClient(
        length: json["length"],
        data: List<DatumClienteModelData>.from(json["data"].map((x) => DatumClienteModelData.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "length": length,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DatumClienteModelData {
    int id;
    bool active;
    String barcode;
    List<dynamic> channelIds;
    List<dynamic> childIds;
    StructCombosClients cityId;
    String companyName;
    String companyRegistry;
    dynamic countryCode;
    CountryId countryId;
    int credit;
    int creditLimit;
    String date;
    String email;
    StructCombosClients industryId;
    bool isCompany;
    String l10NEcBirthdate;
    String l10NEcBusinessName;
    StructCombosClients l10NEcCantonId;
    StructCombosClients l10NEcChannelId;
    StructCombosClients l10NEcClassificationId;
    String l10NEcIsDriver;
    String l10NEcLegalRepresentativeName;
    int l10NEcPriority;
    StructCombosClients l10NEcRankId;
    StructCombosClients l10NEcRegionId;
    bool l10NEcRetentionAgent;
    StructCombosClients l10NEcRouteDstId;
    StructCombosClients l10NEcSectorId;
    List<dynamic> l10NEcVisitFrequency;
    StructCombosClients l10NEcZoneId;
    String mobile;
    String name;
    String ref;

    DatumClienteModelData({
        required this.id,
        required this.active,
        required this.barcode,
        required this.channelIds,
        required this.childIds,
        required this.cityId,
        required this.companyName,
        required this.companyRegistry,
        required this.countryCode,
        required this.countryId,
        required this.credit,
        required this.creditLimit,
        required this.date,
        required this.email,
        required this.industryId,
        required this.isCompany,
        required this.l10NEcBirthdate,
        required this.l10NEcBusinessName,
        required this.l10NEcCantonId,
        required this.l10NEcChannelId,
        required this.l10NEcClassificationId,
        required this.l10NEcIsDriver,
        required this.l10NEcLegalRepresentativeName,
        required this.l10NEcPriority,
        required this.l10NEcRankId,
        required this.l10NEcRegionId,
        required this.l10NEcRetentionAgent,
        required this.l10NEcRouteDstId,
        required this.l10NEcSectorId,
        required this.l10NEcVisitFrequency,
        required this.l10NEcZoneId,
        required this.mobile,
        required this.name,
        required this.ref,
    });

    factory DatumClienteModelData.fromJson(String str) => DatumClienteModelData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DatumClienteModelData.fromMap(Map<String, dynamic> json) => DatumClienteModelData(
        id: json["id"] ?? 0,
        active: json["active"] ?? false,
        barcode: json["barcode"] ?? '',
        channelIds: json["channel_ids"] != null ? List<dynamic>.from(json["channel_ids"].map((x) => x)) : [],
        childIds: json["child_ids"] != null ? List<dynamic>.from(json["child_ids"].map((x) => x)) : [],
        cityId: json["city_id"] != null ? StructCombosClients.fromMap(json["city_id"]) : StructCombosClients(
          id: 0, name: ''
        ),
        companyName: json["company_name"] ?? '',
        companyRegistry: json["company_registry"] ?? '',
        countryCode: json["country_code"] ?? '',
        countryId: json["country_id"] != null ? CountryId.fromMap(json["country_id"]) : CountryId(id: 0, name: ''),
        credit: json["credit"] ?? 0,
        creditLimit: json["credit_limit"] ?? 0,
        date: json["date"] ?? '',
        email: json["email"] ?? '',
        industryId: json["industry_id"] != null ? StructCombosClients.fromMap(json["industry_id"]) : StructCombosClients(
          id: 0, name: ''
        ),
        isCompany: json["is_company"] ?? false,
        l10NEcBirthdate: json["l10n_ec_birthdate"] ?? '',
        l10NEcBusinessName: json["l10n_ec_business_name"] ?? '',
        l10NEcCantonId: json["l10n_ec_canton_id"] != null ? StructCombosClients.fromMap(json["l10n_ec_canton_id"])  : StructCombosClients(
          id: 0, name: ''
        ),
        l10NEcChannelId: json["l10n_ec_channel_id"] != null ? StructCombosClients.fromMap(json["l10n_ec_channel_id"]) : StructCombosClients(
          id: 0, name: ''
        ),
        l10NEcClassificationId: json["l10n_ec_classification_id"] != null ? StructCombosClients.fromMap(json["l10n_ec_classification_id"]) : StructCombosClients(
          id: 0, name: ''
        ),
        l10NEcIsDriver: json["l10n_ec_is_driver"] ?? '',
        l10NEcLegalRepresentativeName: json["l10n_ec_legal_representative_name"] ?? '',
        l10NEcPriority: json["l10n_ec_priority"] ?? 0,
        l10NEcRankId: json["l10n_ec_rank_id"] != null ? StructCombosClients.fromMap(json["l10n_ec_rank_id"]) : StructCombosClients(
          id: 0, name: ''
        ),
        l10NEcRegionId: json["l10n_ec_region_id"] != null ? StructCombosClients.fromMap(json["l10n_ec_region_id"]) : StructCombosClients(
          id: 0, name: ''
        ),
        l10NEcRetentionAgent: json["l10n_ec_retention_agent"] ?? false,
        l10NEcRouteDstId: json["l10n_ec_route_dst_id"] != null ? StructCombosClients.fromMap(json["l10n_ec_route_dst_id"]) : StructCombosClients(
          id: 0, name: ''
        ),
        l10NEcSectorId: json["l10n_ec_sector_id"] != null ? StructCombosClients.fromMap(json["l10n_ec_sector_id"]) : StructCombosClients(
          id: 0, name: ''
        ),
        l10NEcVisitFrequency: json["l10n_ec_visit_frequency"] != null ? List<dynamic>.from(json["l10n_ec_visit_frequency"].map((x) => x)) : [],
        l10NEcZoneId: json["l10n_ec_zone_id"] != null ? StructCombosClients.fromMap(json["l10n_ec_zone_id"]) : StructCombosClients(
          id: 0, name: ''
        ),
        mobile: json["mobile"] ?? '',
        name: json["name"] ?? '',
        ref: json["ref"] ?? '',
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "active": active,
        "barcode": barcode,
        "channel_ids": List<dynamic>.from(channelIds.map((x) => x)),
        "child_ids": List<dynamic>.from(childIds.map((x) => x)),
        "city_id": cityId.toJson(),
        "company_name": companyName,
        "company_registry": companyRegistry,
        "country_code": countryCode,
        "country_id": countryId.toJson(),
        "credit": credit,
        "credit_limit": creditLimit,
        "date": date,
        "email": email,
        "industry_id": industryId.toJson(),
        "is_company": isCompany,
        "l10n_ec_birthdate": l10NEcBirthdate,
        "l10n_ec_business_name": l10NEcBusinessName,
        "l10n_ec_canton_id": l10NEcCantonId.toJson(),
        "l10n_ec_channel_id": l10NEcChannelId.toJson(),
        "l10n_ec_classification_id": l10NEcClassificationId.toJson(),
        "l10n_ec_is_driver": l10NEcIsDriver,
        "l10n_ec_legal_representative_name": l10NEcLegalRepresentativeName,
        "l10n_ec_priority": l10NEcPriority,
        "l10n_ec_rank_id": l10NEcRankId.toJson(),
        "l10n_ec_region_id": l10NEcRegionId.toJson(),
        "l10n_ec_retention_agent": l10NEcRetentionAgent,
        "l10n_ec_route_dst_id": l10NEcRouteDstId.toJson(),
        "l10n_ec_sector_id": l10NEcSectorId.toJson(),
        "l10n_ec_visit_frequency": List<dynamic>.from(l10NEcVisitFrequency.map((x) => x)),
        "l10n_ec_zone_id": l10NEcZoneId.toJson(),
        "mobile": mobile,
        "name": name,
        "ref": ref,
    };
}

class CountryId {
    int? id;
    String? name;

    CountryId({
        this.id,
        this.name,
    });

    factory CountryId.fromJson(String str) => CountryId.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CountryId.fromMap(Map<String, dynamic> json) => CountryId(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
    };
}


class StructCombosClients {
    int id;
    String name;

    StructCombosClients({
        required this.id,
        required this.name
    });

    factory StructCombosClients.fromJson(String str) => StructCombosClients.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory StructCombosClients.fromMap(Map<String, dynamic> json) => StructCombosClients(
        id: json["id"] ?? 0,
        name: json["name"] ?? ''
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name
    };
}


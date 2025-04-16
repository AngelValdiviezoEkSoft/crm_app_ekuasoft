
class ClientesRequestModel {
  final String jsonrpc;
  final dynamic id;
  final ClientesModel result;

  ClientesRequestModel({
    required this.jsonrpc,
    this.id,
    required this.result,
  });

  factory ClientesRequestModel.fromMap(Map<String, dynamic> json) => ClientesRequestModel(
        jsonrpc: json['jsonrpc'],
        id: json['id'],
        result: ClientesModel.fromMap(json['result']),
      );

  Map<String, dynamic> toJson() => {
        'jsonrpc': jsonrpc,
        'id': id,
        'result': result.toJson(),
      };
}

class ClientesModel {
  final int estado;
  final DataClientesModel data;

  ClientesModel({
    required this.estado,
    required this.data,
  });

  factory ClientesModel.fromMap(Map<String, dynamic> json) => ClientesModel(
        estado: json['estado'],
        data: DataClientesModel.fromMap(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'estado': estado,
        'data': data.toJson(),
      };
}

class DataClientesModel {
  final ResPartner resPartner;

  DataClientesModel({required this.resPartner});

  factory DataClientesModel.fromMap(Map<String, dynamic> json) => DataClientesModel(
        resPartner: ResPartner.fromMap(json['res.partner']),
      );

  Map<String, dynamic> toJson() => {
        'res.partner': resPartner.toJson(),
      };
}

class ResPartner {
  final int length;
  final List<Partner> data;

  ResPartner({
    required this.length,
    required this.data,
  });

  factory ResPartner.fromMap(Map<String, dynamic> json) => ResPartner(
        length: json['length'],
        data: List<Partner>.from(
            json['data'].map((partner) => Partner.fromMap(partner))),
      );

  Map<String, dynamic> toJson() => {
        'length': length,
        'data': data.map((partner) => partner.toJson()).toList(),
      };
}

class Partner {
  final int id;
  final bool active;
  final dynamic barcode;
  final List<dynamic> channelIds;
  final List<dynamic> childIds;
  final Country cityId;
  final dynamic companyName;
  final dynamic companyRegistry;
  final dynamic countryCode;
  final Country? countryId;
  final double credit;
  final double creditLimit;
  final dynamic date;
  final dynamic email;
  final Country industryId;
  final bool isCompany;
  final dynamic l10nEcBirthdate;
  final dynamic l10nEcBusinessName;
  final Country l10nEcCantonId;
  final Country l10nEcChannelId;
  final Country l10nEcClassificationId;
  final bool l10nEcIsDriver;
  final dynamic l10nEcLegalRepresentativeName;
  final int l10nEcPriority;
  final Country l10nEcRankId;
  final Country l10nEcRegionId;
  final bool l10nEcRetentionAgent;
  final Country l10nEcRouteDstId;
  final Country l10nEcSectorId;
  final List<dynamic> l10nEcVisitFrequency;
  final Country l10nEcZoneId;
  final dynamic mobile;
  final String name;
  final String ref;

  Partner({
    required this.id,
    required this.active,
    this.barcode,
    required this.channelIds,
    required this.childIds,
    required this.cityId,
    this.companyName,
    this.companyRegistry,
    this.countryCode,
    this.countryId,
    required this.credit,
    required this.creditLimit,
    this.date,
    this.email,
    required this.industryId,
    required this.isCompany,
    this.l10nEcBirthdate,
    this.l10nEcBusinessName,
    required this.l10nEcCantonId,
    required this.l10nEcChannelId,
    required this.l10nEcClassificationId,
    required this.l10nEcIsDriver,
    this.l10nEcLegalRepresentativeName,
    required this.l10nEcPriority,
    required this.l10nEcRankId,
    required this.l10nEcRegionId,
    required this.l10nEcRetentionAgent,
    required this.l10nEcRouteDstId,
    required this.l10nEcSectorId,
    required this.l10nEcVisitFrequency,
    required this.l10nEcZoneId,
    this.mobile,
    required this.name,
    required this.ref,
  });

  factory Partner.fromMap(Map<String, dynamic> json) => Partner(
        id: json['id'],
        active: json['active'],
        barcode: json['barcode'],
        channelIds: List<dynamic>.from(json['channel_ids']),
        childIds: List<dynamic>.from(json['child_ids']),
        cityId: Country.fromMap(json['city_id']),
        companyName: json['company_name'],
        companyRegistry: json['company_registry'],
        countryCode: json['country_code'],
        countryId: json['country_id'].isEmpty
            ? null
            : Country.fromMap(json['country_id']),
        credit: json['credit'].toDouble(),
        creditLimit: json['credit_limit'].toDouble(),
        date: json['date'],
        email: json['email'],
        industryId: Country.fromMap(json['industry_id']),
        isCompany: json['is_company'],
        l10nEcBirthdate: json['l10n_ec_birthdate'],
        l10nEcBusinessName: json['l10n_ec_business_name'],
        l10nEcCantonId: Country.fromMap(json['l10n_ec_canton_id']),
        l10nEcChannelId: Country.fromMap(json['l10n_ec_channel_id']),
        l10nEcClassificationId:
            Country.fromMap(json['l10n_ec_classification_id']),
        l10nEcIsDriver: json['l10n_ec_is_driver'],
        l10nEcLegalRepresentativeName:
            json['l10n_ec_legal_representative_name'],
        l10nEcPriority: json['l10n_ec_priority'],
        l10nEcRankId: Country.fromMap(json['l10n_ec_rank_id']),
        l10nEcRegionId: Country.fromMap(json['l10n_ec_region_id']),
        l10nEcRetentionAgent: json['l10n_ec_retention_agent'],
        l10nEcRouteDstId: Country.fromMap(json['l10n_ec_route_dst_id']),
        l10nEcSectorId: Country.fromMap(json['l10n_ec_sector_id']),
        l10nEcVisitFrequency:
            List<dynamic>.from(json['l10n_ec_visit_frequency']),
        l10nEcZoneId: Country.fromMap(json['l10n_ec_zone_id']),
        mobile: json['mobile'],
        name: json['name'],
        ref: json['ref'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'active': active,
        'barcode': barcode,
        'channel_ids': channelIds,
        'child_ids': childIds,
        'city_id': cityId,
        'company_name': companyName,
        'company_registry': companyRegistry,
        'country_code': countryCode,
        'country_id': countryId?.toJson(),
        'credit': credit,
        'credit_limit': creditLimit,
        'date': date,
        'email': email,
        'industry_id': industryId,
        'is_company': isCompany,
        'l10n_ec_birthdate': l10nEcBirthdate,
        'l10n_ec_business_name': l10nEcBusinessName,
        'l10n_ec_canton_id': l10nEcCantonId,
        'l10n_ec_channel_id': l10nEcChannelId,
        'l10n_ec_classification_id': l10nEcClassificationId,
        'l10n_ec_is_driver': l10nEcIsDriver,
        'l10n_ec_legal_representative_name': l10nEcLegalRepresentativeName,
        'l10n_ec_priority': l10nEcPriority,
        'l10n_ec_rank_id': l10nEcRankId,
        'l10n_ec_region_id': l10nEcRegionId,
        'l10n_ec_retention_agent': l10nEcRetentionAgent,
        'l10n_ec_route_dst_id': l10nEcRouteDstId,
        'l10n_ec_sector_id': l10nEcSectorId,
        'l10n_ec_visit_frequency': l10nEcVisitFrequency,
        'l10n_ec_zone_id': l10nEcZoneId,
        'mobile': mobile,
        'name': name,
        'ref': ref,
      };
}

class Country {
  final int id;
  final String name;

  Country({
    required this.id,
    required this.name,
  });

  factory Country.fromMap(Map<String, dynamic> json) => Country(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

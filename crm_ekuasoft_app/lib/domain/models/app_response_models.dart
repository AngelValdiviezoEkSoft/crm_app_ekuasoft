import 'dart:convert';

class AppResponseModel {
    String jsonrpc;
    dynamic id;
    AppModel result;

    AppResponseModel({
        required this.jsonrpc,
        required this.id,
        required this.result,
    });

    factory AppResponseModel.fromRawJson(String str) => AppResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AppResponseModel.fromJson(Map<String, dynamic> json) => AppResponseModel(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: AppModel.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result.toJson(),
    };
}

class AppModel {
    int? estado;
    DataAppModel data;

    AppModel({
        required this.estado,
        required this.data,
    });

    factory AppModel.fromRawJson(String str) => AppModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AppModel.fromJson(Map<String, dynamic> json) => AppModel(
        estado: json["estado"] ?? 0,
        data: DataAppModel.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "estado": estado,
        "data": data.toJson(),
    };
}

class DataAppModel {
    CrmLeadAppModel crmLead;
    ResPartnerAppModel resPartner;
    UtmCampaignAppModel utmCampaign;
    UtmAppModel utmSource;
    UtmAppModel utmMedium;
    MailActivityTypeAppModel mailActivityType;
    ResCountryAppModel resCountry;
    MailActivityAppModel mailActivity;

    DataAppModel({
        required this.crmLead,
        required this.resPartner,
        required this.utmCampaign,
        required this.utmSource,
        required this.utmMedium,
        required this.mailActivityType,
        required this.resCountry,
        required this.mailActivity
    });

    factory DataAppModel.fromRawJson(String str) => DataAppModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DataAppModel.fromJson(Map<String, dynamic> json) => DataAppModel(
        crmLead: 
          json["crm.lead"] != null ? 
            CrmLeadAppModel.fromJson(json["crm.lead"])  
            : 
            CrmLeadAppModel(data: [], fields: CrmLeadFieldsAppModel(activityIds: '', campaignId: '', city: '', contactName: '', countryId: '', dateClosed: '', dateDeadline: '', dateOpen: '', dayClose: '', description: '', emailCc: '', emailFrom: '', expectedRevenue: '',function: '', lostReasonId: '', mediumId: '', mobile: '', name: '', partnerId: '', partnerName: '', phone: '', priority: '', referred: '', sourceId: '', stageId: '', stateId: '', street: '', tagIds: '', title: '', type: '', userId: ''), length: 0),
        resPartner: 
            json["res.partner"] != null ? 
            ResPartnerAppModel.fromJson(json["res.partner"]) 
            : 
            ResPartnerAppModel(data: [], fields: ResPartnerFieldsAppModel(accountRepresentedCompanyIds: '', barcode: '', categoryId: '', channelIds: '', childIds: '', cityId: '', companyType: '', countryId: '', date: '', email: '', name: ''), length: 0),
        utmCampaign: 
            json["utm.campaign"] != null ? 
            UtmCampaignAppModel.fromJson(json["utm.campaign"]) 
            : 
            UtmCampaignAppModel(data: [], length: 0, fields: UtmCampaignFieldsAppModel(active: '', name: '', title: '')),
        utmSource: 
            json["utm.source"] != null ? 
            UtmAppModel.fromJson(json["utm.source"]) 
            : 
            UtmAppModel(data: [], length: 0, fields: UtmMediumFields(name: '')),
        utmMedium: 
            json["utm.medium"] != null ? 
            UtmAppModel.fromJson(json["utm.medium"]) 
            : 
            UtmAppModel(data: [], length: 0, fields: UtmMediumFields(name: '')),
        mailActivityType: 
            json["mail.activity.type"] != null ? 
            MailActivityTypeAppModel.fromJson(json["mail.activity.type"]) 
            : 
            MailActivityTypeAppModel(data: [], length: 0, fields: MailActivityTypeFieldsAppModel(category: '', decorationType: '', defaultNote: '', delayCount: '', delayFrom: '', icon: '', name: '', resModel: '', sequence: '', summary: '')),
        resCountry: 
            json["res.country"] != null ? 
            ResCountryAppModel.fromJson(json["res.country"]) 
            : 
            ResCountryAppModel(data: [], length: 0, fields: ResCountryFieldsAppModel(code: '', name: '', stateIds: '')),
        mailActivity: json['mail.activity'] != null ?
          MailActivityAppModel.fromJson(json["mail.activity"])
          :
          MailActivityAppModel(data: [], length: 0, fields: MailActivityFieldsAppModel(code: '', name: '', stateIds: ''))
    );

    Map<String, dynamic> toJson() => {
      "crm.lead": crmLead.toJson(),
      "res.partner": resPartner.toJson(),
      "utm.campaign": utmCampaign.toJson(),
      "utm.source": utmSource.toJson(),
      "utm.medium": utmMedium.toJson(),
      "mail.activity.type": mailActivityType.toJson(),
      "res.country": resCountry.toJson(),
      "mail.activity": mailActivity.toJson()
    };
}

class CrmLeadAppModel {
    int length;
    CrmLeadFieldsAppModel fields;
    List<CrmLeadDatumAppModel> data;

    CrmLeadAppModel({
        required this.length,
        required this.fields,
        required this.data,
    });

    factory CrmLeadAppModel.fromRawJson(String str) => CrmLeadAppModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CrmLeadAppModel.fromJson(Map<String, dynamic> json) => CrmLeadAppModel(
        length: json["length"],
        fields: json["fields"] != null ?
        CrmLeadFieldsAppModel.fromJson(json["fields"])
        :CrmLeadFieldsAppModel(activityIds: '', campaignId: '', city: '', contactName: '', countryId: '', dateClosed: '', dateDeadline: '', dateOpen: '', dayClose: '', description: '', emailCc: '', emailFrom: '', expectedRevenue: '', function: '', lostReasonId: '', 
        mediumId: '', mobile: '', name: '', partnerId: '', partnerName: '', phone: '', priority: '', referred: '', sourceId: '', stageId: '', stateId: '', street: '', tagIds: '', title: '', type: '', userId: ''),
        data: List<CrmLeadDatumAppModel>.from(json["data"].map((x) => CrmLeadDatumAppModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "length": length,
        "fields": fields.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class CrmLeadDatumAppModel {
  int? id;
  List<CombosAppModel> activityIds;
  CombosAppModel campaignId;
  String? contactName;
  CombosAppModel countryId;
  DateTime dateOpen;
  double? dayClose;
  String? emailFrom;
  double? expectedRevenue;
  CombosAppModel lostReasonId;
  CombosAppModel mediumId;
  String? name;
  CombosAppModel partnerId;
  String? phone;
  String? priority;
  CombosAppModel sourceId;
  CombosAppModel stageId;
  CombosAppModel stateId;
  List<CombosAppModel> tagIds;
  CombosAppModel title;
  String? type;
  CombosAppModel userId;
  
  String? referred;
  String? street;
  double? probability;
  DateTime? dateClose;
  DateTime? dateDeadline;
  String? description;

  CrmLeadDatumAppModel({
      required this.id,
      required this.activityIds,
      required this.campaignId,
      required this.contactName,
      required this.countryId,
      required this.dateOpen,
      required this.dayClose,
      required this.emailFrom,
      required this.expectedRevenue,
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
      required this.userId,
      required this.referred,
      required this.street,
      required this.probability,
      required this.dateClose,
      required this.dateDeadline,
      this.description,
  });

  factory CrmLeadDatumAppModel.fromRawJson(String str) => CrmLeadDatumAppModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CrmLeadDatumAppModel.fromJson(Map<String, dynamic> json) => CrmLeadDatumAppModel(
    id: json["id"] ?? 0,
    activityIds: json["activity_ids"]!= null ?
    List<CombosAppModel>.from(json["activity_ids"].map((x) => CombosAppModel.fromJson(x)))
    : [],
    campaignId: json["campaign_id"] != null 
    ? CombosAppModel.fromJson(json["campaign_id"])
    : CombosAppModel(id: 0, name: ''),
    contactName: json["contact_name"] ?? '',
    countryId: json["country_id"] != null ? CombosAppModel.fromJson(json["country_id"])
    : CombosAppModel(id: 0, name: ''),
    dateOpen: json["date_open"] != null ? DateTime.parse(json["date_open"]) : DateTime.now(),
    dayClose: json["day_close"] ?? 0,
    emailFrom: json["email_from"] ?? '',
    expectedRevenue: json["expected_revenue"] ?? 0,
    lostReasonId: json["lost_reason_id"] != null ? CombosAppModel.fromJson(json["lost_reason_id"])
    : CombosAppModel(id: 0, name: ''),
    mediumId: json["medium_id"] != null ? CombosAppModel.fromJson(json["medium_id"])
    : CombosAppModel(id: 0, name: ''),
    name: json["name"] ?? '',
    partnerId: json["partner_id"] != null ? CombosAppModel.fromJson(json["partner_id"])
    : CombosAppModel(id: 0, name: ''),
    phone: json["phone"] ?? '',
    priority: json["priority"] ?? '',
    sourceId: json["source_id"] != null ? CombosAppModel.fromJson(json["source_id"])
    : CombosAppModel(id: 0, name: ''),
    stageId: json["stage_id"] != null ? CombosAppModel.fromJson(json["stage_id"])
    : CombosAppModel(id: 0, name: ''),
    stateId: json["state_id"] != null ? CombosAppModel.fromJson(json["state_id"])
    : CombosAppModel(id: 0, name: ''),
    tagIds: json["tag_ids"] != null ? List<CombosAppModel>.from(json["tag_ids"].map((x) => CombosAppModel.fromJson(x))) : [],
    title: json["title"] != null ? CombosAppModel.fromJson(json["title"])
    : CombosAppModel(id: 0, name: ''),
    type: json["type"] ?? '',
    userId: json["user_id"] != null ? CombosAppModel.fromJson(json["user_id"])
    : CombosAppModel(id: 0, name: ''),
    referred: json["referred"] ?? '',
    street: json["street"] ?? '',
    dateClose: json["date_closed"] == null ? null : DateTime.parse(json["date_closed"]),
    dateDeadline: json['date_deadline'] == null ? DateTime.now() : DateTime.parse(json['date_deadline']),
    probability: json["probability"] ?? 0,
    description: json["description"],
);

  Map<String, dynamic> toJson() => {
    "id": id,
    "activity_ids": List<dynamic>.from(activityIds.map((x) => x.toJson())),
    "campaign_id": campaignId.toJson(),
    "contact_name": contactName,
    "country_id": countryId.toJson(),
    "date_open": dateOpen.toIso8601String(),
    "day_close": dayClose,
    "email_from": emailFrom,
    "expected_revenue": expectedRevenue,
    "lost_reason_id": lostReasonId.toJson(),
    "medium_id": mediumId.toJson(),
    "name": name,
    "partner_id": partnerId.toJson(),
    "phone": phone,
    "priority": priority,
    "source_id": sourceId.toJson(),
    "stage_id": stageId.toJson(),
    "state_id": stateId.toJson(),
    "tag_ids": List<dynamic>.from(tagIds.map((x) => x.toJson())),
    "title": title.toJson(),
    "type": type,
    "user_id": userId.toJson(),
    "referred": referred,
    "street": street,
    'date_Close': dateClose?.toIso8601String(),
    'probability': probability,
    'date_deadline': dateDeadline?.toIso8601String(),
    'description': description,
  };

}

class CombosAppModel {
    int? id;
    String? name;

    CombosAppModel({
        required this.id,
        required this.name,
    });

    factory CombosAppModel.fromRawJson(String str) => CombosAppModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CombosAppModel.fromJson(Map<String, dynamic> json) => CombosAppModel(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}

class CrmLeadFieldsAppModel {
    String? activityIds;
    String? campaignId;
    String? city;
    String? contactName;
    String? countryId;
    String? dateClosed;
    String? dateDeadline;
    String? dateOpen;
    String? dayClose;
    String? description;
    String? emailCc;
    String? emailFrom;
    String? expectedRevenue;
    String? function;
    String? lostReasonId;
    String? mediumId;
    String? mobile;
    String? name;
    String? partnerId;
    String? partnerName;
    String? phone;
    String? priority;
    String? referred;
    String? sourceId;
    String? stageId;
    String? stateId;
    String? street;
    String? tagIds;
    String? title;
    String? type;
    String? userId;

    CrmLeadFieldsAppModel({
        required this.activityIds,
        required this.campaignId,
        required this.city,
        required this.contactName,
        required this.countryId,
        required this.dateClosed,
        required this.dateDeadline,
        required this.dateOpen,
        required this.dayClose,
        required this.description,
        required this.emailCc,
        required this.emailFrom,
        required this.expectedRevenue,
        required this.function,
        required this.lostReasonId,
        required this.mediumId,
        required this.mobile,
        required this.name,
        required this.partnerId,
        required this.partnerName,
        required this.phone,
        required this.priority,
        required this.referred,
        required this.sourceId,
        required this.stageId,
        required this.stateId,
        required this.street,
        required this.tagIds,
        required this.title,
        required this.type,
        required this.userId,
    });

    factory CrmLeadFieldsAppModel.fromRawJson(String str) => CrmLeadFieldsAppModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CrmLeadFieldsAppModel.fromJson(Map<String, dynamic> json) => CrmLeadFieldsAppModel(
        activityIds: json["activity_ids"] ?? '',
        campaignId: json["campaign_id"] ?? '',
        city: json["city"] ?? '',
        contactName: json["contact_name"] ?? '',
        countryId: json["country_id"] ?? '',
        dateClosed: json["date_closed"] ?? '',
        dateDeadline: json["date_deadline"] ?? '',
        dateOpen: json["date_open"] ?? '',
        dayClose: json["day_close"] ?? '',
        description: json["description"] ?? '',
        emailCc: json["email_cc"] ?? '',
        emailFrom: json["email_from"] ?? '',
        expectedRevenue: json["expected_revenue"] ?? '',
        function: json["function"] ?? '',
        lostReasonId: json["lost_reason_id"] ?? '',
        mediumId: json["medium_id"] ?? '',
        mobile: json["mobile"] ?? '',
        name: json["name"] ?? '',
        partnerId: json["partner_id"] ?? '',
        partnerName: json["partner_name"] ?? '',
        phone: json["phone"] ?? '',
        priority: json["priority"] ?? '',
        referred: json["referred"] ?? '',
        sourceId: json["source_id"] ?? '',
        stageId: json["stage_id"] ?? '',
        stateId: json["state_id"] ?? '',
        street: json["street"] ?? '',
        tagIds: json["tag_ids"] ?? '',
        title: json["title"] ?? '',
        type: json["type"] ?? '',
        userId: json["user_id"] ?? ''
    );

    Map<String, dynamic> toJson() => {
        "activity_ids": activityIds,
        "campaign_id": campaignId,
        "city": city,
        "contact_name": contactName,
        "country_id": countryId,
        "date_closed": dateClosed,
        "date_deadline": dateDeadline,
        "date_open": dateOpen,
        "day_close": dayClose,
        "description": description,
        "email_cc": emailCc,
        "email_from": emailFrom,
        "expected_revenue": expectedRevenue,
        "function": function,
        "lost_reason_id": lostReasonId,
        "medium_id": mediumId,
        "mobile": mobile,
        "name": name,
        "partner_id": partnerId,
        "partner_name": partnerName,
        "phone": phone,
        "priority": priority,
        "referred": referred,
        "source_id": sourceId,
        "stage_id": stageId,
        "state_id": stateId,
        "street": street,
        "tag_ids": tagIds,
        "title": title,
        "type": type,
        "user_id": userId,
    };
}

class MailActivityTypeAppModel {
    int length;
    MailActivityTypeFieldsAppModel fields;
    List<MailActivityTypeDatumAppModel> data;

    MailActivityTypeAppModel({
        required this.length,
        required this.fields,
        required this.data,
    });

    factory MailActivityTypeAppModel.fromRawJson(String str) => MailActivityTypeAppModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MailActivityTypeAppModel.fromJson(Map<String, dynamic> json) => MailActivityTypeAppModel(
        length: json["length"],
        fields: json["fields"] != null ? MailActivityTypeFieldsAppModel.fromJson(json["fields"])
        : MailActivityTypeFieldsAppModel(category: '', decorationType: '', defaultNote: '', delayCount: '', delayFrom: '', icon: '', name: '', resModel: '', sequence: '', 
        summary: ''),
        data: json["data"] != null ? List<MailActivityTypeDatumAppModel>.from(json["data"].map((x) => MailActivityTypeDatumAppModel.fromJson(x))) : [],
    );

    Map<String, dynamic> toJson() => {
        "length": length,
        "fields": fields.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class MailActivityTypeDatumAppModel {
    int? id;
    String? category;
    int? delayCount;
    String? delayFrom;
    String? icon;
    String? name;
    String? summary;
    int? sequence;

    MailActivityTypeDatumAppModel({
        required this.id,
        required this.category,
        required this.delayCount,
        required this.delayFrom,
        required this.icon,
        required this.name,
        required this.sequence,
        required this.summary
    });

    factory MailActivityTypeDatumAppModel.fromRawJson(String str) => MailActivityTypeDatumAppModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MailActivityTypeDatumAppModel.fromJson(Map<String, dynamic> json) => MailActivityTypeDatumAppModel(
        id: json["id"] ?? 0,
        category: json["category"] ?? '',
        delayCount: json["delay_count"] ?? 0,
        delayFrom: json["delay_from"] ?? '',
        icon: json["icon"] ?? '',
        name: json["name"] ?? '',
        summary: json["summary"] ?? '',
        sequence: json["sequence"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "delay_count": delayCount,
        "delay_from": delayFrom,
        "icon": icon,
        "name": name,
        "sequence": sequence,
        "summary": summary
    };
}

class MailActivityTypeFieldsAppModel {
    String? category;
    String? decorationType;
    String? defaultNote;
    String? delayCount;
    String? delayFrom;
    String? icon;
    String? name;
    String? resModel;
    String? sequence;
    String? summary;

    MailActivityTypeFieldsAppModel({
        required this.category,
        required this.decorationType,
        required this.defaultNote,
        required this.delayCount,
        required this.delayFrom,
        required this.icon,
        required this.name,
        required this.resModel,
        required this.sequence,
        required this.summary,
    });

    factory MailActivityTypeFieldsAppModel.fromRawJson(String str) => MailActivityTypeFieldsAppModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MailActivityTypeFieldsAppModel.fromJson(Map<String, dynamic> json) => MailActivityTypeFieldsAppModel(
        category: json["category"] ?? '',
        decorationType: json["decoration_type"] ?? '',
        defaultNote: json["default_note"] ?? '',
        delayCount: json["delay_count"] ?? '',
        delayFrom: json["delay_from"] ?? '',
        icon: json["icon"] ?? '',
        name: json["name"] ?? '',
        resModel: json["res_model"] ?? '',
        sequence: json["sequence"] ?? '',
        summary: json["summary"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "category": category,
        "decoration_type": decorationType,
        "default_note": defaultNote,
        "delay_count": delayCount,
        "delay_from": delayFrom,
        "icon": icon,
        "name": name,
        "res_model": resModel,
        "sequence": sequence,
        "summary": summary,
    };
}

class ResCountryAppModel {
    int length;
    ResCountryFieldsAppModel fields;
    List<ResCountryDatumAppModel> data;

    ResCountryAppModel({
        required this.length,
        required this.fields,
        required this.data,
    });

    factory ResCountryAppModel.fromRawJson(String str) => ResCountryAppModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ResCountryAppModel.fromJson(Map<String, dynamic> json) => ResCountryAppModel(
        length: json["length"] ?? 0,
        fields: json["fields"] != null ? ResCountryFieldsAppModel.fromJson(json["fields"])
        : ResCountryFieldsAppModel(code: '',name: '',stateIds: ''),
        data: json["data"] != null ? List<ResCountryDatumAppModel>.from(json["data"].map((x) => ResCountryDatumAppModel.fromJson(x))) : [],
    );

    Map<String, dynamic> toJson() => {
        "length": length,
        "fields": fields.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ResCountryDatumAppModel {
    int? id;
    String? code;
    String? name;
    List<CombosAppModel> stateIds;

    ResCountryDatumAppModel({
        required this.id,
        required this.code,
        required this.name,
        required this.stateIds,
    });

    factory ResCountryDatumAppModel.fromRawJson(String str) => ResCountryDatumAppModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ResCountryDatumAppModel.fromJson(Map<String, dynamic> json) => ResCountryDatumAppModel(
        id: json["id"] ?? 0,
        code: json["code"] ?? '',
        name: json["name"] ?? '',
        stateIds: json["state_ids"] != null ? List<CombosAppModel>.from(json["state_ids"].map((x) => CombosAppModel.fromJson(x))) : [],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "state_ids": List<dynamic>.from(stateIds.map((x) => x.toJson())),
    };
}

class ResCountryFieldsAppModel {
    String? code;
    String? name;
    String? stateIds;

    ResCountryFieldsAppModel({
        required this.code,
        required this.name,
        required this.stateIds,
    });

    factory ResCountryFieldsAppModel.fromRawJson(String str) => ResCountryFieldsAppModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ResCountryFieldsAppModel.fromJson(Map<String, dynamic> json) => ResCountryFieldsAppModel(
        code: json["code"] ?? '',
        name: json["name"] ?? '',
        stateIds: json["state_ids"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "state_ids": stateIds,
    };
}

class ResPartnerAppModel {
    int length;
    ResPartnerFieldsAppModel fields;
    List<ResPartnerDatumAppModel> data;

    ResPartnerAppModel({
        required this.length,
        required this.fields,
        required this.data,
    });

    factory ResPartnerAppModel.fromRawJson(String str) => ResPartnerAppModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ResPartnerAppModel.fromJson(Map<String, dynamic> json) => ResPartnerAppModel(
        length: json["length"],
        fields: json["fields"] != null ? ResPartnerFieldsAppModel.fromJson(json["fields"]):
        ResPartnerFieldsAppModel(accountRepresentedCompanyIds: '', barcode: '', categoryId: '', channelIds: '', childIds: '', cityId: '', companyType: '',countryId: '', date: '', email: '', name: ''),
        data: json["data"] != null ? List<ResPartnerDatumAppModel>.from(json["data"].map((x) => ResPartnerDatumAppModel.fromJson(x))) : [],
    );

    Map<String, dynamic> toJson() => {
        "length": length,
        "fields": fields.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ResPartnerDatumAppModel {
    int? id;
    List<dynamic> accountRepresentedCompanyIds;
    List<dynamic> categoryId;
    List<dynamic> channelIds;
    List<dynamic> childIds;
    CombosAppModel cityId;
    String? companyType;
    CombosAppModel countryId;
    String? email;
    
    String? mobile;
    String? name;
    String? ref;

    ResPartnerDatumAppModel({
        required this.id,
        required this.accountRepresentedCompanyIds,
        required this.categoryId,
        required this.channelIds,
        required this.childIds,
        required this.cityId,
        required this.companyType,
        required this.countryId,
        required this.email,

        required this.mobile,
        required this.name,
        required this.ref,
    });

    factory ResPartnerDatumAppModel.fromRawJson(String str) => ResPartnerDatumAppModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ResPartnerDatumAppModel.fromJson(Map<String, dynamic> json) => ResPartnerDatumAppModel(
        id: json["id"] ?? 0,
        accountRepresentedCompanyIds: json["account_represented_company_ids"] != null ? List<dynamic>.from(json["account_represented_company_ids"].map((x) => x))
        : [],
        categoryId: json["category_id"] != null ? List<dynamic>.from(json["category_id"].map((x) => x))
        : [],
        channelIds: json["channel_ids"] != null ? List<dynamic>.from(json["channel_ids"].map((x) => x))
        : [],
        childIds: json["child_ids"]!= null ? List<dynamic>.from(json["child_ids"].map((x) => x))
        : [],
        cityId: json["city_id"] != null ? CombosAppModel.fromJson(json["city_id"])
        : CombosAppModel(id: 0, name: ''),
        companyType: json["company_type"] ?? '',
        countryId: json["country_id"] != null ? CombosAppModel.fromJson(json["country_id"])
        : CombosAppModel(id: 0, name: ''),
        email: json["email"] ?? '',
        mobile: json["mobile"] ?? '',
        name: json["name"] ?? '',
        ref: json["ref"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "account_represented_company_ids": List<dynamic>.from(accountRepresentedCompanyIds.map((x) => x)),
        "category_id": List<dynamic>.from(categoryId.map((x) => x)),
        "channel_ids": List<dynamic>.from(channelIds.map((x) => x)),
        "child_ids": List<dynamic>.from(childIds.map((x) => x)),
        "city_id": cityId.toJson(),
        "company_type": companyType,
        "country_id": countryId.toJson(),
        "email": email,

        "mobile": mobile,
        "name": name,
        "ref": ref,
    };
}

class ResPartnerFieldsAppModel {
    String? accountRepresentedCompanyIds;
    String? barcode;
    String? categoryId;
    String? channelIds;
    String? childIds;
    String? cityId;
    String? companyType;
    String? countryId;
    String? date;
    String? email;
    String? name;

    ResPartnerFieldsAppModel({
        required this.accountRepresentedCompanyIds,
        required this.barcode,
        required this.categoryId,
        required this.channelIds,
        required this.childIds,
        required this.cityId,
        required this.companyType,
        required this.countryId,
        required this.date,
        required this.email,
        required this.name,
    });

    factory ResPartnerFieldsAppModel.fromRawJson(String str) => ResPartnerFieldsAppModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ResPartnerFieldsAppModel.fromJson(Map<String, dynamic> json) => ResPartnerFieldsAppModel(
        accountRepresentedCompanyIds: json["account_represented_company_ids"] ?? '',
        barcode: json["barcode"] ?? '',
        categoryId: json["category_id"] ?? '',
        channelIds: json["channel_ids"] ?? '',
        childIds: json["child_ids"] ?? '',
        cityId: json["city_id"] ?? '',
        companyType: json["company_type"] ?? '',
        countryId: json["country_id"] ?? '',
        date: json["date"] ?? '',
        email: json["email"] ?? '',
        name: json["name"] ?? ''
    );

    Map<String, dynamic> toJson() => {
        "account_represented_company_ids": accountRepresentedCompanyIds,
        "barcode": barcode,
        "category_id": categoryId,
        "channel_ids": channelIds,
        "child_ids": childIds,
        "city_id": cityId,
        "company_type": companyType,
        "country_id": countryId,
        "date": date,
        "email": email,
        "name": name,
    };
}

class UtmCampaignAppModel {
    int length;
    UtmCampaignFieldsAppModel fields;
    List<UtmCampaignDatumAppModel> data;

    UtmCampaignAppModel({
        required this.length,
        required this.fields,
        required this.data,
    });

    factory UtmCampaignAppModel.fromRawJson(String str) => UtmCampaignAppModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UtmCampaignAppModel.fromJson(Map<String, dynamic> json) => UtmCampaignAppModel(
        length: json["length"],
        fields: json["fields"]!= null ? UtmCampaignFieldsAppModel.fromJson(json["fields"])
        : UtmCampaignFieldsAppModel(active: '', name: '',title: ''),
        data: json["data"] != null ? List<UtmCampaignDatumAppModel>.from(json["data"].map((x) => UtmCampaignDatumAppModel.fromJson(x))) : [],
    );

    Map<String, dynamic> toJson() => {
        "length": length,
        "fields": fields.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class UtmCampaignDatumAppModel {
    int? id;
    bool? active;
    String? name;
    String? title;

    UtmCampaignDatumAppModel({
        required this.id,
        required this.active,
        required this.name,
        required this.title,
    });

    factory UtmCampaignDatumAppModel.fromRawJson(String str) => UtmCampaignDatumAppModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UtmCampaignDatumAppModel.fromJson(Map<String, dynamic> json) => UtmCampaignDatumAppModel(
        id: json["id"] ?? 0,
        active: json["active"] ?? false,
        name: json["name"] ?? '',
        title: json["title"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "active": active,
        "name": name,
        "title": title,
    };
}

class UtmCampaignFieldsAppModel {
    String? active;
    String? name;
    String? title;

    UtmCampaignFieldsAppModel({
        required this.active,
        required this.name,
        required this.title,
    });

    factory UtmCampaignFieldsAppModel.fromRawJson(String str) => UtmCampaignFieldsAppModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UtmCampaignFieldsAppModel.fromJson(Map<String, dynamic> json) => UtmCampaignFieldsAppModel(
        active: json["active"] ?? '',
        name: json["name"] ?? '',
        title: json["title"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "active": active,
        "name": name,
        "title": title,
    };
}

class UtmAppModel {
    int length;
    UtmMediumFields fields;
    List<CombosAppModel> data;

    UtmAppModel({
        required this.length,
        required this.fields,
        required this.data,
    });

    factory UtmAppModel.fromRawJson(String str) => UtmAppModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UtmAppModel.fromJson(Map<String, dynamic> json) => UtmAppModel(
        length: json["length"],
        fields: json["fields"] != null ? UtmMediumFields.fromJson(json["fields"])
        : UtmMediumFields(name: ''),
        data: json["data"] != null ? List<CombosAppModel>.from(json["data"].map((x) => CombosAppModel.fromJson(x))) : [],
    );

    Map<String, dynamic> toJson() => {
        "length": length,
        "fields": fields.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class UtmMediumFields {
    String? name;

    UtmMediumFields({
        required this.name,
    });

    factory UtmMediumFields.fromRawJson(String str) => UtmMediumFields.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UtmMediumFields.fromJson(Map<String, dynamic> json) => UtmMediumFields(
        name: json["name"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "name": name,
    };
}

class MailActivityAppModel {
    int length;
    MailActivityFieldsAppModel fields;
    List<MailActivityDatumAppModel> data;

    MailActivityAppModel({
        required this.length,
        required this.fields,
        required this.data,
    });

    factory MailActivityAppModel.fromRawJson(String str) => MailActivityAppModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MailActivityAppModel.fromJson(Map<String, dynamic> json) => MailActivityAppModel(
        length: json["length"],
        fields: json["fields"] != null ? MailActivityFieldsAppModel.fromJson(json["fields"])
        : MailActivityFieldsAppModel(code: '',name: '', stateIds: ''),
        data: List<MailActivityDatumAppModel>.from(json["data"].map((x) => MailActivityDatumAppModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "length": length,
        "fields": fields.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class MailActivityDatumAppModel {
    int? id;
    String? dateDadline;
    int? resId;
    String? resModel;
    String? summary;

    CombosAppModel activityTypeId;
    CombosAppModel userId;

    MailActivityDatumAppModel({
        required this.id,
        required this.dateDadline,
        required this.resId,
        required this.resModel,
        required this.activityTypeId,
        required this.userId,
        required this.summary
    });

    factory MailActivityDatumAppModel.fromRawJson(String str) => MailActivityDatumAppModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MailActivityDatumAppModel.fromJson(Map<String, dynamic> json) => MailActivityDatumAppModel(
        id: json["id"] ?? 0,
        summary: json["summary"] ?? '',
        dateDadline: json["date_deadline"] ?? '',
        resId: json["res_id"] ?? 0,
        resModel: json['res_model'] ?? '',
        activityTypeId: json["activity_type_id"] != null ? 
        CombosAppModel.fromJson(json["activity_type_id"])
        : CombosAppModel(id: 0, name: ''),
        userId: json["user_id"] != null ?
        CombosAppModel.fromJson(json["user_id"])
        : CombosAppModel(id: 0, name: ''),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "date_deadline": dateDadline,
        "res_id": resId,
        "res_model": resModel,
        "activity_type_id": activityTypeId.toJson(),//List<dynamic>.from(activityTypeId.map((x) => x.toJson())),
        "user_id": userId.toJson(),
        "summary":summary
    };
}

class MailActivityFieldsAppModel {
    String? code;
    String? name;
    String? stateIds;

    MailActivityFieldsAppModel({
        required this.code,
        required this.name,
        required this.stateIds,
    });

    factory MailActivityFieldsAppModel.fromRawJson(String str) => MailActivityFieldsAppModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MailActivityFieldsAppModel.fromJson(Map<String, dynamic> json) => MailActivityFieldsAppModel(
        code: json["code"] ?? '',
        name: json["name"] ?? '',
        stateIds: json["state_ids"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "state_ids": stateIds,
    };
}

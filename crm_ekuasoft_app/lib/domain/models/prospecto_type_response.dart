import 'dart:convert';

class ProspectoResponseModel {
    String jsonrpc;
    dynamic id;
    ProspectoModel result;

    ProspectoResponseModel({
        required this.jsonrpc,
        required this.id,
        required this.result,
    });

    factory ProspectoResponseModel.fromJson(String str) => ProspectoResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ProspectoResponseModel.fromMap(Map<String, dynamic> json) => ProspectoResponseModel(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: ProspectoModel.fromMap(json["result"]),
    );

    Map<String, dynamic> toMap() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result.toJson(),
    };
}

class ProspectoModel {
    int estado;
    ProspectoDataModel data;

    ProspectoModel({
        required this.estado,
        required this.data,
    });

    factory ProspectoModel.fromJson(String str) => ProspectoModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ProspectoModel.fromMap(Map<String, dynamic> json) => ProspectoModel(
        estado: json["estado"],
        data: ProspectoDataModel.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "estado": estado,
        "data": data.toJson(),
    };
}

class ProspectoDataModel {
    CrmLead crmLead;

    ProspectoDataModel({
        required this.crmLead,
    });

    factory ProspectoDataModel.fromJson(String str) => ProspectoDataModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ProspectoDataModel.fromMap(Map<String, dynamic> json) => ProspectoDataModel(
        crmLead: CrmLead.fromMap(json["crm.lead"]),
    );

    Map<String, dynamic> toMap() => {
        "crm.lead": crmLead.toJson(),
    };
}

class CrmLead {
    int length;
    FieldsCrmLead fields;
    List<DatumCrmLead> data;

    CrmLead({
        required this.length,
        required this.fields,
        required this.data,
    });

    factory CrmLead.fromJson(String str) => CrmLead.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CrmLead.fromMap(Map<String, dynamic> json) => CrmLead(
        length: json["length"],
        fields: FieldsCrmLead.fromMap(json["fields"]),
        data: List<DatumCrmLead>.from(json["data"].map((x) => DatumCrmLead.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "length": length,
        "fields": fields.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DatumCrmLead {
    int id;
    List<StructCombos> activityIds;
    CampaignId? campaignId;
    CampaignId lostReasonId;
    CampaignId title;
    String? contactName;
    StructCombos countryId;
    DateTime? dateOpen;
    DateTime? dateClose;
    double dayClose;
    String? description;
    String emailFrom;    
    StructCombos mediumId;
    String name;
    StructCombos partnerId;
    String? partnerName;
    String? phone;
    String priority;
    StructCombos sourceId;
    StructCombos stageId;
    StructCombos stateId;    
    List<dynamic> tagIds;    
    String type;
    String? city;
    String? emailCc;
    String mobile;
    String? street;
    DateTime? dateDeadline;
    double? probability;
    StructCombos? userId;
    double expectedRevenue;
    String? referred;

    DatumCrmLead({
        required this.id,
        required this.activityIds,
        required this.campaignId,
        this.contactName,
        required this.countryId,
        this.dateOpen,
        required this.dayClose,
        this.description,
        required this.emailFrom,
        required this.lostReasonId,
        required this.mediumId,
        required this.name,
        required this.partnerId,
        this.partnerName,
        this.phone,
        required this.priority,
        required this.sourceId,
        required this.stageId,
        required this.stateId,
        required this.tagIds,
        required this.title,
        required this.type,
        required this.expectedRevenue,
        this.city,
        this.emailCc,
        required this.mobile,
        this.street,
        this.dateDeadline,
        this.probability,
        this.dateClose,
        this.userId,
        this.referred
    });

    factory DatumCrmLead.fromJson(String str) => DatumCrmLead.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DatumCrmLead.fromMap(Map<String, dynamic> json) => DatumCrmLead(
        id: json["id"],
        activityIds: List<StructCombos>.from(json["activity_ids"].map((x) => StructCombos.fromMap(x))),
        campaignId: CampaignId.fromMap(json["campaign_id"]),
        contactName: json["contact_name"],
        countryId: StructCombos.fromMap(json["country_id"]),
        dateOpen: json["date_open"] == null ? null : DateTime.parse(json["date_open"]),
        dateClose: json["date_closed"] == null ? null : DateTime.parse(json["date_closed"]),
        dayClose: json["day_close"] ?? 0,
        description: json["description"],
        emailFrom: json["email_from"] ?? '',
        lostReasonId: CampaignId.fromMap(json["lost_reason_id"]),
        mediumId: StructCombos.fromMap(json["medium_id"]),
        name: json["name"],
        partnerId: StructCombos.fromMap(json["partner_id"]),
        partnerName: json["partner_name"],
        phone: json["phone"],
        priority: json["priority"],
        sourceId: StructCombos.fromMap(json["source_id"]),
        stageId: StructCombos.fromMap(json["stage_id"]),
        stateId: StructCombos.fromMap(json["state_id"]),
        tagIds: List<dynamic>.from(json["tag_ids"].map((x) => x)),
        title: CampaignId.fromMap(json["title"]),
        type: json["type"],
        city: json["city"],
        emailCc: json["email_cc"],
        mobile: json["mobile"] ?? '',
        street: json["street"] ?? '',
        dateDeadline: json['date_deadline'] == null ? DateTime.now() : DateTime.parse(json['date_deadline']),
        probability: json["probability"] ?? 0,
        userId: json["user_id"] == null ? null : StructCombos.fromMap(json["user_id"]),
        expectedRevenue: json["expected_revenue"] ?? 0,
        referred: json["referred"] ?? ''        
    );

    factory DatumCrmLead.fromMap2(Map<String, dynamic> json) {

      return DatumCrmLead(
        id: json['id'],
        activityIds: (json['activity_ids'] as List<dynamic>)
            .map((item) => StructCombos.fromJson2(jsonDecode(item)))
            .toList(),
        campaignId: json['campaign_id'].toString() == "{}" ? CampaignId(id: 0, name: '') : CampaignId.fromJson2(jsonDecode(json['campaign_id'])),
        contactName: json['contact_name'],
        countryId: json['country_id'].toString() == "{}" ? StructCombos(id: 0, name: '') : StructCombos.fromJson2(jsonDecode(json['country_id'])),
        dateOpen: json['date_open'] == null ? DateTime.now() : DateTime.parse(json['date_open']),
        dateClose: json['date_Close'] == null ? DateTime.now() : DateTime.parse(json['date_Close']),
        dayClose: (json['day_close'] as num).toDouble(),
        description: json['description'],
        emailFrom: json['email_from'],
        lostReasonId: json['lost_reason_id'].toString() == "{}" ? CampaignId(id: 0, name: '') : CampaignId.fromJson2(jsonDecode(json['lost_reason_id'])),//json['lost_reason_id'],
        mediumId: json['medium_id'].toString() == "{}" ? StructCombos(id: 0, name: '') : StructCombos.fromJson2(jsonDecode(json['medium_id'])),
        name: json['name'],
        partnerId: json['partner_id'].toString() == "{}" ? StructCombos(id: 0, name: '') : StructCombos.fromJson2(jsonDecode(json['partner_id'])),
        partnerName: json['partner_name'],
        phone: json['phone'],
        priority: json['priority'],
        sourceId: json['source_id'].toString() == "{}" ? StructCombos(id: 0, name: '') : StructCombos.fromJson2(jsonDecode(json['source_id'])),
        stageId: json['stage_id'].toString() == "{}" ? StructCombos(id: 0, name: '') : StructCombos.fromJson2(jsonDecode(json['stage_id'])),
        stateId: json['state_id'].toString() == "{}" ? StructCombos(id: 0, name: '') : StructCombos.fromJson2(jsonDecode(json['state_id'])),
        tagIds: json['tag_ids'] as List<dynamic>,
        title: json['title'].toString() == "{}" ? CampaignId(id: 0, name: '') : CampaignId.fromJson2(jsonDecode(json['title'])),
        type: json['type'],
        city: json['city'],
        emailCc: json['email_cc'],
        mobile: json['mobile'],
        street: json['street'],
        dateDeadline: json['date_deadline'] == null ? DateTime.now() : DateTime.parse(json['date_deadline']),
        probability: (json['probability'] as num).toDouble(),
        userId: json['user_id'],
        expectedRevenue: (json['expected_revenue'] as num).toDouble(),
        referred: json['referred'],
      );
    }

    Map<String, dynamic> toJson2() {
    return {
      'id': id,
      'activity_ids': activityIds.map((activity) => jsonEncode(activity.toJson())).toList(),
      'campaign_id': campaignId?.toJson(),
      'contact_name': contactName,
      'country_id': jsonEncode(countryId.toJson()),
      'date_open': dateOpen?.toIso8601String(),
      'date_Close': dateClose?.toIso8601String(),
      'day_close': dayClose,
      'description': description,
      'email_from': emailFrom,
      'lost_reason_id': lostReasonId,
      'medium_id': jsonEncode(mediumId.toJson()),
      'name': name,
      'partner_id': jsonEncode(partnerId.toJson()),
      'partner_name': partnerName,
      'phone': phone,
      'priority': priority,
      'source_id': jsonEncode(sourceId.toJson()),
      'stage_id': jsonEncode(stageId.toJson()),
      'state_id': jsonEncode(stateId.toJson()),
      'tag_ids': tagIds,
      'title': title,
      'type': type,
      'city': city,
      'email_cc': emailCc,
      'mobile': mobile,
      'street': street,
      'date_deadline': dateDeadline,
      'probability': probability,
      'user_id': userId,
      'expected_revenue': expectedRevenue,
      'referred': referred
    };
  }

    Map<String, dynamic> toMap() => {
        "id": id,
        "activity_ids": List<dynamic>.from(activityIds.map((x) => x.toJson())),
        "campaign_id": campaignId?.toJson(),
        "contact_name": contactName,
        "country_id": countryId.toJson(),
        "date_open": dateOpen?.toIso8601String(),
        "date_Close": dateClose?.toIso8601String(),
        "day_close": dayClose,
        "description": description,
        "email_from": emailFrom,
        "lost_reason_id": lostReasonId.toJson(),
        "medium_id": mediumId.toJson(),
        "name": name,
        "partner_id": partnerId.toJson(),
        "partner_name": partnerName,
        "phone": phone,
        "priority": priority,
        "source_id": sourceId.toJson(),
        "stage_id": stageId.toJson(),
        "state_id": stateId.toJson(),
        "tag_ids": List<dynamic>.from(tagIds.map((x) => x)),
        "title": title.toJson(),
        "type": type,
        "city": city,
        "email_cc": emailCc,
        "mobile": mobile,
        "street": street,
        "date_deadline": "${dateDeadline?.year.toString().padLeft(4, '0')}-${dateDeadline?.month.toString().padLeft(2, '0')}-${dateDeadline?.day.toString().padLeft(2, '0')}",
        "probability": 0,
        "user_id": userId?.toJson(),
        "expected_revenue": expectedRevenue,
        "referred": referred
    };
}

//ESTA ESTRUCTURA NO LLEGABA DESDE EL API Y TUVE QUE IMPROVISAR LOS CAMPOS
class CampaignId {
  int id;
  String name;
  
  CampaignId(
    {
      required this.id,
      required this.name
    }
  );

    factory CampaignId.fromJson(String str) => CampaignId.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CampaignId.fromMap(Map<String, dynamic> json) => CampaignId(
      id: json["id"] ?? 0,
      name: json["name"] ?? '',
    );

    factory CampaignId.fromJson2(Map<String, dynamic> json) {
      //print('Tst json2 CampaignId: $json');
      return CampaignId(
        id: json['id'] ?? 0,
        name: json['name'] ?? ''
      );
    }

    Map<String, dynamic> toMap() => {
    };
}

class FieldsCrmLead {
    String activityIds;
    String campaignId;
    String city;
    String contactName;
    String countryId;
    String dateClosed;
    String dateDeadline;
    String dateOpen;
    String dayClose;
    String description;
    String emailCc;
    String emailFrom;
    String function;
    String lostReasonId;
    String mediumId;
    String mobile;
    String name;
    String partnerId;
    String partnerName;
    String phone;
    String priority;
    String sourceId;
    String stageId;
    String stateId;
    String street;
    String tagIds;
    String title;
    String type;

    FieldsCrmLead({
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
        required this.function,
        required this.lostReasonId,
        required this.mediumId,
        required this.mobile,
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
    });

    factory FieldsCrmLead.fromJson(String str) => FieldsCrmLead.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory FieldsCrmLead.fromMap(Map<String, dynamic> json) => FieldsCrmLead(
        activityIds: json["activity_ids"],
        campaignId: json["campaign_id"],
        city: json["city"],
        contactName: json["contact_name"],
        countryId: json["country_id"],
        dateClosed: json["date_closed"],
        dateDeadline: json["date_deadline"],
        dateOpen: json["date_open"],
        dayClose: json["day_close"],
        description: json["description"],
        emailCc: json["email_cc"],
        emailFrom: json["email_from"],
        function: json["function"],
        lostReasonId: json["lost_reason_id"],
        mediumId: json["medium_id"],
        mobile: json["mobile"],
        name: json["name"],
        partnerId: json["partner_id"],
        partnerName: json["partner_name"],
        phone: json["phone"],
        priority: json["priority"],
        sourceId: json["source_id"],
        stageId: json["stage_id"],
        stateId: json["state_id"],
        street: json["street"],
        tagIds: json["tag_ids"],
        title: json["title"],
        type: json["type"],
    );

    Map<String, dynamic> toMap() => {
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
        "function": function,
        "lost_reason_id": lostReasonId,
        "medium_id": mediumId,
        "mobile": mobile,
        "name": name,
        "partner_id": partnerId,
        "partner_name": partnerName,
        "phone": phone,
        "priority": priority,
        "source_id": sourceId,
        "stage_id": stageId,
        "state_id": stateId,
        "street": street,
        "tag_ids": tagIds,
        "title": title,
        "type": type,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}

class StructCombos {
    int id;
    String name;

    StructCombos({
        required this.id,
        required this.name
    });

    factory StructCombos.fromJson(String str) => StructCombos.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory StructCombos.fromMap(Map<String, dynamic> json) => StructCombos(
        id: json["id"] ?? 0,
        name: json["name"] ?? ''
    );

    factory StructCombos.fromJson2(Map<String, dynamic> json) {
      return StructCombos(
        id: json['id'] ?? 0,
        name: json['name'] ?? ''
      );
    }

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name
    };
}

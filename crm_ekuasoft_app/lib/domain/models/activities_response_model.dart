import 'dart:convert';

//import 'package:cvs_ec_app/domain/domain.dart';

class ActivitiesResponseModel {
    int length;
    FieldsActivities fields;
    List<DatumActivitiesResponse> data;
    //List<DatumMailMessage> dataMessage;

    ActivitiesResponseModel({
        required this.length,
        required this.fields,
        required this.data,
        //required this.dataMessage
    });

    factory ActivitiesResponseModel.fromRawJson(String str) => ActivitiesResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ActivitiesResponseModel.fromJson(Map<String, dynamic> json) => ActivitiesResponseModel(
        length: json["length"] ?? 0,
        fields: FieldsActivities.fromJson(json["fields"]),
        data: List<DatumActivitiesResponse>.from(json["data"].map((x) => DatumActivitiesResponse.fromJson(x))),
        //dataMessage: []
    );

    Map<String, dynamic> toJson() => {
        "length": length,
        "fields": fields.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        //"dataMessage": List<dynamic>.from(dataMessage.map((x) => x.toJson())),
    };
}

class DatumActivitiesResponse {
    int id;
    DateTime dateDeadline;    
    int resId;
    String resModel;
    IdActivities activityTypeId;
    IdActivities userId;
    String? summary;
    //String? contactName;
    bool cerrado;

    DatumActivitiesResponse({
        required this.id,
        required this.dateDeadline,
        required this.resId,
        required this.resModel,
        required this.activityTypeId,
        required this.userId,
        required this.summary,
        required this.cerrado,
        //required this.contactName
    });

    factory DatumActivitiesResponse.fromRawJson(String str) => DatumActivitiesResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DatumActivitiesResponse.fromJson(Map<String, dynamic> json) => DatumActivitiesResponse(
        id: json["id"] ?? 0,
        dateDeadline: DateTime.parse(json["date_deadline"]),
        resId: json["res_id"],
        resModel: json["res_model"],
        activityTypeId: IdActivities.fromJson(json["activity_type_id"]),
        userId: IdActivities.fromJson(json["user_id"]),
        summary: json["summary"] ?? '',
        cerrado: json["cerrado"] ?? false,
        //contactName: json["contact_name"] ?? ''
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "date_deadline": "${dateDeadline.year.toString().padLeft(4, '0')}-${dateDeadline.month.toString().padLeft(2, '0')}-${dateDeadline.day.toString().padLeft(2, '0')}",
        "res_id": resId,
        "res_model": resModel,
        "activity_type_id": activityTypeId.toJson(),
        "user_id": userId.toJson(),
        "summary": summary,
        "cerrado": cerrado,
        //"contact_name": contactName,
    };
}

class IdActivities {
    int id;
    String name;

    IdActivities({
        required this.id,
        required this.name,
    });

    factory IdActivities.fromRawJson(String str) => IdActivities.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory IdActivities.fromJson(Map<String, dynamic> json) => IdActivities(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}

class FieldsActivities {
    String? code;
    String? name;
    String? stateIds;

    FieldsActivities({
        required this.code,
        required this.name,
        required this.stateIds,
    });

    factory FieldsActivities.fromRawJson(String str) => FieldsActivities.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory FieldsActivities.fromJson(Map<String, dynamic> json) => FieldsActivities(
        code: json["code"] ?? '0',
        name: json["name"] ?? '',
        stateIds: json["state_ids"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "state_ids": stateIds,
    };
}

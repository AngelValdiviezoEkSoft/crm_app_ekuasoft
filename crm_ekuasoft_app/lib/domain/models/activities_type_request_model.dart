import 'dart:convert';

class ActivitiesTypeRequestModel {
    int resId;
    int actId;
    int createUid;
    int userId;
    int userCreateId;
    bool active;
    String displayName;
    DateTime? createDate;
    DateTime? dateDeadline;
    int previousActivityTypeId;
    String note;
    String summary;
    int activityTypeId;
    double workingTime;

    ActivitiesTypeRequestModel({
      required this.resId,
      required this.actId,
      required this.userId,
        required this.createUid,
        required this.createDate,
        required this.active,
        required this.previousActivityTypeId,
        required this.displayName,
        required this.note,
        required this.activityTypeId,
        required this.dateDeadline,
        required this.userCreateId,
        required this.workingTime,
        required this.summary
    });

    factory ActivitiesTypeRequestModel.fromJson(String str) => ActivitiesTypeRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ActivitiesTypeRequestModel.fromMap(Map<String, dynamic> json) => ActivitiesTypeRequestModel(
      resId: json["resId"] ?? 0,
      actId: json["actId"] ?? 0,
      userId: json["user_id"] ?? 0,
      createUid: json["create_uid"] ?? 0,
      createDate: json["create_date"] == null ? null : DateTime.parse(json["create_date"]),
      dateDeadline: json['date_deadline'] == null ? DateTime.now() : DateTime.parse(json['date_deadline']),
      active: json["active"] ?? false,
      previousActivityTypeId: json["previous_activity_type_id"] ?? 0,
      displayName: json["display_name"] ?? '',
      note: json["note"] ?? '',
      activityTypeId: json["activity_type_id"] ?? 0,
      userCreateId: json["activity_type_id"] ?? 0,
      workingTime: 0,
      summary: json["summary"] ?? ''
    );

    factory ActivitiesTypeRequestModel.fromMap2(Map<String, dynamic> json) {

      return ActivitiesTypeRequestModel(
        summary: json["summary"] ?? '',
        actId: json["actId"],
        resId: json["resId"],
        userCreateId: json['user_id'],
        userId: json['user_id'],
        createUid: json['create_uid'],
        active: json['active'],
        createDate: json['create_date'] == null ? DateTime.now() : DateTime.parse(json['create_date']),
        dateDeadline: json['date_deadline'] == null ? DateTime.now() : DateTime.parse(json['date_deadline']),
        previousActivityTypeId: json["previous_activity_type_id"],
        displayName: json["display_name"],
        note: json["note"],
        activityTypeId: json["activity_type_id"],
        workingTime: 0
      );
    }

    Map<String, dynamic> toJson2() {
    return {
      'resId': resId,
      'actId': actId,
      'userCreateId': userCreateId,
      'user_id': userId,
      'create_uid': createUid,
      'active': active,
      'create_date': createDate?.toIso8601String(),      
      'date_deadline': dateDeadline?.toIso8601String(),      
      'previous_activity_type_id': previousActivityTypeId,
      'display_name': displayName,
      'note': note,
      'activity_type_id': activityTypeId,
      'workingTime': workingTime,
      'summary': summary
    };
  }

    Map<String, dynamic> toMap() => {
      'resId': resId,
      'actId': actId,
      'userCreateId': userCreateId,
      'user_id': userId,
      'create_uid': createUid,
      'active': active,
      'create_date': createDate?.toIso8601String(),
      'date_deadline': dateDeadline?.toIso8601String(),      
      'previous_activity_type_id': previousActivityTypeId,
      'display_name': displayName,
      'note': note,
      'activity_type_id': activityTypeId,
      'workingTime': workingTime,
      'summary': summary
    };
}

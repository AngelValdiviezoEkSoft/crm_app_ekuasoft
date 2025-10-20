import 'dart:convert';

class ActivitiesClosedResponseModel {
  final String jsonrpc;
  final dynamic id;
  final ActivitiesClosedModel result;

  ActivitiesClosedResponseModel({
    required this.jsonrpc,
    this.id,
    required this.result,
  });

  factory ActivitiesClosedResponseModel.fromRawJson(String str) => ActivitiesClosedResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ActivitiesClosedResponseModel.fromJson(Map<String, dynamic> json) {
    return ActivitiesClosedResponseModel(
      jsonrpc: json['jsonrpc'] ?? '',
      id: json['id'],
      result: ActivitiesClosedModel.fromJson(json['result'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'jsonrpc': jsonrpc,
        'id': id,
        'result': result.toJson(),
      };
}

class ActivitiesClosedModel {
  final int estado;
  final MailMessageDataWrapper data;

  ActivitiesClosedModel({
    required this.estado,
    required this.data,
  });

  factory ActivitiesClosedModel.fromJson(Map<String, dynamic> json) {
    return ActivitiesClosedModel(
      estado: json['estado'] ?? 0,
      data: MailMessageDataWrapper.fromJson(json['data']?['mail.message'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'estado': estado,
        'data': {'mail.message': data.toJson()},
      };
}

class MailMessageDataWrapper {
  final int length;
  final Map<String, String> fields;
  final List<MailMessageClosed> data;

  MailMessageDataWrapper({
    required this.length,
    required this.fields,
    required this.data,
  });

  factory MailMessageDataWrapper.fromJson(Map<String, dynamic> json) {
    return MailMessageDataWrapper(
      length: json['length'] ?? 0,
      fields: Map<String, String>.from(json['fields'] ?? {}),
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => MailMessageClosed.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'length': length,
        'fields': fields,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class MailMessageClosed {
  final int id;
  final String lastUpdate;
  final String summary;
  final String activityDateDeadLine;
  final String? activityDueDate;
  final Many2OneClosed? activityTypeId;
  final bool addSign;
  final List<dynamic> attachmentIds;
  final String? authorAvatar;
  final Many2OneClosed? authorId;
  final String? body;
  final String? createDate;
  final Many2OneClosed? createUid;
  final String? date;
  final String? description;
  final String? displayName;
  final bool hasError;
  final bool hasSmsError;
  final bool isCurrentUserOrGuestAuthor;
  final bool isDoneApp;
  final bool isInternal;
  final String? leadName;
  final String? leadPhone;
  final Many2OneClosed? mailActivityTypeId;
  final String? messageId;
  final String? messageType;
  final String? model;
  final bool needAction;
  final Many2OneClosed? parentId;
  final double ratingValue;
  final String? recordName;
  final String? replyTo;
  final bool replyToForceNew;
  final int? resId;
  final double scheduledTime;
  final bool snailmailError;
  final bool starred;
  final Many2OneClosed? subtypeId;
  final Many2OneClosed? userId;
  final double workingTime;
  final String? writeDate;
  final Many2OneClosed? writeUid;
  final DateTime? activityCreateDate;
  final String? activityCategory;

  MailMessageClosed({
    required this.id,
    required this.lastUpdate,
    this.activityDueDate,
    this.activityTypeId,
    required this.addSign,
    required this.attachmentIds,
    this.authorAvatar,
    this.authorId,
    this.body,
    this.createDate,
    this.createUid,
    this.date,
    this.description,
    this.displayName,
    required this.hasError,
    required this.summary,
    required this.hasSmsError,
    required this.isCurrentUserOrGuestAuthor,
    required this.isDoneApp,
    required this.isInternal,
    this.leadName,
    this.leadPhone,
    this.mailActivityTypeId,
    this.messageId,
    this.messageType,
    this.model,
    required this.needAction,
    this.parentId,
    required this.ratingValue,
    this.recordName,
    this.replyTo,
    required this.replyToForceNew,
    this.resId,
    required this.scheduledTime,
    required this.snailmailError,
    required this.starred,
    this.subtypeId,
    this.userId,
    required this.workingTime,
    this.writeDate,
    this.writeUid,
    required this.activityDateDeadLine,
    required this.activityCreateDate,
    required this.activityCategory
  });

  factory MailMessageClosed.fromJson(Map<String, dynamic> json) {
    return MailMessageClosed(
      id: json['id'] ?? 0,
      lastUpdate: json['__last_update'] ?? '',
      activityCategory: json['activity_category'] ?? '',
      activityDateDeadLine: json['activity_date_deadline'] ?? '',
      summary: json['activity_summary'] ?? '',
      activityDueDate: json['activity_due_date'],
      activityCreateDate: json['activity_create_date'] != null ? DateTime.parse(json['activity_create_date']) : null,
      activityTypeId: json['activity_type_id'] != null
          ? Many2OneClosed.fromJson(json['activity_type_id'])
          : null,
      addSign: json['add_sign'] ?? false,
      attachmentIds: List<dynamic>.from(json['attachment_ids'] ?? []),
      authorAvatar: json['author_avatar'],
      authorId: json['author_id'] != null
          ? Many2OneClosed.fromJson(json['author_id'])
          : null,
      body: json['body'],
      createDate: json['create_date'],
      createUid: json['create_uid'] != null
          ? Many2OneClosed.fromJson(json['create_uid'])
          : null,
      date: json['date'],
      description: json['description'],
      displayName: json['display_name'],
      hasError: json['has_error'] ?? false,
      hasSmsError: json['has_sms_error'] ?? false,
      isCurrentUserOrGuestAuthor:
          json['is_current_user_or_guest_author'] ?? false,
      isDoneApp: json['is_done_app'] ?? false,
      isInternal: json['is_internal'] ?? false,
      leadName: json['lead_name'],
      leadPhone: json['lead_phone'],
      mailActivityTypeId: json['mail_activity_type_id'] != null
          ? Many2OneClosed.fromJson(json['mail_activity_type_id'])
          : null,
      messageId: json['message_id'],
      messageType: json['message_type'],
      model: json['model'],
      needAction: json['needaction'] ?? false,
      parentId: json['parent_id'] != null
          ? Many2OneClosed.fromJson(json['parent_id'])
          : null,
      ratingValue: (json['rating_value'] ?? 0).toDouble(),
      recordName: json['record_name'],
      replyTo: json['reply_to'],
      replyToForceNew: json['reply_to_force_new'] ?? false,
      resId: json['res_id'],
      scheduledTime: (json['scheduled_time'] ?? 0).toDouble(),
      snailmailError: json['snailmail_error'] ?? false,
      starred: json['starred'] ?? false,
      subtypeId: json['subtype_id'] != null
          ? Many2OneClosed.fromJson(json['subtype_id'])
          : null,
      userId: json['user_id'] != null
          ? Many2OneClosed.fromJson(json['user_id'])
          : null,
      workingTime: (json['working_time'] ?? 0).toDouble(),
      writeDate: json['write_date'],
      writeUid: json['write_uid'] != null
          ? Many2OneClosed.fromJson(json['write_uid'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'activity_category': activityCategory,
        'activity_summary': summary,
        'activity_date_deadline': activityDateDeadLine,
        '__last_update': lastUpdate,
        'activity_due_date': activityDueDate,
        'activity_type_id': activityTypeId?.toJson(),
        'add_sign': addSign,
        'attachment_ids': attachmentIds,
        'author_avatar': authorAvatar,
        'author_id': authorId?.toJson(),
        'body': body,
        'create_date': createDate,
        'create_uid': createUid?.toJson(),
        'date': date,
        'description': description,
        'display_name': displayName,
        'has_error': hasError,
        'has_sms_error': hasSmsError,
        'is_current_user_or_guest_author': isCurrentUserOrGuestAuthor,
        'is_done_app': isDoneApp,
        'is_internal': isInternal,
        'lead_name': leadName,
        'lead_phone': leadPhone,
        'mail_activity_type_id': mailActivityTypeId?.toJson(),
        'message_id': messageId,
        'message_type': messageType,
        'model': model,
        'needaction': needAction,
        'parent_id': parentId?.toJson(),
        'rating_value': ratingValue,
        'record_name': recordName,
        'reply_to': replyTo,
        'reply_to_force_new': replyToForceNew,
        'res_id': resId,
        'scheduled_time': scheduledTime,
        'snailmail_error': snailmailError,
        'starred': starred,
        'subtype_id': subtypeId?.toJson(),
        'user_id': userId?.toJson(),
        'working_time': workingTime,
        'write_date': writeDate,
        'write_uid': writeUid?.toJson(),
      };
}

class Many2OneClosed {
  final int? id;
  final dynamic name;

  Many2OneClosed({this.id, this.name});

  factory Many2OneClosed.fromJson(Map<String, dynamic> json) {
    return Many2OneClosed(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

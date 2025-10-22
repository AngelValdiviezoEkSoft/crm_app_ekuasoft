import 'dart:convert';

import 'package:crm_ekuasoft_app/common/common.dart';
import 'package:intl/intl.dart';

class NotasInternasResponse {
  final String jsonrpc;
  final dynamic id;
  final NotasResponseModel? result;

  NotasInternasResponse({
    required this.jsonrpc,
    this.id,
    this.result,
  });

  factory NotasInternasResponse.fromJson(Map<String, dynamic> json) => NotasInternasResponse(
        jsonrpc: json['jsonrpc'] ?? '',
        id: json['id'],
        result: json['result'] != null ? NotasResponseModel.fromJson(json['result']) : null,
      );

  Map<String, dynamic> toJson() => {
        'jsonrpc': jsonrpc,
        'id': id,
        'result': result?.toJson(),
      };

  static NotasInternasResponse fromRawJson(String str) => NotasInternasResponse.fromJson(json.decode(str));
  
  String toRawJson() => json.encode(toJson());
}

/// Nivel: result
class NotasResponseModel {
  final int estado;
  final NotasResponseModelData? data;

  NotasResponseModel({required this.estado, this.data});

  factory NotasResponseModel.fromJson(Map<String, dynamic> json) => NotasResponseModel(
        estado: json['estado'] ?? 0,
        data: json['data'] != null ? NotasResponseModelData.fromJson(json['data']) : null,
      );

  Map<String, dynamic> toJson() => {
        'estado': estado,
        'data': data?.toJson(),
      };
}

/// Nivel: data -> mail.message
class NotasResponseModelData {
  final MailMessageNotasResponse? mailMessage;

  NotasResponseModelData({this.mailMessage});

  factory NotasResponseModelData.fromJson(Map<String, dynamic> json) => NotasResponseModelData(
        mailMessage: json['mail.message'] != null
            ? MailMessageNotasResponse.fromJson(json['mail.message'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'mail.message': mailMessage?.toJson(),
      };
}

/// mail.message contiene fields + data
class MailMessageNotasResponse {
  final int length;
  final Map<String, String>? fields;
  final List<MessageData>? data;

  MailMessageNotasResponse({
    required this.length,
    this.fields,
    this.data,
  });

  factory MailMessageNotasResponse.fromJson(Map<String, dynamic> json) => MailMessageNotasResponse(
        length: json['length'] ?? 0,
        fields: json['fields'] != null
            ? Map<String, String>.from(json['fields'])
            : null,
        data: json['data'] != null
            ? List<MessageData>.from(
                json['data'].map((x) => MessageData.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        'length': length,
        'fields': fields,
        'data': data?.map((x) => x.toJson()).toList(),
      };
}

/// Datos individuales dentro de mail.message.data
class MessageData {
  final int id;
  final String? lastUpdate;
  final bool? addSign;
  final String? authorAvatar;
  final RelatedField? authorId;
  final RelatedField? createUid;
  final String? body;
  final String? createDate;
  final String? date;
  final String? description;
  final String? displayName;
  final String? emailFrom;
  final bool? hasError;
  final bool? hasSmsError;
  final bool? isDoneApp;
  final bool? isInternal;
  final String? messageId;
  final String? messageType;
  final String? model;
  final String? recordName;
  final String? replyTo;
  final int? resId;
  final bool? starred;
  final RelatedField? subtypeId;
  final double? ratingValue;
  final String? writeDate;
  final RelatedField? writeUid;

  MessageData({
    required this.id,
    this.lastUpdate,
    this.addSign,
    this.authorAvatar,
    this.authorId,
    this.createUid,
    this.body,
    this.createDate,
    this.date,
    this.description,
    this.displayName,
    this.emailFrom,
    this.hasError,
    this.hasSmsError,
    this.isDoneApp,
    this.isInternal,
    this.messageId,
    this.messageType,
    this.model,
    this.recordName,
    this.replyTo,
    this.resId,
    this.starred,
    this.subtypeId,
    this.ratingValue,
    this.writeDate,
    this.writeUid,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) => MessageData(
        id: json['id'] ?? 0,
        lastUpdate: json['__last_update'],
        addSign: json['add_sign'],
        authorAvatar: json['author_avatar'],
        authorId: json['author_id'] != null && json['author_id'] is Map
            ? RelatedField.fromJson(json['author_id'])
            : null,
        createUid: json['create_uid'] != null && json['create_uid'] is Map
            ? RelatedField.fromJson(json['create_uid'])
            : null,
        body: json['body'],
        createDate: DateFormat('dd/MM/yyyy HH:mm:ss').format(UtilitiesCommon().parseToLocal(json['create_date'])),
        date: json['date'],
        description: json['description'],
        displayName: json['display_name'],
        emailFrom: json['email_from'],
        hasError: json['has_error'],
        hasSmsError: json['has_sms_error'],
        isDoneApp: json['is_done_app'],
        isInternal: json['is_internal'],
        messageId: json['message_id'],
        messageType: json['message_type'],
        model: json['model'],
        recordName: json['record_name'],
        replyTo: json['reply_to'],
        resId: json['res_id'],
        starred: json['starred'],
        subtypeId: json['subtype_id'] != null && json['subtype_id'] is Map
            ? RelatedField.fromJson(json['subtype_id'])
            : null,
        ratingValue: (json['rating_value'] ?? 0).toDouble(),
        writeDate: json['write_date'],
        writeUid: json['write_uid'] != null && json['write_uid'] is Map
            ? RelatedField.fromJson(json['write_uid'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        '__last_update': lastUpdate,
        'add_sign': addSign,
        'author_avatar': authorAvatar,
        'author_id': authorId?.toJson(),
        'create_uid': createUid?.toJson(),
        'body': body,
        'create_date': createDate,
        'date': date,
        'description': description,
        'display_name': displayName,
        'email_from': emailFrom,
        'has_error': hasError,
        'has_sms_error': hasSmsError,
        'is_done_app': isDoneApp,
        'is_internal': isInternal,
        'message_id': messageId,
        'message_type': messageType,
        'model': model,
        'record_name': recordName,
        'reply_to': replyTo,
        'res_id': resId,
        'starred': starred,
        'subtype_id': subtypeId?.toJson(),
        'rating_value': ratingValue,
        'write_date': writeDate,
        'write_uid': writeUid?.toJson(),
      };
}

/// Modelo para campos relacionados (many2one)
class RelatedField {
  final int? id;
  final dynamic name;

  RelatedField({this.id, this.name});

  factory RelatedField.fromJson(Map<String, dynamic> json) => RelatedField(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

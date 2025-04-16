import 'dart:convert';

class MailMessageResponseModel {
    String jsonrpc;
    dynamic id;
    MailMessageModel result;

    MailMessageResponseModel({
        required this.jsonrpc,
        required this.id,
        required this.result,
    });

    factory MailMessageResponseModel.fromRawJson(String str) => MailMessageResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MailMessageResponseModel.fromJson(Map<String, dynamic> json) => MailMessageResponseModel(
        jsonrpc: json["jsonrpc"] ?? '',
        id: json["id"] ?? 0,
        result: json["result"] != null ? MailMessageModel.fromJson(json["result"])
        : MailMessageModel(data: DataMailMessageModel(mailMessage: MailMessage(data: [], length: 0)), estado: 0),
    );

    Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result.toJson(),
    };
}

class MailMessageModel {
    int estado;
    DataMailMessageModel data;

    MailMessageModel({
        required this.estado,
        required this.data,
    });

    factory MailMessageModel.fromRawJson(String str) => MailMessageModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MailMessageModel.fromJson(Map<String, dynamic> json) => MailMessageModel(
        estado: json["estado"] ?? 0,
        data: json["data"] != null ? DataMailMessageModel.fromJson(json["data"]) : DataMailMessageModel(mailMessage: MailMessage(data: [], length: 0)),
    );

    Map<String, dynamic> toJson() => {
        "estado": estado,
        "data": data.toJson(),
    };
}

class DataMailMessageModel {
    MailMessage mailMessage;

    DataMailMessageModel({
        required this.mailMessage,
    });

    factory DataMailMessageModel.fromRawJson(String str) => DataMailMessageModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DataMailMessageModel.fromJson(Map<String, dynamic> json) => DataMailMessageModel(
        mailMessage: json["mail.message"] != null ? MailMessage.fromJson(json["mail.message"]) : MailMessage(data: [], length: 0),
    );

    Map<String, dynamic> toJson() => {
        "mail.message": mailMessage.toJson(),
    };
}

class MailMessage {
    int length;
    List<DatumMailMessage> data;

    MailMessage({
        required this.length,
        required this.data,
    });

    factory MailMessage.fromRawJson(String str) => MailMessage.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MailMessage.fromJson(Map<String, dynamic> json) => MailMessage(
        length: json["length"] ?? 0,
        data: json["data"] != null ? List<DatumMailMessage>.from(json["data"].map((x) => DatumMailMessage.fromJson(x))) : [],
    );

    Map<String, dynamic> toJson() => {
        "length": length,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DatumMailMessage {
    int id;
    List<dynamic> attachmentIds;
    String authorAvatar;
    AuthorId authorGuestId;
    AuthorId authorId;
    String body;
    DateTime date;
    DateTime dateDeadLine;
    String description;
    bool emailAddSignature;
    String emailFrom;
    String emailLayoutXmlid;
    bool hasError;
    bool hasSmsError;
    bool isCurrentUserOrGuestAuthor;
    bool isDoneApp;
    bool isInternal;
    List<dynamic> letterIds;
    List<dynamic> linkPreviewIds;
    AuthorId mailActivityTypeId;
    List<dynamic> mailIds;
    AuthorId mailServerId;
    String messageId;
    String messageType;
    String model;
    bool needaction;
    List<dynamic> notificationIds;
    List<dynamic> notifiedPartnerIds;
    AuthorId parentId;
    List<AuthorId> partnerIds;
    String preview;
    List<dynamic> ratingIds;
    double ratingValue;
    List<dynamic> reactionIds;
    AuthorId recordAliasDomainId;
    AuthorId recordCompanyId;
    String recordName;
    String replyTo;
    bool replyToForceNew;
    int resId;
    bool snailmailError;
    bool starred;
    List<dynamic> starredPartnerIds;
    String subject;
    AuthorId subtypeId;
    List<dynamic> trackingValueIds;
    List<dynamic> waMessageIds;
    double workingTime;
    DateTime writeDate;
    AuthorId writeUid;

    DatumMailMessage({
        required this.id,
        required this.attachmentIds,
        required this.authorAvatar,
        required this.authorGuestId,
        required this.authorId,
        required this.body,
        required this.date,
        required this.dateDeadLine,
        required this.description,
        required this.emailAddSignature,
        required this.emailFrom,
        required this.emailLayoutXmlid,
        required this.hasError,
        required this.hasSmsError,
        required this.isCurrentUserOrGuestAuthor,
        required this.isDoneApp,
        required this.isInternal,
        required this.letterIds,
        required this.linkPreviewIds,
        required this.mailActivityTypeId,
        required this.mailIds,
        required this.mailServerId,
        required this.messageId,
        required this.messageType,
        required this.model,
        required this.needaction,
        required this.notificationIds,
        required this.notifiedPartnerIds,
        required this.parentId,
        required this.partnerIds,
        required this.preview,
        required this.ratingIds,
        required this.ratingValue,
        required this.reactionIds,
        required this.recordAliasDomainId,
        required this.recordCompanyId,
        required this.recordName,
        required this.replyTo,
        required this.replyToForceNew,
        required this.resId,
        required this.snailmailError,
        required this.starred,
        required this.starredPartnerIds,
        required this.subject,
        required this.subtypeId,
        required this.trackingValueIds,
        required this.waMessageIds,
        required this.workingTime,
        required this.writeDate,
        required this.writeUid,
    });

    factory DatumMailMessage.fromRawJson(String str) => DatumMailMessage.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DatumMailMessage.fromJson(Map<String, dynamic> json) => DatumMailMessage(
        id: json["id"] ?? 0,
        attachmentIds: json["attachment_ids"] != null ? List<dynamic>.from(json["attachment_ids"].map((x) => x)) : [],
        authorAvatar: json["author_avatar"] ?? '',
        authorGuestId: json["author_guest_id"] != null ? AuthorId.fromJson(json["author_guest_id"]) 
        : 
        AuthorId(id: 0, name: ''),
        authorId: json["author_id"] != null ? AuthorId.fromJson(json["author_id"])
        : 
        AuthorId(id: 0, name: ''),
        body: json["body"] ?? '',
        date: json["date"] != null ? DateTime.parse(json["date"]) : DateTime.now(),
        dateDeadLine: json["activity_due_date"] != null ? DateTime.parse(json["activity_due_date"]) : DateTime.now(),
        description: json["description"] ?? '',
        emailAddSignature: json["email_add_signature"] ?? '',
        emailFrom: json["email_from"] ?? '',
        emailLayoutXmlid: json["email_layout_xmlid"] ?? '',
        hasError: json["has_error"] ?? '',
        hasSmsError: json["has_sms_error"] ?? '',
        isCurrentUserOrGuestAuthor: json["is_current_user_or_guest_author"] ?? '',
        isDoneApp: json["is_done_app"] ?? '',
        isInternal: json["is_internal"] ?? '',
        letterIds: json["letter_ids"] != null ? List<dynamic>.from(json["letter_ids"].map((x) => x)) : [],
        linkPreviewIds: json["link_preview_ids"] != null ? List<dynamic>.from(json["link_preview_ids"].map((x) => x)) : [],
        mailActivityTypeId: json["mail_activity_type_id"] != null ? AuthorId.fromJson(json["mail_activity_type_id"])
        : AuthorId(id: 0, name: ''),
        mailIds: json["mail_ids"] != null ? List<dynamic>.from(json["mail_ids"].map((x) => x)) : [],
        mailServerId: json["mail_server_id"] != null ? AuthorId.fromJson(json["mail_server_id"]) 
        : AuthorId(id: 0, name: ''),
        messageId: json["message_id"] ?? '',
        messageType: json["message_type"] ?? '',
        model: json["model"] ?? '',
        needaction: json["needaction"] ?? '',
        notificationIds: json["notification_ids"] != null ? List<dynamic>.from(json["notification_ids"].map((x) => x)) : [],
        notifiedPartnerIds: json["notified_partner_ids"] != null ? List<dynamic>.from(json["notified_partner_ids"].map((x) => x)) : [],
        parentId: json["parent_id"] != null ? AuthorId.fromJson(json["parent_id"])
        : AuthorId(id: 0, name: ''),
        partnerIds: json["partner_ids"] != null ? List<AuthorId>.from(json["partner_ids"].map((x) => AuthorId.fromJson(x))) : [],
        preview: json["preview"] ?? '',
        ratingIds: json["rating_ids"] != null ? List<dynamic>.from(json["rating_ids"].map((x) => x)) : [],
        ratingValue: json["rating_value"] ?? '',
        reactionIds: json["reaction_ids"] != null ? List<dynamic>.from(json["reaction_ids"].map((x) => x)) : [],
        recordAliasDomainId: json["record_alias_domain_id"] != null ? AuthorId.fromJson(json["record_alias_domain_id"])
        : AuthorId(id: 0, name: ''),
        recordCompanyId: json["record_company_id"] != null ? AuthorId.fromJson(json["record_company_id"])
        : AuthorId(id: 0, name: ''),
        recordName: json["record_name"] ?? '',
        replyTo: json["reply_to"] ?? '',
        replyToForceNew: json["reply_to_force_new"] ?? '',
        resId: json["res_id"] ?? '',
        snailmailError: json["snailmail_error"] ?? '',
        starred: json["starred"] ?? '',
        starredPartnerIds: json["starred_partner_ids"] != null ? List<dynamic>.from(json["starred_partner_ids"].map((x) => x)) : [],
        subject: json["subject"] ?? '',
        subtypeId: json["subtype_id"] != null ? AuthorId.fromJson(json["subtype_id"])
        : AuthorId(id: 0, name: ''),
        trackingValueIds: json["tracking_value_ids"] != null ? List<dynamic>.from(json["tracking_value_ids"].map((x) => x)) : [],
        waMessageIds: json["wa_message_ids"] != null ? List<dynamic>.from(json["wa_message_ids"].map((x) => x)) : [],
        workingTime: json["working_time"] ?? '',
        writeDate: json["write_date"] != null ? DateTime.parse(json["write_date"]) : DateTime.now(),
        writeUid: json["write_uid"] != null ? AuthorId.fromJson(json["write_uid"])
        : AuthorId(id: 0, name: ''),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "attachment_ids": List<dynamic>.from(attachmentIds.map((x) => x)),
        "author_avatar": authorAvatar,
        "author_guest_id": authorGuestId.toJson(),
        "author_id": authorId.toJson(),
        "body": body,
        "date": date.toIso8601String(),
        "activity_due_date": dateDeadLine.toIso8601String(),
        "description": description,
        "email_add_signature": emailAddSignature,
        "email_from": emailFrom,
        "email_layout_xmlid": emailLayoutXmlid,
        "has_error": hasError,
        "has_sms_error": hasSmsError,
        "is_current_user_or_guest_author": isCurrentUserOrGuestAuthor,
        "is_done_app": isDoneApp,
        "is_internal": isInternal,
        "letter_ids": List<dynamic>.from(letterIds.map((x) => x)),
        "link_preview_ids": List<dynamic>.from(linkPreviewIds.map((x) => x)),
        "mail_activity_type_id": mailActivityTypeId.toJson(),
        "mail_ids": List<dynamic>.from(mailIds.map((x) => x)),
        "mail_server_id": mailServerId.toJson(),
        "message_id": messageId,
        "message_type": messageType,
        "model": model,
        "needaction": needaction,
        "notification_ids": List<dynamic>.from(notificationIds.map((x) => x)),
        "notified_partner_ids": List<dynamic>.from(notifiedPartnerIds.map((x) => x)),
        "parent_id": parentId.toJson(),
        "partner_ids": List<dynamic>.from(partnerIds.map((x) => x.toJson())),
        "preview": preview,
        "rating_ids": List<dynamic>.from(ratingIds.map((x) => x)),
        "rating_value": ratingValue,
        "reaction_ids": List<dynamic>.from(reactionIds.map((x) => x)),
        "record_alias_domain_id": recordAliasDomainId.toJson(),
        "record_company_id": recordCompanyId.toJson(),
        "record_name": recordName,
        "reply_to": replyTo,
        "reply_to_force_new": replyToForceNew,
        "res_id": resId,
        "snailmail_error": snailmailError,
        "starred": starred,
        "starred_partner_ids": List<dynamic>.from(starredPartnerIds.map((x) => x)),
        "subject": subject,
        "subtype_id": subtypeId.toJson(),
        "tracking_value_ids": List<dynamic>.from(trackingValueIds.map((x) => x)),
        "wa_message_ids": List<dynamic>.from(waMessageIds.map((x) => x)),
        "working_time": workingTime,
        "write_date": writeDate.toIso8601String(),
        "write_uid": writeUid.toJson(),
    };
}

class AuthorId {
    int id;
    String name;

    AuthorId({
        required this.id,
        required this.name,
    });

    factory AuthorId.fromRawJson(String str) => AuthorId.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AuthorId.fromJson(Map<String, dynamic> json) => AuthorId(
        id: json["id"] ?? 0,
        name: json["name"] != null ? json["name"] .toString() : ''
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}

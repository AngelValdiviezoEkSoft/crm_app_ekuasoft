import 'dart:convert';

class UsuarioResponseModel {
    String jsonrpc;
    dynamic id;
    ResultUsuarioResponse resultUsuarioResponse;

    UsuarioResponseModel({
        required this.jsonrpc,
        required this.id,
        required this.resultUsuarioResponse,
    });

    factory UsuarioResponseModel.fromJson(String str) => UsuarioResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UsuarioResponseModel.fromMap(Map<String, dynamic> json) => UsuarioResponseModel(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        resultUsuarioResponse: ResultUsuarioResponse.fromJson(json["ResultUsuarioResponse"]),
    );

    Map<String, dynamic> toMap() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "ResultUsuarioResponse": resultUsuarioResponse.toJson(),
    };
}

class ResultUsuarioResponse {
    int uid;
    bool isSystem;
    bool isAdmin;
    bool isPublic;
    bool isInternalUser;
    UserContext userContext;
    String db;
    UserSettings userSettings;
    String serverVersion;
    List<dynamic> serverVersionInfo;
    String supportUrl;
    String name;
    String username;
    String partnerDisplayName;
    int partnerId;
    String webBaseUrl;
    int activeIdsLimit;
    dynamic profileSession;
    dynamic profileCollectors;
    dynamic profileParams;
    int maxFileUploadSize;
    bool homeActionId;
    CacheHashes cacheHashes;
    //Currencies currencies;
    BundleParams bundleParams;
    List<int> userId;
    String websocketWorkerVersion;
    bool isQuickEditModeEnabled;
    int currentCompany;
    Map<String, AllowedCompany> allowedCompanies;
    DonePermissions donePermissions;
    String doneSupportUrl;
    String doneTermsOfUseUrl;

    ResultUsuarioResponse({
        required this.uid,
        required this.isSystem,
        required this.isAdmin,
        required this.isPublic,
        required this.isInternalUser,
        required this.userContext,
        required this.db,
        required this.userSettings,
        required this.serverVersion,
        required this.serverVersionInfo,
        required this.supportUrl,
        required this.name,
        required this.username,
        required this.partnerDisplayName,
        required this.partnerId,
        required this.webBaseUrl,
        required this.activeIdsLimit,
        required this.profileSession,
        required this.profileCollectors,
        required this.profileParams,
        required this.maxFileUploadSize,
        required this.homeActionId,
        required this.cacheHashes,
        //required this.currencies,
        required this.bundleParams,
        required this.userId,
        required this.websocketWorkerVersion,
        required this.isQuickEditModeEnabled,
        required this.currentCompany,
        required this.allowedCompanies,
        required this.donePermissions,
        required this.doneSupportUrl,
        required this.doneTermsOfUseUrl,
    });

    factory ResultUsuarioResponse.fromJson(String str) => ResultUsuarioResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ResultUsuarioResponse.fromMap(Map<String, dynamic> json) => ResultUsuarioResponse(
        uid: json["uid"],
        isSystem: json["is_system"],
        isAdmin: json["is_admin"],
        isPublic: json["is_public"],
        isInternalUser: json["is_internal_user"],
        userContext: UserContext.fromJson(json["user_context"]),
        db: json["db"],
        userSettings: UserSettings.fromJson(json["user_settings"]),
        serverVersion: json["server_version"],
        serverVersionInfo: List<dynamic>.from(json["server_version_info"].map((x) => x)),
        supportUrl: json["support_url"],
        name: json["name"],
        username: json["username"],
        partnerDisplayName: json["partner_display_name"],
        partnerId: json["partner_id"],
        webBaseUrl: json["web.base.url"],
        activeIdsLimit: json["active_ids_limit"],
        profileSession: json["profile_session"],
        profileCollectors: json["profile_collectors"],
        profileParams: json["profile_params"],
        maxFileUploadSize: json["max_file_upload_size"],
        homeActionId: json["home_action_id"],
        cacheHashes: CacheHashes.fromJson(json["cache_hashes"]),
        //currencies: Currencies.fromJson(json["currencies"]),
        bundleParams: BundleParams.fromJson(json["bundle_params"]),
        userId: List<int>.from(json["user_id"].map((x) => x)),
        websocketWorkerVersion: json["websocket_worker_version"],
        isQuickEditModeEnabled: json["is_quick_edit_mode_enabled"],
        currentCompany: json["current_company"],
        allowedCompanies: Map.from(json["allowed_companies"]).map((k, v) => MapEntry<String, AllowedCompany>(k, AllowedCompany.fromJson(v))),
        donePermissions: DonePermissions.fromJson(json["done_permissions"]),
        doneSupportUrl: json["done_support_url"],
        doneTermsOfUseUrl: json["done_terms_of_use_url"],
    );

    Map<String, dynamic> toMap() => {
        "uid": uid,
        "is_system": isSystem,
        "is_admin": isAdmin,
        "is_public": isPublic,
        "is_internal_user": isInternalUser,
        "user_context": userContext.toJson(),
        "db": db,
        "user_settings": userSettings.toJson(),
        "server_version": serverVersion,
        "server_version_info": List<dynamic>.from(serverVersionInfo.map((x) => x)),
        "support_url": supportUrl,
        "name": name,
        "username": username,
        "partner_display_name": partnerDisplayName,
        "partner_id": partnerId,
        "web.base.url": webBaseUrl,
        "active_ids_limit": activeIdsLimit,
        "profile_session": profileSession,
        "profile_collectors": profileCollectors,
        "profile_params": profileParams,
        "max_file_upload_size": maxFileUploadSize,
        "home_action_id": homeActionId,
        "cache_hashes": cacheHashes.toJson(),
        //"currencies": currencies.toJson(),
        "bundle_params": bundleParams.toJson(),
        "user_id": List<dynamic>.from(userId.map((x) => x)),
        "websocket_worker_version": websocketWorkerVersion,
        "is_quick_edit_mode_enabled": isQuickEditModeEnabled,
        "current_company": currentCompany,
        "allowed_companies": Map.from(allowedCompanies).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "done_permissions": donePermissions.toJson(),
        "done_support_url": doneSupportUrl,
        "done_terms_of_use_url": doneTermsOfUseUrl,
    };
}

class AllowedCompany {
    int id;
    String name;
    int sequence;
    bool parentId;

    AllowedCompany({
        required this.id,
        required this.name,
        required this.sequence,
        required this.parentId,
    });

    factory AllowedCompany.fromJson(String str) => AllowedCompany.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AllowedCompany.fromMap(Map<String, dynamic> json) => AllowedCompany(
        id: json["id"],
        name: json["name"],
        sequence: json["sequence"],
        parentId: json["parent_id"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "sequence": sequence,
        "parent_id": parentId,
    };
}

class BundleParams {
    String lang;

    BundleParams({
        required this.lang,
    });

    factory BundleParams.fromJson(String str) => BundleParams.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory BundleParams.fromMap(Map<String, dynamic> json) => BundleParams(
        lang: json["lang"],
    );

    Map<String, dynamic> toMap() => {
        "lang": lang,
    };
}

class CacheHashes {
    String translations;

    CacheHashes({
        required this.translations,
    });

    factory CacheHashes.fromJson(String str) => CacheHashes.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CacheHashes.fromMap(Map<String, dynamic> json) => CacheHashes(
        translations: json["translations"],
    );

    Map<String, dynamic> toMap() => {
        "translations": translations,
    };
}

/*
class Currencies {
    The1 the1;

    Currencies({
        required this.the1,
    });

    

    factory Currencies.fromJson(String str) => Currencies.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Currencies.fromMap(Map<String, dynamic> json) => Currencies(
        the1: The1.fromJson(json["1"]),
    );

    Map<String, dynamic> toMap() => {
        "1": the1.toJson(),
    };
}

class The1 {
    String symbol;
    String position;
    List<int> digits;

    The1({
        required this.symbol,
        required this.position,
        required this.digits,
    });

    factory The1.fromRawJson(String str) => The1.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory The1.fromJson(Map<String, dynamic> json) => The1(
        symbol: json["symbol"],
        position: json["position"],
        digits: List<int>.from(json["digits"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "position": position,
        "digits": List<dynamic>.from(digits.map((x) => x)),
    };
}
*/

class DonePermissions {
    MainMenu mainMenu;
    Buttons buttons;

    DonePermissions({
        required this.mainMenu,
        required this.buttons,
    });

    factory DonePermissions.fromRawJson(String str) => DonePermissions.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DonePermissions.fromJson(Map<String, dynamic> json) => DonePermissions(
        mainMenu: MainMenu.fromJson(json["main_menu"]),
        buttons: Buttons.fromJson(json["buttons"]),
    );

    Map<String, dynamic> toJson() => {
        "main_menu": mainMenu.toJson(),
        "buttons": buttons.toJson(),
    };
}

class Buttons {
    bool btnProgressOfTheDay;
    bool btnCreateLead;

    Buttons({
        required this.btnProgressOfTheDay,
        required this.btnCreateLead,
    });

    factory Buttons.fromRawJson(String str) => Buttons.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Buttons.fromJson(Map<String, dynamic> json) => Buttons(
        btnProgressOfTheDay: json["btn_progress_of_the_day"],
        btnCreateLead: json["btn_create_lead"],
    );

    Map<String, dynamic> toJson() => {
        "btn_progress_of_the_day": btnProgressOfTheDay,
        "btn_create_lead": btnCreateLead,
    };
}

class MainMenu {
    bool cardSales;
    bool cardCollection;
    bool itemListPartners;
    bool itemScheduledVisits;
    bool itemListLeads;
    bool itemListCatalog;
    bool itemListInventory;
    bool itemListPriceList;
    bool itemListPromotions;
    bool itemListDistribution;

    MainMenu({
        required this.cardSales,
        required this.cardCollection,
        required this.itemListPartners,
        required this.itemScheduledVisits,
        required this.itemListLeads,
        required this.itemListCatalog,
        required this.itemListInventory,
        required this.itemListPriceList,
        required this.itemListPromotions,
        required this.itemListDistribution,
    });

    factory MainMenu.fromRawJson(String str) => MainMenu.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MainMenu.fromJson(Map<String, dynamic> json) => MainMenu(
        cardSales: json["card_sales"],
        cardCollection: json["card_collection"],
        itemListPartners: json["item_list_partners"],
        itemScheduledVisits: json["item_scheduled_visits"],
        itemListLeads: json["item_list_leads"],
        itemListCatalog: json["item_list_catalog"],
        itemListInventory: json["item_list_inventory"],
        itemListPriceList: json["item_list_price_list"],
        itemListPromotions: json["item_list_promotions"],
        itemListDistribution: json["item_list_distribution"],
    );

    Map<String, dynamic> toJson() => {
        "card_sales": cardSales,
        "card_collection": cardCollection,
        "item_list_partners": itemListPartners,
        "item_scheduled_visits": itemScheduledVisits,
        "item_list_leads": itemListLeads,
        "item_list_catalog": itemListCatalog,
        "item_list_inventory": itemListInventory,
        "item_list_price_list": itemListPriceList,
        "item_list_promotions": itemListPromotions,
        "item_list_distribution": itemListDistribution,
    };
}

class UserContext {
    String lang;
    String tz;
    int uid;

    UserContext({
        required this.lang,
        required this.tz,
        required this.uid,
    });

    factory UserContext.fromRawJson(String str) => UserContext.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UserContext.fromJson(Map<String, dynamic> json) => UserContext(
        lang: json["lang"],
        tz: json["tz"],
        uid: json["uid"],
    );

    Map<String, dynamic> toJson() => {
        "lang": lang,
        "tz": tz,
        "uid": uid,
    };
}

class UserSettings {
    int id;
    UserId userId;
    bool isDiscussSidebarCategoryChannelOpen;
    bool isDiscussSidebarCategoryChatOpen;
    bool pushToTalkKey;
    bool usePushToTalk;
    int voiceActiveDuration;
    List<List<dynamic>> volumeSettingsIds;
    bool homemenuConfig;
    bool isDiscussSidebarCategoryWhatsappOpen;
    bool livechatUsername;
    List<dynamic> livechatLangIds;
    bool isDiscussSidebarCategoryLivechatOpen;

    UserSettings({
        required this.id,
        required this.userId,
        required this.isDiscussSidebarCategoryChannelOpen,
        required this.isDiscussSidebarCategoryChatOpen,
        required this.pushToTalkKey,
        required this.usePushToTalk,
        required this.voiceActiveDuration,
        required this.volumeSettingsIds,
        required this.homemenuConfig,
        required this.isDiscussSidebarCategoryWhatsappOpen,
        required this.livechatUsername,
        required this.livechatLangIds,
        required this.isDiscussSidebarCategoryLivechatOpen,
    });

    factory UserSettings.fromRawJson(String str) => UserSettings.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
        id: json["id"],
        userId: UserId.fromJson(json["user_id"]),
        isDiscussSidebarCategoryChannelOpen: json["is_discuss_sidebar_category_channel_open"],
        isDiscussSidebarCategoryChatOpen: json["is_discuss_sidebar_category_chat_open"],
        pushToTalkKey: json["push_to_talk_key"],
        usePushToTalk: json["use_push_to_talk"],
        voiceActiveDuration: json["voice_active_duration"],
        volumeSettingsIds: List<List<dynamic>>.from(json["volume_settings_ids"].map((x) => List<dynamic>.from(x.map((x) => x)))),
        homemenuConfig: json["homemenu_config"],
        isDiscussSidebarCategoryWhatsappOpen: json["is_discuss_sidebar_category_whatsapp_open"],
        livechatUsername: json["livechat_username"],
        livechatLangIds: List<dynamic>.from(json["livechat_lang_ids"].map((x) => x)),
        isDiscussSidebarCategoryLivechatOpen: json["is_discuss_sidebar_category_livechat_open"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId.toJson(),
        "is_discuss_sidebar_category_channel_open": isDiscussSidebarCategoryChannelOpen,
        "is_discuss_sidebar_category_chat_open": isDiscussSidebarCategoryChatOpen,
        "push_to_talk_key": pushToTalkKey,
        "use_push_to_talk": usePushToTalk,
        "voice_active_duration": voiceActiveDuration,
        "volume_settings_ids": List<dynamic>.from(volumeSettingsIds.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "homemenu_config": homemenuConfig,
        "is_discuss_sidebar_category_whatsapp_open": isDiscussSidebarCategoryWhatsappOpen,
        "livechat_username": livechatUsername,
        "livechat_lang_ids": List<dynamic>.from(livechatLangIds.map((x) => x)),
        "is_discuss_sidebar_category_livechat_open": isDiscussSidebarCategoryLivechatOpen,
    };
}

class UserId {
    int id;

    UserId({
        required this.id,
    });

    factory UserId.fromRawJson(String str) => UserId.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
    };
}

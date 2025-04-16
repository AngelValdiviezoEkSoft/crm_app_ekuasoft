import 'dart:convert';

class ErrorLoginResponseModel {
    String jsonrpc;
    dynamic id;
    ErrorLoginModel error;

    ErrorLoginResponseModel({
        required this.jsonrpc,
        required this.id,
        required this.error,
    });

    factory ErrorLoginResponseModel.fromRawJson(String str) => ErrorLoginResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ErrorLoginResponseModel.fromJson(Map<String, dynamic> json) => ErrorLoginResponseModel(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        error: ErrorLoginModel.fromJson(json["error"]),
    );

    Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "error": error.toJson(),
    };
}

class ErrorLoginModel {
    int code;
    String message;
    DetErrorLoginModel data;

    ErrorLoginModel({
        required this.code,
        required this.message,
        required this.data,
    });

    factory ErrorLoginModel.fromRawJson(String str) => ErrorLoginModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ErrorLoginModel.fromJson(Map<String, dynamic> json) => ErrorLoginModel(
        code: json["code"],
        message: json["message"],
        data: DetErrorLoginModel.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
    };
}

class DetErrorLoginModel {
    String name;
    String debug;
    String message;
    String exceptionType;

    DetErrorLoginModel({
        required this.name,
        required this.debug,
        required this.message,
        required this.exceptionType,
    });

    factory DetErrorLoginModel.fromRawJson(String str) => DetErrorLoginModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DetErrorLoginModel.fromJson(Map<String, dynamic> json) => DetErrorLoginModel(
        name: json["name"],
        debug: json["debug"],
        message: json["message"],
        exceptionType: json["exception_type"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "debug": debug,
        "message": message,
        "exception_type": exceptionType,
    };
}

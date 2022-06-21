class ResponseErrorModel {
  final String id;
  final String message;

  ResponseErrorModel({required this.id, required this.message});

  factory ResponseErrorModel.fromJson(dynamic json) {
    return ResponseErrorModel(
        id: json['\$id'] as String, message: json['message'] as String);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['\$id'] = id;
    data['message'] = message;
    return data;
  }
}

class ResponseModel {
  final String successMessage;
  final String errorCode;
  final String errorMessage;

  ResponseModel(
      {required this.successMessage,
      required this.errorCode,
      required this.errorMessage});

  factory ResponseModel.fromJson(dynamic json) {
    return ResponseModel(
      successMessage: json['Y77T3XP2B'] as String,
      errorCode: json['E6DYES1Q2'] as String,
      errorMessage: json['SXVI7XCEU'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Y77T3XP2B'] = successMessage;
    data['E6DYES1Q2'] = errorCode;
    data['SXVI7XCEU'] = errorMessage;
    return data;
  }
}

class RequestErrorResponse {
  String message;
  int errorcode;

  RequestErrorResponse({required this.message, required this.errorcode});

  factory RequestErrorResponse.fromJson(dynamic json) {
    return RequestErrorResponse(
      message: json['message'] as String,
      errorcode: json['errorcode'] as int,
    );
  }
}

class RequestSuccessResponse {
  int response;
  int successcode;
  String message;

  RequestSuccessResponse({
    required this.response,
    required this.successcode,
    required this.message,
  });

  factory RequestSuccessResponse.fromJson(dynamic json) {
    return RequestSuccessResponse(
      message: json['message'] as String,
      response: json['response'] as int,
      successcode: json['successcode'] as int,
    );
  }
}

class EmployeeForgotChangePasswordResponse {
  String resultCode;
  String resultMsg;
  String resultNumber;

  EmployeeForgotChangePasswordResponse(
      {required this.resultCode,
      required this.resultMsg,
      required this.resultNumber});

  factory EmployeeForgotChangePasswordResponse.fromJson(dynamic json) {
    return EmployeeForgotChangePasswordResponse(
        resultCode: json['sResultCode'] as String,
        resultMsg: json['sResultMsg'] as String,
        resultNumber: json['sResultNumber'] as String);
  }
}

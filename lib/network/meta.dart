class Meta {
  int statusCode;
  String statusMsg;

  Meta({required this.statusCode, required this.statusMsg});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
        statusCode: json['statusCode'] as int,
        statusMsg: json['statusMsg'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['statusMsg'] = statusMsg;
    return data;
  }
}

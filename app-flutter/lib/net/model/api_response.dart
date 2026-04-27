import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ApiResponse {
  @JsonKey(name: 'status')
  String status;

  @JsonKey(name: 'statusInfo')
  String? statusInfo;

  dynamic data;

  ApiResponse(this.status, this.data, this.statusInfo);

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);

  bool get isSuccess => status == "0";
}

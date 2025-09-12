import 'package:equatable/equatable.dart';

class AjGenerationResponseModel extends Equatable {
  final String message;
  final String data;

  const AjGenerationResponseModel({
    required this.message,
    required this.data,
  });

  factory AjGenerationResponseModel.fromJson(Map<String, dynamic> json) {
    return AjGenerationResponseModel(
      message: json['message'] ?? '',
      data: json['data'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data,
    };
  }

  @override
  List<Object?> get props => [message, data];
}

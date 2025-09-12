import 'package:equatable/equatable.dart';

class StockOpnameResponseModel extends Equatable {
  final String message;

  const StockOpnameResponseModel({
    required this.message,
  });

  factory StockOpnameResponseModel.fromJson(Map<String, dynamic> json) {
    return StockOpnameResponseModel(
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }

  @override
  List<Object?> get props => [message];
}

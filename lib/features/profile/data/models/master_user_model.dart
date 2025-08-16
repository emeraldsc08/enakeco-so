class MasterUserModel {
  final int id;
  final String username;

  MasterUserModel({
    required this.id,
    required this.username,
  });

  factory MasterUserModel.fromJson(Map<String, dynamic> json) {
    return MasterUserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
    };
  }
}

class MasterUserResponse {
  final String message;
  final List<MasterUserModel> data;

  MasterUserResponse({
    required this.message,
    required this.data,
  });

  factory MasterUserResponse.fromJson(Map<String, dynamic> json) {
    return MasterUserResponse(
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => MasterUserModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class UserSettingsModel {
  final int id;
  final String username;
  final int isAdmin;

  UserSettingsModel({
    required this.id,
    required this.username,
    required this.isAdmin,
  });

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) {
    return UserSettingsModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      isAdmin: json['isAdmin'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'isAdmin': isAdmin,
    };
  }
}

class UserSettingsResponse {
  final String message;
  final int currentPage;
  final int lastPage;
  final int totalData;
  final List<UserSettingsModel> data;

  UserSettingsResponse({
    required this.message,
    required this.currentPage,
    required this.lastPage,
    required this.totalData,
    required this.data,
  });

  factory UserSettingsResponse.fromJson(Map<String, dynamic> json) {
    return UserSettingsResponse(
      message: json['message'] ?? '',
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      totalData: json['total_data'] ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => UserSettingsModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}

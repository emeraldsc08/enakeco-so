class UpdateUserDataModel {
  final int id;
  final String cNamaus;
  final String cGroup;
  final int nLevel;
  final String cNoUser;
  final String cGudang;
  final String lStockMin;
  final String lReorder;
  final String lPR;
  final String lPO;
  final String lHutJtTempo;
  final int canLogin;
  final int isAdmin;
  final String? deletedAt;

  UpdateUserDataModel({
    required this.id,
    required this.cNamaus,
    required this.cGroup,
    required this.nLevel,
    required this.cNoUser,
    required this.cGudang,
    required this.lStockMin,
    required this.lReorder,
    required this.lPR,
    required this.lPO,
    required this.lHutJtTempo,
    required this.canLogin,
    required this.isAdmin,
    this.deletedAt,
  });

  factory UpdateUserDataModel.fromJson(Map<String, dynamic> json) {
    return UpdateUserDataModel(
      id: json['id'] ?? 0,
      cNamaus: json['cNamaus'] ?? '',
      cGroup: json['cGroup'] ?? '',
      nLevel: json['nLevel'] ?? 0,
      cNoUser: json['cNoUser'] ?? '',
      cGudang: json['cGudang'] ?? '',
      lStockMin: json['lStockMin'] ?? '',
      lReorder: json['lReorder'] ?? '',
      lPR: json['lPR'] ?? '',
      lPO: json['lPO'] ?? '',
      lHutJtTempo: json['lHutJtTempo'] ?? '',
      canLogin: json['canLogin'] ?? 0,
      isAdmin: json['isAdmin'] ?? 0,
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cNamaus': cNamaus,
      'cGroup': cGroup,
      'nLevel': nLevel,
      'cNoUser': cNoUser,
      'cGudang': cGudang,
      'lStockMin': lStockMin,
      'lReorder': lReorder,
      'lPR': lPR,
      'lPO': lPO,
      'lHutJtTempo': lHutJtTempo,
      'canLogin': canLogin,
      'isAdmin': isAdmin,
      'deleted_at': deletedAt,
    };
  }
}

class UpdateUserResponse {
  final String message;
  final UpdateUserDataModel data;

  UpdateUserResponse({
    required this.message,
    required this.data,
  });

  factory UpdateUserResponse.fromJson(Map<String, dynamic> json) {
    return UpdateUserResponse(
      message: json['message'] ?? '',
      data: UpdateUserDataModel.fromJson(json['data'] ?? {}),
    );
  }
}

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.cNamaus,
    required super.cGroup,
    required super.nLevel,
    required super.cNoUser,
    required super.cGudang,
    required super.lStockMin,
    required super.lReorder,
    required super.lPR,
    required super.lPO,
    required super.lHutJtTempo,
    required super.canLogin,
    required super.isAdmin,
    super.deletedAt,
    required super.encryptedId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse int
    int safeParseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) {
        return int.tryParse(value) ?? 0;
      }
      return 0;
    }

    // Helper function to safely parse string
    String safeParseString(dynamic value) {
      if (value == null) return '';
      return value.toString();
    }

    return UserModel(
      id: safeParseInt(json['id']),
      cNamaus: safeParseString(json['cNamaus']),
      cGroup: safeParseString(json['cGroup']),
      nLevel: safeParseInt(json['nLevel']),
      cNoUser: safeParseString(json['cNoUser']),
      cGudang: safeParseString(json['cGudang']),
      lStockMin: safeParseString(json['lStockMin']),
      lReorder: safeParseString(json['lReorder']),
      lPR: safeParseString(json['lPR']),
      lPO: safeParseString(json['lPO']),
      lHutJtTempo: safeParseString(json['lHutJtTempo']),
      canLogin: safeParseInt(json['canLogin']),
      isAdmin: safeParseInt(json['isAdmin']),
      deletedAt: json['deleted_at']?.toString(),
      encryptedId: safeParseString(json['encrypted_id']),
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
      'encrypted_id': encryptedId,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      cNamaus: entity.cNamaus,
      cGroup: entity.cGroup,
      nLevel: entity.nLevel,
      cNoUser: entity.cNoUser,
      cGudang: entity.cGudang,
      lStockMin: entity.lStockMin,
      lReorder: entity.lReorder,
      lPR: entity.lPR,
      lPO: entity.lPO,
      lHutJtTempo: entity.lHutJtTempo,
      canLogin: entity.canLogin,
      isAdmin: entity.isAdmin,
      deletedAt: entity.deletedAt,
      encryptedId: entity.encryptedId,
    );
  }
}
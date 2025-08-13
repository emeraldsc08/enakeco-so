import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
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
  final String encryptedId;

  const UserEntity({
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
    required this.encryptedId,
  });

  @override
  List<Object?> get props => [
        id,
        cNamaus,
        cGroup,
        nLevel,
        cNoUser,
        cGudang,
        lStockMin,
        lReorder,
        lPR,
        lPO,
        lHutJtTempo,
        canLogin,
        isAdmin,
        deletedAt,
        encryptedId,
      ];
}
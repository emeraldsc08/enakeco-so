class BranchModel {
  final int branchId;
  final String branchName;

  const BranchModel({
    required this.branchId,
    required this.branchName,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      branchId: json['branch_id'] ?? 0,
      branchName: json['branch_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch_id': branchId,
      'branch_name': branchName,
    };
  }

  @override
  String toString() {
    return 'BranchModel(branchId: $branchId, branchName: $branchName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BranchModel &&
        other.branchId == branchId &&
        other.branchName == branchName;
  }

  @override
  int get hashCode => branchId.hashCode ^ branchName.hashCode;
}

import 'package:flutter/material.dart';

import '../models/branch_model.dart';

class GlobalBranchProvider extends ChangeNotifier {
  BranchModel? _selectedBranch;

  // Dummy data branches
  final List<BranchModel> branches = [
    BranchModel(branchId: 1, branchName: 'Karang Ploso'),
    BranchModel(branchId: 2, branchName: 'Pakisaji'),
  ];

  GlobalBranchProvider() {
    // Set default branch to Karang Ploso
    _selectedBranch = branches.first;
  }

  BranchModel? get selectedBranch => _selectedBranch;
  List<BranchModel> get availableBranches => branches;

  void setSelectedBranch(BranchModel branch) {
    _selectedBranch = branch;
    notifyListeners();
  }

  void setSelectedBranchById(int branchId) {
    final branch = branches.firstWhere(
      (branch) => branch.branchId == branchId,
      orElse: () => branches.first,
    );
    setSelectedBranch(branch);
  }

  int get currentBranchId => _selectedBranch?.branchId ?? 1;
  String get currentBranchName => _selectedBranch?.branchName ?? 'Karang Ploso';
}
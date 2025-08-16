import 'package:flutter/material.dart';

import '../../data/models/add_user_model.dart';
import '../../data/models/master_user_model.dart';
import '../../data/models/update_user_model.dart';
import '../../data/models/user_settings_model.dart';
import '../../data/repositories/user_settings_repository.dart';

class UserSettingsProvider extends ChangeNotifier {
  final UserSettingsRepository repository;

  UserSettingsProvider({required this.repository});

  List<UserSettingsModel> _users = [];
  List<UserSettingsModel> _filteredUsers = [];
  List<MasterUserModel> _masterUsers = [];
  List<MasterUserModel> _filteredMasterUsers = [];
  bool _isLoading = false;
  bool _isLoadingMasterUsers = false;
  bool _isAddingUser = false;
  bool _isUpdatingUser = false;
  String _error = '';
  String _searchQuery = '';
  String _masterSearchQuery = '';

  List<UserSettingsModel> get users => _users;
  List<UserSettingsModel> get filteredUsers => _filteredUsers;
  List<MasterUserModel> get masterUsers => _masterUsers;
  List<MasterUserModel> get filteredMasterUsers => _filteredMasterUsers;
  bool get isLoading => _isLoading;
  bool get isLoadingMasterUsers => _isLoadingMasterUsers;
  bool get isAddingUser => _isAddingUser;
  bool get isUpdatingUser => _isUpdatingUser;
  String get error => _error;
  String get searchQuery => _searchQuery;
  String get masterSearchQuery => _masterSearchQuery;

  Future<void> fetchUsers() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await repository.fetchUsers();
      _users = response.data;
      _filteredUsers = _users;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMasterUsers({String? search}) async {
    _isLoadingMasterUsers = true;
    _error = '';
    notifyListeners();

    try {
      final response = await repository.fetchMasterUsers(search: search);
      _masterUsers = response.data;
      _filteredMasterUsers = _masterUsers;
      _isLoadingMasterUsers = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoadingMasterUsers = false;
      notifyListeners();
    }
  }

  Future<AddUserResponse?> addUser({
    required int id,
    required String password,
    required int isAdmin,
  }) async {
    _isAddingUser = true;
    _error = '';
    notifyListeners();

    try {
      final response = await repository.addUser(
        id: id,
        password: password,
        isAdmin: isAdmin,
      );
      _isAddingUser = false;
      notifyListeners();
      return response;
    } catch (e) {
      _error = e.toString();
      _isAddingUser = false;
      notifyListeners();
      return null;
    }
  }

  Future<UpdateUserResponse?> updateUser({
    required String id,
    required String password,
    required int isAdmin,
  }) async {
    _isUpdatingUser = true;
    _error = '';
    notifyListeners();

    try {
      final response = await repository.updateUser(
        id: id,
        password: password,
        isAdmin: isAdmin,
      );
      _isUpdatingUser = false;
      notifyListeners();
      return response;
    } catch (e) {
      _error = e.toString();
      _isUpdatingUser = false;
      notifyListeners();
      return null;
    }
  }

  void searchUsers(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredUsers = _users;
    } else {
      _filteredUsers = _users
          .where((user) =>
              user.username.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void searchMasterUsers(String query) {
    _masterSearchQuery = query;
    if (query.isEmpty) {
      _filteredMasterUsers = _masterUsers;
    } else {
      _filteredMasterUsers = _masterUsers
          .where((user) =>
              user.username.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredUsers = _users;
    notifyListeners();
  }

  void clearMasterSearch() {
    _masterSearchQuery = '';
    _filteredMasterUsers = _masterUsers;
    notifyListeners();
  }
}

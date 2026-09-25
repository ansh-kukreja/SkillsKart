import 'package:flutter/material.dart';
import '../Models/user_role.dart';

/// Central state manager for active user session and role
class UserSession extends ChangeNotifier {
  static final UserSession instance = UserSession._internal();

  UserSession._internal();

  UserRole? _currentRole;
  String _userName = 'Aarav Sharma';
  String _orgName = 'Apex Buildcon & Crafts Corp';
  String _orgGstin = '03AAACA1234E1Z5';
  String _userPhone = '+91 98765 43210';
  final List<EnterpriseRequisition> _requisitions =
      List.from(dummyEnterpriseRequisitions);

  UserRole? get currentRole => _currentRole;
  String get userName => _userName;
  String get orgName => _orgName;
  String get orgGstin => _orgGstin;
  String get userPhone => _userPhone;
  List<EnterpriseRequisition> get requisitions => List.unmodifiable(_requisitions);

  bool get isLoggedIn => _currentRole != null;
  bool get isEnterprise => _currentRole == UserRole.enterprise;
  bool get isNormal => _currentRole == UserRole.normal;

  void login(
    UserRole role, {
    String? name,
    String? orgName,
    String? orgGstin,
    String? phone,
  }) {
    _currentRole = role;
    if (name != null && name.trim().isNotEmpty) {
      _userName = name.trim();
    } else {
      _userName = role == UserRole.enterprise ? 'Vikram Mehrotra' : 'Aarav Sharma';
    }

    if (orgName != null && orgName.trim().isNotEmpty) {
      _orgName = orgName.trim();
    }
    if (orgGstin != null && orgGstin.trim().isNotEmpty) {
      _orgGstin = orgGstin.trim();
    }
    if (phone != null && phone.trim().isNotEmpty) {
      _userPhone = phone.trim();
    }
    notifyListeners();
  }

  void switchRole(UserRole role) {
    _currentRole = role;
    notifyListeners();
  }

  void logout() {
    _currentRole = null;
    notifyListeners();
  }

  void addRequisition(EnterpriseRequisition requisition) {
    _requisitions.insert(0, requisition);
    notifyListeners();
  }
}

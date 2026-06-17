import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthViewModel extends ChangeNotifier {
  final AuthRepository repository;

  AuthStatus status = AuthStatus.initial;
  User? currentUser;
  String errorMessage = '';

  AuthViewModel(this.repository) {
    checkAuth();
  }

  Future<void> checkAuth() async {
    status = AuthStatus.loading;
    notifyListeners();
    try {
      currentUser = await repository.getCurrentUser();
      status = currentUser != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    } catch (e) {
      status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    status = AuthStatus.loading;
    errorMessage = '';
    notifyListeners();
    try {
      currentUser = await repository.login(username, password);
      status = AuthStatus.authenticated;
    } catch (e) {
      status = AuthStatus.error;
      errorMessage = e.toString().replaceAll('Exception: ', '');
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await repository.logout();
    currentUser = null;
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}

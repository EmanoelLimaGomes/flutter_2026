import 'dart:convert';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource datasource;
  static const String _userKey = 'current_user';

  AuthRepositoryImpl(this.datasource);

  @override
  Future<User> login(String username, String password) async {
    final user = await datasource.login(username, password);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, userModelToJson(user));
    return user;
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  @override
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  String userModelToJson(UserModel user) {
    return '''{
      "id": ${user.id},
      "firstName": "${user.firstName}",
      "lastName": "${user.lastName}",
      "email": "${user.email}",
      "token": "${user.token}"
    }''';
  }
}

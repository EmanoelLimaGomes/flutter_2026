import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/pages/product_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/datasources/auth_remote_datasource.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(
            AuthRepositoryImpl(AuthRemoteDataSource()),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Manel Store',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF1D1D1F),
          scaffoldBackgroundColor: const Color(0xFFF5F5F7),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            shape: Border(bottom: BorderSide(color: Color(0xFFE9ECEF), width: 1)),
            titleTextStyle: TextStyle(
              color: Color(0xFF1D1D1F),
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
            iconTheme: IconThemeData(color: Color(0xFF1D1D1F)),
          ),
          cardTheme: const CardThemeData(
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
          ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    switch (authViewModel.status) {
      case AuthStatus.initial:
      case AuthStatus.loading:
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      case AuthStatus.authenticated:
        return ProductPage();
      case AuthStatus.unauthenticated:
      case AuthStatus.error:
        return const LoginPage();
    }
  }
}


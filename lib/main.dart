import 'package:flutter/material.dart';
import 'presentation/pages/product_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Manel Store',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1D1D1F), // Preto/Cinza escuro Apple
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
      home: ProductPage(),
    );
  }
}

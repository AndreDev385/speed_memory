import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent, // Fondo sólido por defecto
        foregroundColor: Colors.white, // Texto blanco por defecto
        textStyle: const TextStyle(
          fontSize: 18, // Fuente grande y visible
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Bordes ligeramente redondeados
        ),
        minimumSize: const Size(double.infinity, 50), // Tamaño estándar para móviles
      ),
    ),
  );
}
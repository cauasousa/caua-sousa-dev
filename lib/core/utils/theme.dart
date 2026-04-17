import 'package:flutter/material.dart';

class AppColors {
  // --- Novas Cores Escolhidas ---
  static const Color background = Color(0xFF020617); // Fundo da página
  static const Color buttonBase = Color(0xFF1D2432); // Botão padrão
  static const Color accentTeal =
      Color(0xFF13988D); // Botão destaque / Destaques

  // --- Neutros e Texto ---
  static const Color surface =
      Color(0xFF0F172A); // Leve variação para cards/navbar
  static const Color textPrimary =
      Color(0xFFF8FAFC); // Branco gelo para leitura
  static const Color textSecondary =
      Color(0xFF94A3B8); // Cinza azulado para legendas
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Cor de fundo geral
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.accentTeal,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentTeal, // Destaque principal
        secondary: AppColors.buttonBase, // Componentes secundários
        surface: AppColors.surface,
        background: AppColors.background,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
      ),

      // Configuração de Tipografia
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'ExoBold',
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),

      // Estilo dos Botões Elevados (Destaque)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentTeal,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'ExoMedium',
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),

      // Estilo dos Outlined Buttons (Botão Padrão)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.buttonBase,
          foregroundColor: AppColors.textPrimary,
          side: BorderSide
              .none, // Remove a borda para seguir o estilo do seu HTML
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: const TextStyle(fontSize: 14),
        ),
      ),

      // Efeito de seleção e hover
      hoverColor: AppColors.accentTeal.withValues(alpha: 0.1),
    );
  }
}

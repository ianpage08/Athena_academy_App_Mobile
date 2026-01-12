import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  // Fundo principal (menos preto, mais elegante)
  static const Color darkBackground = Color(0xFF121026);

  // Cards / Containers (camada clara)
  static const Color darkCard = Color(0xFF23204A);

  // AppBar (ligeiramente destacada)
  static const Color darkAppBar = Color(0xFF181538);

  // Roxo principal (menos neon)
  static const Color darkPrimary = Color(0xFF8B5CF6);

  // Roxo secundário (hover / focus)
  static const Color darkSecondary = Color(0xFFA78BFA);

  // Texto principal (off-white)
  static const Color darkTextPrimary = Color(0xFFEDEAFF);

  // Texto secundário
  static const Color darkTextSecondary = Color(0xFFBDB7E2);

  // Ícones
  static const Color darkIcon = Color(0xFFC7C3F4);

  // Inputs / superfícies elevadas
  static const Color darkInputFill = Color(0xFF26224A);

  // Bordas sutis
  static const Color darkBorder = Color(0xFF2F2B5C);

  // Botão principal
  static const Color darkButtonPrimary = Color(0xFF8B5CF6);

  // Botão ghost
  static const Color darkButtonGhost = Color(0xFF2A2558);

  // Estados
  static const Color darkError = Color(0xFFF87171);
  static const Color darkSuccess = Color(0xFF34D399);
  static const Color darkWarning = Color(0xFFFBBF24);

  // Light Theme Colors
  // =========================
  // LIGHT THEME – Warm Neutral
  // =========================

  /// Fundo principal (off-white quente)
  static const Color lightBackgroundSoft = Color(0xFFF9F8F3);
  // RGB: 249, 248, 243 → papel premium

  /// Cards e superfícies
  static const Color lightCard = Color(0xFFFFFFFF);

  /// AppBar clara e elegante
  static const Color lightAppBar = Color(0xFFF3F1EA);

  /// Cor primária (mantém identidade)
  static const Color lightPrimary = Color(0xFF3A6EA5);

  /// Secundária suave
  static const Color lightSecondary = Color(0xFF5C86C5);

  /// Texto principal
  static const Color lightTextPrimary = Color(0xFF1E1E1E);

  /// Texto secundário
  static const Color lightTextSecondary = Color(0xFF6B6B6B);

  /// Ícones
  static const Color lightIcon = Color(0xFF3A6EA5);

  /// Bordas e divisores
  static const Color lightBorder = Color(0xFFE4E1D8);

  /// Inputs (bem leve e quente)
  static const Color lightInputFill = Color(0xFFF1EFE7);

  /// Botão primário
  static const Color lightButtonPrimary = Color(0xFF3A6EA5);

  /// Botão secundário / ghost
  static const Color lightButtonGhost = Color(0xFFEAE6DA);

  /// Estados
  static const Color lightSuccess = Color(0xFF2E7D32);
  static const Color lightError = Color(0xFFD32F2F);
  static const Color lightHint = Color(0xFF9E9E9E);

  static const Color primary = Color.fromARGB(255, 36, 1, 87); // roxo
  static const Color student = Color(0xFF2196F3); // azul
  static const Color teacher = Color(0xFF4CAF50); // verde
  static const Color parent = Color(0xFFFF9800); // laranja
  static const Color admin = Color(0xFFF44336); // vermelho
  //cada tipo de usuario vai ter uma com de indentificação visual rapida

  static const Color background = Color(0xFFF5F5F5); // cinza claro

  static const Color error = Color(0xFFB00020); // vermelho escuro

  static Color getUserTypeColor(String userType) {
    switch (userType.toLowerCase()) {
      case 'student':
        return student;
      case 'teacher':
        return teacher;
      case 'parent':
        return parent;
      case 'admin':
        return admin;
      default:
        return const Color(0xFF0E0B1F);
    }
  }
}

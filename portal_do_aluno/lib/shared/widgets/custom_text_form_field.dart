import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


///
/// Arquitetura e UX:
/// - Abandona sombras externas que quebram o layout de erro.
/// - Adota o padrão "Flat Design" com superfícies (fills) interativas.
/// - Suporta dinamicamente temas Claro/Escuro nativos do Flutter.
/// - Trata o estado desabilitado (disabled) com affordance correta.
class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final bool obrigatorio;
  final String? Function(String? value)? validator;
  final TextInputType? keyboardType;
  final bool enable;
  final Color? fillColor;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;
  final bool obscureText;

  const CustomTextFormField({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
    this.minLines,
    this.maxLines,
    this.obrigatorio = true,
    this.validator,
    this.keyboardType,
    this.enable = true,
    this.fillColor,
    this.inputFormatters,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // --- Cores Semânticas Dinâmicas ---
    final primaryColor = theme.colorScheme.primary;

    final errorColor = theme.colorScheme.error;

    final borderColor = primaryColor.withValues(alpha: 0.3);
    final focusColor = primaryColor;

    // Tratamento de cor de fundo (fill) baseado no estado de 'enable'
    final activeFill = fillColor ?? theme.cardColor;
    final disabledFill = isDark
        ? theme.cardColor.withValues(alpha: 0.2)
        : theme.disabledColor.withValues(alpha: 0.05);

    // Sombras externas em TextFormFields quebram o visual quando o texto de erro aparece.
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        obscureText: obscureText,
        controller: controller,
        maxLength: maxLength,
        minLines: minLines ?? 1,
        // Garante que senhas não quebrem o layout tentando ter múltiplas linhas
        maxLines: obscureText ? 1 : (maxLines ?? 1),
        enabled: enable,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,

        // Lógica de validação otimizada
        validator:
            validator ??
            (obrigatorio
                ? (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Campo obrigatório';
                    }
                    return null;
                  }
                : null),

        style: TextStyle(
          color: enable
              ? theme.textTheme.bodyLarge?.color
              : theme.hintColor.withValues(alpha: 0.5),
          fontWeight: FontWeight.w500,
        ),

        decoration: InputDecoration(
          counterText:
              "", // Esconde o contador de caracteres nativo (UX mais limpa)
          labelText: label,
          hintText: hintText,

          // Estilização das labels para visual mais clean
          labelStyle: TextStyle(
            color: theme.hintColor,
            fontWeight: FontWeight.w400,
          ),
          floatingLabelStyle: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),

          // ---------- ÍCONES ----------
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: enable
                      ? theme.iconTheme.color
                      : theme.hintColor.withValues(alpha: 0.5),
                  size: 22,
                )
              : null,
          suffixIcon: suffixIcon,

          // ---------- FILL (Fundo) ----------
          filled: true,
          fillColor: enable ? activeFill : disabledFill,
          contentPadding: contentPadding,

          // ---------- BORDAS (Design System) ----------
          // Borda padrão (quando não está focado)
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor, width: 1),
          ),

          // Borda Focada (acende com a cor primária, indicando interação)
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: focusColor, width: 1.5),
          ),

          // Bordas de Erro (usando a cor semântica do tema)
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: errorColor.withValues(alpha: 0.8),
              width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: errorColor, width: 2),
          ),
        ),
      ),
    );
  }
}

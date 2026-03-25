import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/core/app_constants/colors.dart';

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

  // 👉 MUDANÇA 1: Propriedade adicionada
  final TextCapitalization textCapitalization;

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
      horizontal: 20,
      vertical: 18,
    ),
    this.obscureText = false,
    // 👉 MUDANÇA 2: Valor padrão como 'none' para não quebrar campos de senha/email
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const primaryColor = AppColors.lightButtonPrimary;
    final errorColor = theme.colorScheme.error;

    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.05);

    final activeFill =
        fillColor ??
        (isDark ? theme.cardColor.withValues(alpha: 0.6) : theme.cardColor);

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                label!,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.hintColor.withValues(alpha: 0.8),
                  letterSpacing: 0.5,
                ),
              ),
            ),

          TextFormField(
            obscureText: obscureText,
            controller: controller,
            maxLength: maxLength,
            minLines: minLines ?? 1,
            maxLines: obscureText ? 1 : (maxLines ?? 1),
            enabled: enable,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,

            // 👉 MUDANÇA 3: Repassando a propriedade para o widget nativo
            textCapitalization: textCapitalization,

            validator: validator ?? (obrigatorio ? _defaultValidator : null),

            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: enable ? null : theme.disabledColor,
            ),

            decoration: InputDecoration(
              counterText: "",
              hintText: hintText,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor.withValues(alpha: 0.4),
              ),

              prefixIcon: prefixIcon != null
                  ? Icon(
                      prefixIcon,
                      color: enable
                          ? primaryColor.withValues(alpha: 0.7)
                          : theme.disabledColor,
                      size: 20,
                    )
                  : null,
              suffixIcon: suffixIcon,

              filled: true,
              fillColor: enable
                  ? activeFill
                  : theme.disabledColor.withValues(alpha: 0.05),
              contentPadding: contentPadding,

              border: _buildBorder(borderColor),
              enabledBorder: _buildBorder(borderColor),

              focusedBorder: _buildBorder(
                primaryColor.withValues(alpha: 0.5),
                width: 1.5,
              ),

              errorBorder: _buildBorder(errorColor.withValues(alpha: 0.5)),
              focusedErrorBorder: _buildBorder(errorColor, width: 1.5),

              errorStyle: TextStyle(
                color: errorColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }
}

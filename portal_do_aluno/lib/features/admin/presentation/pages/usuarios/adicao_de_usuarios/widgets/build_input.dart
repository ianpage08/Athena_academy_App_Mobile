import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class BuildInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool enabled;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const BuildInput({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.enabled = true,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,

      
      // Agora o texto respeita o tamanho de fonte configurado no sistema operacional do usuário.
      style: theme.textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w500,
        color: enabled ? theme.textTheme.bodyLarge?.color : theme.hintColor,
      ),

      
      cursorColor: theme.colorScheme.primary,

      decoration: InputDecoration(
        labelText: label,
        hintText: hint,

        
        // O Label fica mais sólido, enquanto o hint (placeholder) fica mais apagado para não confundir o usuário.
        labelStyle: TextStyle(
          color: theme.hintColor.withValues(alpha: 0.8),
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(color: theme.hintColor.withValues(alpha: 0.4)),

        
        prefixIcon: Icon(
          icon,
          size: 22,
          color: enabled
              ? theme.colorScheme.primary.withValues(alpha: 0.7)
              : theme.hintColor.withValues(alpha: 0.3),
        ),

        filled: true,

        
        // Usar cores fixas quebra o aplicativo se você decidir lançar um Modo Escuro (Dark Mode).
        fillColor: enabled
            ? theme.colorScheme.surface
            : theme.disabledColor.withValues(alpha: 0.05),

        
        // Aumentei o vertical para 18. Facilita o clique com o dedo, padrão exigido pelas diretrizes da Apple/Google.
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),

        
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 1.5, // Destaque claro de onde o usuário está digitando
          ),
        ),

        
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: theme.colorScheme.error.withValues(alpha: 0.8),
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
        ),
      ),
    );
  }
}

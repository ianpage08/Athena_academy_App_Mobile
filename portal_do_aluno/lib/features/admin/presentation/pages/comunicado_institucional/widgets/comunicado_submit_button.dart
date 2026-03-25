import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // 👉 MUDANÇA: Estética mais clean para loaders

class ComunicadoSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback?
  onSubmit; // 👉 MUDANÇA: Permitir nulo para desabilitar logicamente

  const ComunicadoSubmitButton({
    super.key,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 👉 DESIGN: Uso de AnimatedContainer para feedback visual de estado
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height:
          56, // 👉 UX: Altura levemente maior para melhor área de toque (touch target)
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: isLoading
              ? [
                  theme.disabledColor,
                  theme.disabledColor.withValues(alpha: 0.8),
                ]
              : [
                  theme.primaryColor,
                  theme.primaryColor.withValues(alpha: 0.85),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: isLoading
            ? []
            : [
                BoxShadow(
                  color: theme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: isLoading ? null : onSubmit,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          // 👉 DESIGN: Troca suave entre o texto e o loader
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Row(
                  key: ValueKey('text_content'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.paperplane_fill,
                      size: 20,
                      color: Colors.white,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Disparar Comunicado',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

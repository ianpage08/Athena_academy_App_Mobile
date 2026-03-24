import 'package:flutter/material.dart';

/// Chip premium interativo para seleção de status de presença.
///
/// Refatorado para:
/// - Suportar perfeitamente Dark/Light mode dinamicamente.
/// - Garantir que o efeito "Ripple" (onda de clique) funcione sobre a cor de fundo.
/// - Evitar overflow de texto em telas de celulares menores.
class AttendanceStatusChip extends StatelessWidget {
  final String text;
  final bool selected;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const AttendanceStatusChip({
    super.key,
    required this.text,
    required this.selected,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // --- Definição Dinâmica de Cores (Dark/Light Safe) ---
    // Se não estiver selecionado, usamos cores sutis do próprio tema
    final unselectedBgColor = isDark
        ? theme.canvasColor.withValues(alpha: 0.3)
        : theme.cardColor;

    final unselectedBorderColor = isDark
        ? theme.dividerColor.withValues(alpha: 0.5)
        : theme.dividerColor.withValues(alpha: 0.8);

    final unselectedTextColor = isDark
        ? theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6)
        : Colors.black54;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic, // Curva mais suave e natural
      decoration: BoxDecoration(
        /// Fundo sutil se desmarcado, fundo com alpha da cor base se marcado
        color: selected
            ? color.withValues(alpha: isDark ? 0.15 : 0.1)
            : unselectedBgColor,
        borderRadius: BorderRadius.circular(12),

        /// Borda ganha destaque sutil quando selecionado
        border: Border.all(
          color: selected
              ? color.withValues(alpha: 0.6)
              : unselectedBorderColor,
          width: selected ? 1.5 : 1.0,
        ),
      ),

      /// O Material do tipo 'transparency' por fora do InkWell garante que
      /// o efeito de clique (ripple) não seja engolido pela cor do Container.
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          // Cores do efeito de clique combinando com a cor do botão
          splashColor: color.withValues(alpha: 0.2),
          highlightColor: color.withValues(alpha: 0.1),

          child: Padding(
            // Aumentei um pouco o padding vertical para melhorar a área de toque (hitbox)
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: selected ? color : unselectedTextColor,
                ),
                const SizedBox(width: 6),

                /// Flexible evita o famoso erro de "fita zebrada amarela e preta"
                /// caso o celular do professor seja muito pequeno e o texto não caiba.
                Flexible(
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      // Destaca um pouco mais o peso da fonte se estiver selecionado
                      fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                      color: selected ? color : unselectedTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

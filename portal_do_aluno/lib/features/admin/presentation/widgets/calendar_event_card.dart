import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarEventCard extends StatelessWidget {
  // 🧠 LÓGICA INTACTA: Propriedades mantidas exatamente como você definiu
  final String title;
  final String subtitle;
  final String? date;
  final Color backgroundColor;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const CalendarEventCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.icon,
    this.date,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 👉 MUDANÇA 1: Reestruturação para o "Ripple Effect" (Feedback tátil) funcionar
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ), // Respiro orgânico entre os cards
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), // Curvatura moderna
        border: Border.all(
          color: theme.colorScheme.primary.withValues(
            alpha: 0.05,
          ), // Borda quase imperceptível
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.03,
            ), // Sombra difusa premium
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      // A cor de fundo precisa estar no Material para não cobrir a animação de clique!
      child: Material(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          // 👉 MUDANÇA 2: O padding agora abraça o conteúdo por dentro do InkWell
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Alinha ao topo para textos multilinhas
              children: [
                // 👉 MUDANÇA 3: Avatar "Soft" (Fundo pastel com ícone sólido)
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: backgroundColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: backgroundColor, size: 26),
                ),

                const SizedBox(width: 16),

                // CONTEÚDO PRINCIPAL
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Título
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight
                              .bold, // 👉 MUDANÇA 4: Maior contraste hierárquico
                          letterSpacing: -0.3,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Subtítulo
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor.withValues(alpha: 0.8),
                          height: 1.3,
                        ),
                      ),

                      // 👉 MUDANÇA 5: Renderização Condicional Inteligente (Evita "buracos" no layout)
                      if (date != null && date!.trim().isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.calendar,
                              size: 14,
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.7,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                date!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.8,
                                  ),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // INDICADOR DE AÇÃO (Trailing)
                trailing ??
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 4,
                      ), // Alinhamento óptico com a primeira linha
                      child: Icon(
                        CupertinoIcons.chevron_right,
                        size: 20,
                        color: theme.hintColor.withValues(alpha: 0.3),
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

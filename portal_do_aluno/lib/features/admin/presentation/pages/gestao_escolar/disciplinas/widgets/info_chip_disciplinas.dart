import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/app_constants/colors.dart';

class InfoChipDisciplinas extends StatelessWidget {
  final IconData icon;
  final String title;

  // 👉 MUDANÇA 1: Adição de cor customizável opcional.
  // Permite reutilizar o chip para alertas (ex: cor vermelha se a disciplina estiver inativa).
  final Color? customColor;

  const InfoChipDisciplinas({
    super.key,
    required this.icon,
    required this.title,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final chipColor = customColor ?? AppColors.lightTextPrimary;

    return Container(
      // Padding ajustado para o formato "pílula" (Pill Shape)
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: chipColor.withValues(alpha: 0.15), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: chipColor),
          const SizedBox(width: 6),

          Flexible(
            child: Text(
              title,

              style: theme.textTheme.labelMedium?.copyWith(
                color: chipColor, // Monocromático: texto e ícone na mesma cor
                fontWeight:
                    FontWeight.w600, // Maior peso para compensar o tamanho 14
                letterSpacing: 0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow
                  .ellipsis, // Impede a quebra de tela com nomes gigantes
            ),
          ),
        ],
      ),
    );
  }
}

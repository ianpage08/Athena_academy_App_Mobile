import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Componente de Card para Exercícios do Athena Academy.

class CardExercicio extends StatelessWidget {
  final String titulo;
  final String conteudo;
  final String nomeProfessor;
  final String userId;
  final String exerciciosId;
  final Future<bool> Function(String userId, String exerciciosId)
  getStatusEntregue;

  const CardExercicio({
    super.key,
    required this.titulo,
    required this.conteudo,
    required this.nomeProfessor,
    required this.userId,
    required this.exerciciosId,
    required this.getStatusEntregue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<bool>(
      future: getStatusEntregue(userId, exerciciosId),
      builder: (context, snapshot) {
        final bool entregue = snapshot.data ?? false;
        final bool carregando =
            snapshot.connectionState == ConnectionState.waiting;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(vertical: 8),
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),

            color: theme.cardTheme.color ?? theme.colorScheme.surface,
            border: Border.all(
              color: entregue
                  ? Colors.green.withValues(alpha: 0.3)
                  : theme.dividerColor.withValues(alpha: 0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Row(
              children: [
                Container(
                  width: 6,
                  color: carregando
                      ? theme.hintColor.withValues(alpha: 0.2)
                      : (entregue ? Colors.green : theme.colorScheme.primary),
                ),

                // 👉 MUDANÇA 5: Conteúdo Principal com Flex para evitar overflow
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Exercício de $titulo'.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          conteudo,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // 👉 MUDANÇA 6: Chips sutis para o nome do professor
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.person,
                              size: 14,
                              color: theme.hintColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              nomeProfessor,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // 👉 MUDANÇA 7: Botão de Ação / Status Lateral
                Container(
                  width: 54,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: entregue
                        ? Colors.green.withValues(alpha: 0.1)
                        : theme.colorScheme.primary.withValues(alpha: 0.05),
                  ),
                  child: Center(
                    child: carregando
                        ? const CupertinoActivityIndicator(radius: 8)
                        : Icon(
                            entregue
                                ? CupertinoIcons.checkmark_seal_fill
                                : CupertinoIcons.chevron_right,
                            color: entregue
                                ? Colors.green
                                : theme.colorScheme.primary,
                            size: 22,
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

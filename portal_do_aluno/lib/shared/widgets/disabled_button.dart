import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Botão desabilitado padrão do Design System do Athena.
///
/// Utilizado para indicar visualmente que uma ação ou seleção
/// está temporariamente indisponível (ex: precisa selecionar a turma antes do aluno).
///
/// Arquitetura UX:
/// - Cores neutras baseadas no tema atual (Claro/Escuro) para não quebrar o visual.
/// - Ausência de cores de ação (Primary) para evitar falsa sensação de interatividade.
/// - Uso do ícone de cadeado para comunicação instantânea de "bloqueio".
class DisabledButton extends StatelessWidget {
  final String label;
  final IconData? icon;

  const DisabledButton({super.key, required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // --- Definição Dinâmica de Cores (Dark/Light Safe) ---
    // Fundo: Mistura o fundo da tela com uma transparência muito sutil
    final disabledBgColor = isDark
        ? theme.cardColor.withValues(alpha: 0.3)
        : theme.disabledColor.withValues(alpha: 0.05);

    // Borda: Quase imperceptível, apenas para dar estrutura
    final disabledBorderColor = isDark
        ? theme.dividerColor.withValues(alpha: 0.1)
        : theme.dividerColor.withValues(alpha: 0.2);

    // Texto e Ícones: Apagados, indicando inatividade
    final disabledTextColor = theme.hintColor.withValues(alpha: 0.5);

    return Container(
      width: double.infinity,
      // MUDANÇA: Em vez de fixar height em 60 (o que quebra se o usuário usar
      // fonte gigante no celular), usamos padding simétrico para se adaptar.
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: disabledBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: disabledBorderColor,
          width: 1, // Borda fina, não chama atenção
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // MUDANÇA: O Expanded protege contra TextOverflow (fita amarela e preta)
          Expanded(
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: disabledTextColor, size: 22),
                  const SizedBox(width: 12),
                ],
                // Expanded no texto garante que frases longas ganhem "..."
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight:
                          FontWeight.w500, // Menos peso que um botão ativo
                      color: disabledTextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          Icon(
            CupertinoIcons.lock_fill,
            color: disabledTextColor.withValues(alpha: 0.7),
            size: 18,
          ),
        ],
      ),
    );
  }
}

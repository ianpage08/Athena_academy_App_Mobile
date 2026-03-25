import 'package:flutter/cupertino.dart'; // 👉 MUDANÇA 1: Importado para iconografia premium
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/app_constants/colors.dart';

class PasswordTipsSection extends StatelessWidget {
  const PasswordTipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20), // Curvatura Apple-like
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER DA SEÇÃO
          Row(
            children: [
              const Icon(CupertinoIcons.lock_shield_fill, size: 24),
              const SizedBox(width: 10),
              Text(
                'Critérios de Segurança',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  color: theme
                      .colorScheme
                      .primary, // Alinhamento com a identidade visual
                ),
              ),
            ],
          ),

          const SizedBox(height: 16), // Separação clara entre título e conteúdo

          const _PasswordTipItem(text: 'Mínimo de 8 caracteres'),
          const _PasswordTipItem(text: 'Pelo menos 1 letra maiúscula'),
          const _PasswordTipItem(text: 'Pelo menos 1 letra minúscula'),
          const _PasswordTipItem(text: 'Pelo menos 1 número'),
          const _PasswordTipItem(text: 'Pelo menos 1 símbolo especial'),
        ],
      ),
    );
  }
}

class _PasswordTipItem extends StatelessWidget {
  final String text;

  const _PasswordTipItem({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ), // Respiro orgânico entre os itens
      child: Row(
        crossAxisAlignment: CrossAxisAlignment
            .start, // Alinhamento correto para textos que podem quebrar linha
        children: [
          Icon(
            CupertinoIcons.checkmark_seal_fill,
            size: 18,
            color: AppColors.darkSuccess.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor.withValues(alpha: 0.8),
                height:
                    1.2, // Altura de linha (Line Height) para leitura confortável
              ),
            ),
          ),
        ],
      ),
    );
  }
}

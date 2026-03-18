import 'package:flutter/material.dart';

/// Widget responsável por exibir um card de planejamento/relatório
class ReportCard extends StatelessWidget {
  /// Dados do relatório vindos do Firestore
  final Map<String, dynamic> data;

  /// Quantidade de anexos vinculados ao conteúdo
  final int anexosCount;

  /// Callback acionado ao tocar no card
  final VoidCallback onTap;

  const ReportCard({
    super.key,
    required this.data,
    required this.anexosCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Extrai os dados com fallback seguro
    final String titulo = (data['conteudo'] ?? '').toString().trim();
    final String observacoes = (data['observacoes'] ?? '').toString().trim();
    final bool hasAttachments = anexosCount > 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.55),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.045),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Bloco do ícone principal
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.primaryColor.withValues(alpha: 0.16),
                      theme.primaryColor.withValues(alpha: 0.08),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  color: theme.primaryColor,
                  size: 24,
                ),
              ),

              const SizedBox(width: 14),

              /// Conteúdo textual do card
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Título
                    Text(
                      titulo.isEmpty ? 'Conteúdo sem título' : titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Observações
                    Text(
                      observacoes.isEmpty
                          ? 'Sem observações cadastradas.'
                          : observacoes,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade700,
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// Linha inferior com meta info
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: hasAttachments
                                ? Colors.blue.withValues(alpha: 0.10)
                                : Colors.grey.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: hasAttachments
                                  ? Colors.blue.withValues(alpha: 0.18)
                                  : Colors.grey.withValues(alpha: 0.16),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                hasAttachments
                                    ? Icons.attach_file_rounded
                                    : Icons.info_outline_rounded,
                                size: 15,
                                color: hasAttachments
                                    ? Colors.blue
                                    : Colors.grey.shade700,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                hasAttachments
                                    ? '$anexosCount anexo(s)'
                                    : 'Sem anexos',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: hasAttachments
                                      ? Colors.blue
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              /// Ícone final de navegação
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

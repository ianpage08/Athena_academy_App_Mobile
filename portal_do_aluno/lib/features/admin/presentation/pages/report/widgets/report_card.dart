import 'package:flutter/material.dart';

// Widget responsável por exibir um "card" de planejamento/relatório
// Estrutura pensada para lista (provavelmente ListView)
class ReportCard extends StatelessWidget {
  // Mapa genérico vindo provavelmente do Firestore
  // ⚠️ Aqui já temos um ponto de melhoria (tipagem forte depois)
  final Map<String, dynamic> data;

  // Quantidade de anexos vinculados ao planejamento
  final int anexosCount;

  // Callback ao clicar no card (navegação ou detalhes)
  final VoidCallback onTap;

  const ReportCard({
    super.key,
    required this.data,
    required this.anexosCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Pega o tema global 
    final theme = Theme.of(context);

    // Extrai o conteúdo do mapa com fallback seguro
    final titulo = (data['conteudo'] ?? '').toString().trim();

    // Observações adicionais do planejamento
    final obs = (data['observacoes'] ?? '').toString().trim();

    return Material(
      color: Colors.transparent,

      // InkWell dá feedback de clique (ripple)
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,

        // Ink permite aplicar decoração + ripple corretamente
        child: Ink(
          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),

            // Cor do card baseada no tema (dark/light ready 🔥)
            color: theme.cardColor,

            // Borda leve para separação visual
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.6),
            ),

            // Sombra suave (efeito moderno)
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:  0.05),
                blurRadius: 12,
                offset: const Offset(0, 7),
              ),
            ],
          ),

          // Layout principal horizontal
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ícone lateral (identidade visual do item)
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),

                  // Fundo com opacidade da cor primária
                  color: theme.primaryColor.withValues(alpha:  0.10),
                ),
                child: Icon(Icons.menu_book_rounded, color: theme.primaryColor),
              ),

              const SizedBox(width: 14),

              // Conteúdo principal ocupa o espaço restante
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título do planejamento
                    Text(
                      titulo.isEmpty ? 'Conteúdo sem título' : titulo,

                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      // Destaque visual forte
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Observações (descrição secundária)
                    Text(
                      obs.isEmpty ? 'Sem observações.' : obs,

                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,

                      // Texto mais suave (hierarquia visual)
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                        height: 1.25,
                      ),
                    ),

                    // Exibe badge de anexos somente se existir
                    if (anexosCount > 0) ...[
                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),

                          // Badge leve azul (call to action visual)
                          color: Colors.blue.withValues(alpha: 0.10),
                        ),

                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Ícone de anexo
                            const Icon(
                              Icons.attach_file,
                              size: 16,
                              color: Colors.blue,
                            ),

                            const SizedBox(width: 6),

                            // Texto com quantidade de anexos
                            Text(
                              '$anexosCount anexo(s)',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Ícone de navegação (indica que é clicável)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

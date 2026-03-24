import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/student/presentation/pages/boletim/widgets/nota_info_chip.dart';
import 'package:portal_do_aluno/features/teacher/data/models/grade_record.dart';

/// Card expansível premium para exibição de notas e médias.

class DisciplineTile extends StatelessWidget {
  final GradeRecord disciplina;

  const DisciplineTile({super.key, required this.disciplina});

  // Helper de Regra de Negócio Visual
  // Transforma o número frio em um feedback visual instantâneo para o aluno.
  Color _getGradeColor(double grade, BuildContext context) {
    final theme = Theme.of(context);
    if (grade >= 7.0) return const Color(0xFF34D399); // Verde Sucesso Premium
    if (grade >= 5.0) return const Color(0xFFFBBF24); // Amarelo Alerta
    return theme.colorScheme.error; // Vermelho Perigo
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final mediasPorUnidade = disciplina.calcularMediaPorUnidade();
    final mediaFinal = disciplina.calcularMediaFinal() ?? 0.0;
    final finalGradeColor = _getGradeColor(mediaFinal, context);

    // Em vez de soltar o ExpansionTile cru na tela, colocamos ele dentro
    // de um "quadro" para criar a sensação de Dashboard.
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: isDark ? 0.05 : 0.1),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(8, 0, 0, 0),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),

      // O truque do Theme para remover a linha divisória nativa (Mantido do seu código original!)
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          //  Ícone acompanhando a cor da nota final
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: finalGradeColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.book_fill,
              color: finalGradeColor,
              size: 22,
            ),
          ),

          title: Row(
            children: [
              Expanded(
                child: Text(
                  disciplina.nomeDisciplina,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),

              // 👉 MUDANÇA 4: Badge de Nota Final
              // Transforma aquele texto simples em uma "etiqueta" de destaque
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: finalGradeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: finalGradeColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  mediaFinal.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: finalGradeColor,
                  ),
                ),
              ),
            ],
          ),

          // 👉 MUDANÇA 5: Refinamento da lista interna (Unidades)
          children: disciplina.notas.entries.map((entry) {
            final unidade = entry.key;
            final valores = entry.value;
            final mediaUnidade = mediasPorUnidade[unidade] ?? 0.0;
            final unitGradeColor = _getGradeColor(mediaUnidade, context);

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Divisor sutil entre o cabeçalho e as unidades
                  Divider(color: theme.dividerColor.withValues(alpha: 0.1)),
                  const SizedBox(height: 12),

                  // Cabeçalho da Unidade
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Unidade $unidade',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.hintColor,
                        ),
                      ),
                      Text(
                        'Média: ${mediaUnidade.toStringAsFixed(1)}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: unitGradeColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // O Wrap substitui as Rows fixas. Se a tela for apertada,
                  // os chips caem para a linha de baixo automaticamente!
                  Wrap(
                    spacing: 12, // Espaço horizontal entre os chips
                    runSpacing: 12, // Espaço vertical se quebrar a linha
                    children: [
                      NotaInfoChip(
                        titulo: 'Teste: ${valores['teste'] ?? '---'}',
                        icone: CupertinoIcons.doc_text,
                      ),
                      NotaInfoChip(
                        titulo: 'Trabalho: ${valores['trabalho'] ?? '---'}',
                        icone: CupertinoIcons.briefcase,
                      ),
                      NotaInfoChip(
                        titulo: 'Prova: ${valores['prova'] ?? '---'}',
                        icone: CupertinoIcons.doc_checkmark,
                      ),
                      NotaInfoChip(
                        titulo: 'Extra: ${valores['notaextra'] ?? '---'}',
                        icone: CupertinoIcons.star,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/student/presentation/pages/boletim/widgets/nota_info_chip.dart';
import 'package:portal_do_aluno/features/teacher/data/models/grade_record.dart';

class DisciplineTile extends StatelessWidget {
  final GradeRecord disciplina;

  const DisciplineTile({super.key, required this.disciplina});

  @override
  Widget build(BuildContext context) {
    final mediasPorUnidade = disciplina.calcularMediaPorUnidade();
    final mediaFinal = disciplina.calcularMediaFinal() ?? 0.0;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: const Icon(CupertinoIcons.book),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                disciplina.nomeDisciplina,
                style: Theme.of(context).textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Média Final: ${mediaFinal.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        children: disciplina.notas.entries.map((entry) {
          final unidade = entry.key;
          final valores = entry.value;
          final mediaUnidade = mediasPorUnidade[unidade] ?? 0.0;

          return ListTile(
            title: Text('Unidade $unidade'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Média desta unidade: ${mediaUnidade.toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NotaInfoChip(
                      titulo: 'Teste: ${valores['teste'] ?? '---'}',
                      icone: CupertinoIcons.checkmark_alt_circle,
                    ),
                    NotaInfoChip(
                      titulo: 'Trabalho: ${valores['trabalho'] ?? '---'}',
                      icone: CupertinoIcons.briefcase,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NotaInfoChip(
                      titulo: 'Prova: ${valores['prova'] ?? '---'}',
                      icone: CupertinoIcons.doc_text_search,
                    ),
                    NotaInfoChip(
                      titulo: 'Extra: ${valores['notaextra'] ?? '---'}',
                      icone: CupertinoIcons.star_circle,
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

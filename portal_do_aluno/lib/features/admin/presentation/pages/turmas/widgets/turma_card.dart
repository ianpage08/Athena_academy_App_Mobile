import 'package:flutter/material.dart';

import 'package:portal_do_aluno/features/admin/presentation/pages/turmas/widgets/info_chip.dart';
import 'package:portal_do_aluno/shared/helpers/app_confirmation_dialog.dart';
import 'package:portal_do_aluno/shared/widgets/action_menu_button.dart';

class TurmaCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function() onDelete;

  const TurmaCard({
    super.key,
    required this.data,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final String turno = data['turno'] ?? '';
    final String professor = data['professor'] ?? '';
    final int qtdAlunos = data['qtdAlunos'] ?? 0;
    final String serie = data['serie'] ?? '';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AVATAR
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  serie.isNotEmpty ? serie[0] : '?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // CONTEÚDO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serie,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      InfoChip(icon:   Icons.person, title:  professor),
                      InfoChip(icon:   Icons.schedule,title:   turno),
                      InfoChip(icon:   Icons.group,title:   '$qtdAlunos alunos'),
                    ],
                  ),
                ],
              ),
            ),

            // MENU
            ActionMenuButton(
              id: data['id'],
              items: [
                MenuItemConfig(
                  value: 'excluir',
                  label: 'Excluir',
                  onSelected: (id, context, extra) async {
                    if (id == null) return;

                    final confirmar = await showAppConfirmationDialog(
                      context: context,
                      title: 'Excluir turma?',
                      content: 'Essa ação é irreversível.',
                      confirmText: 'Excluir',
                    );

                    if (confirmar == true) {
                      onDelete;
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

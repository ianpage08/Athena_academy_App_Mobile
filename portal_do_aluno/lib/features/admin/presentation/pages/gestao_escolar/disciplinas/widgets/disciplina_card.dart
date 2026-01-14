import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/cadastrar_diciplina_firestore.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/disciplinas/widgets/info_chip_disciplinas.dart';
import 'package:portal_do_aluno/shared/helpers/app_confirmation_dialog.dart';
import 'package:portal_do_aluno/shared/widgets/action_menu_button.dart';

class DisciplinaCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final DisciplinaService disciplinaService;

  const DisciplinaCard({
    super.key,
    required this.data,
    required this.disciplinaService,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ÍCONE
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.book, color: Theme.of(context).iconTheme.color),
            ),

            const SizedBox(width: 16),

            // CONTEÚDO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TÍTULO
                  Text(
                    data['nome'] ?? 'Disciplina',
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
                      InfoChipDisciplinas(
                        icon: Icons.person,
                        title: data['professor'] ?? 'Sem professor',
                      ),

                      InfoChipDisciplinas(
                        icon: Icons.event_note,
                        title: '${data['aulaPrevistas'] ?? '--'} aulas',
                      ),
                      InfoChipDisciplinas(
                        icon: Icons.schedule,
                        title: '${data['cargaHoraria'] ?? '--'}h',
                      ),
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
                      title: 'Excluir disciplina?',
                      content: 'Essa ação é irreversível.',
                    );

                    if (confirmar == true) {
                      disciplinaService.excluirDisciplina(id);
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

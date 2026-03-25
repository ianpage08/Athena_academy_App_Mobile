import 'package:flutter/cupertino.dart'; // 👉 MUDANÇA 1: Importado para manter o padrão visual dos ícones
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
    final theme = Theme.of(context);

    final String nome = data['nome'] ?? 'Disciplina Indefinida';
    final String professor = data['professor'] ?? 'Sem professor alocado';
    final String aulas = data['aulaPrevistas']?.toString() ?? '--';
    final String horas = data['cargaHoraria']?.toString() ?? '--';

    return Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ), // Dá respiro entre os itens da lista
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20), // Curvatura moderna e orgânica
        border: Border.all(
          color: theme.colorScheme.primary.withValues(
            alpha: 0.3,
          ), // Borda quase invisível
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03), // Sombra hiper suave
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52, // Tamanho equilibrado para leitura de grid
              height: 52,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                CupertinoIcons.book_fill, // Ícone preenchido (mais peso visual)
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // CONTEÚDO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TÍTULO
                  Text(
                    nome,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                    maxLines:
                        2, // Previne quebra de layout se o nome for imenso
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      InfoChipDisciplinas(
                        icon: CupertinoIcons.person_fill,
                        title: professor,
                      ),
                      InfoChipDisciplinas(
                        icon: CupertinoIcons.calendar_today,
                        title: '$aulas aulas',
                      ),
                      InfoChipDisciplinas(
                        icon: CupertinoIcons.clock_fill,
                        title: '${horas}h',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // MENU DE AÇÕES
            ActionMenuButton(
              id: data['id'],
              items: [
                MenuItemConfig(
                  value: 'excluir',
                  label: 'Excluir Disciplina',
                  onSelected: (id, context, extra) async {
                    if (id == null) return;

                    final confirmar = await showAppConfirmationDialog(
                      context: context,
                      title: 'Excluir Disciplina?',

                      content:
                          'Essa ação apagará permanentemente a matéria do sistema.',
                      confirmText: 'Excluir',
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

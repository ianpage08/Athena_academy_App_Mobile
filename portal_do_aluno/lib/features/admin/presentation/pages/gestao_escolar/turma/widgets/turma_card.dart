import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // 👉 MUDANÇA: Importado para consistência de ícones
import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/turma/widgets/info_chip.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/turma/widgets/stream_alunos_contagem.dart';
import 'package:portal_do_aluno/shared/helpers/app_confirmation_dialog.dart';
import 'package:portal_do_aluno/shared/widgets/action_menu_button.dart';

class TurmaCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function() onDelete;

  const TurmaCard({super.key, required this.data, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Fallbacks de segurança para evitar quebra de UI se vier nulo
    final String turno = data['turno'] ?? 'Não definido';
    final String professor = data['professorTitular'] ?? 'Sem professor';
    final String serie = data['serie'] ?? 'Série indefinida';

    
    return Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ), // Dá respiro entre os cards na lista
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20), // Curvatura orgânica e moderna
        border: Border.all(
          color: theme.colorScheme.primary.withValues(
            alpha: 0.3,
          ), // Borda quase invisível
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.03,
            ), // Sombra hiper suave e difusa
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          20,
        ), 
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Container(
              width: 52, // Aumentado levemente para dar presença
              height: 52,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(
                  16,
                ), // Acompanha a curvatura do card externo
              ),
              child: Center(
                child: Text(
                  serie.isNotEmpty
                      ? serie[0].toUpperCase()
                      : '?', // Garante letra maiúscula
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900, // Fonte bold impactante
                    color:
                        theme.colorScheme.primary, // Cor atrelada à identidade
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
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 12),

                  
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      InfoChip(
                        icon: CupertinoIcons.person_fill,
                        title: professor,
                      ),
                      InfoChip(
                        icon:
                            CupertinoIcons.sun_max_fill, 
                        title: turno,
                      ),

                      
                      StreamBuilder<Map<String, int>>(
                        stream: alunosPorTurma(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const InfoChip(
                              icon: CupertinoIcons.person_3_fill,
                              
                              title: 'Carregando...',
                            );
                          }
                          final mapa = snapshot.data!;
                          final turmaId = data['id'];
                          final quantidade = mapa[turmaId] ?? 0;

                          return InfoChip(
                            icon: CupertinoIcons.person_3_fill,
                            
                            title:
                                '$quantidade aluno${quantidade == 1 ? '' : 's'}',
                          );
                        },
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
                  label: 'Excluir Turma',
                  onSelected: (id, context, extra) async {
                    if (id == null) return;

                    final confirmar = await showAppConfirmationDialog(
                      context: context,
                      title: 'Excluir turma?',
                      content:
                          'Essa ação é irreversível e os dados não poderão ser recuperados.',
                      confirmText: 'Excluir',
                    );

                    if (confirmar == true) {
                      onDelete();
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

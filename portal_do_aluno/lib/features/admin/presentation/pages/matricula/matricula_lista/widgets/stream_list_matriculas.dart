import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/matricula_firestore.dart';
import 'package:portal_do_aluno/navigation/navigation_service.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/shared/helpers/app_confirmation_dialog.dart';
import 'package:portal_do_aluno/shared/widgets/action_menu_button.dart';

class StreamListMatriculas extends StatelessWidget {
  final MatriculaService matriculaService;

  const StreamListMatriculas({super.key, required this.matriculaService});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('matriculas').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator(radius: 14));
        }

        if (snapshot.hasError) {
          return _buildStateFeedback(
            context,
            icon: CupertinoIcons.exclamationmark_triangle,
            message:
                'Erro ao carregar matrículas.\nTente novamente mais tarde.',
            isError: true,
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildStateFeedback(
            context,
            icon: CupertinoIcons.person_3,
            message: 'Nenhum aluno matriculado ainda.',
          );
        }

        final docMatriculas = snapshot.data!.docs;

        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          itemCount: docMatriculas.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: 12), // Espaçamento orgânico
          itemBuilder: (context, index) {
            final matriculaDoc = docMatriculas[index];
            final data =
                matriculaDoc.data() as Map<String, dynamic>; // Tipagem segura

            return _buildMatriculaCard(context, matriculaDoc.id, data);
          },
        );
      },
    );
  }

  /// Constrói o visual do Card do Aluno (Isolado para facilitar manutenção)
  Widget _buildMatriculaCard(
    BuildContext context,
    String matriculaId,
    Map<String, dynamic> data,
  ) {
    final theme = Theme.of(context);
    final dadosAluno = data['dadosAluno'] ?? {};
    final dadosAcademicos = data['dadosAcademicos'] ?? {};

    return Container(
      padding: const EdgeInsets.all(
        16,
      ), // Aumentado para melhor respiro (Touch Target)
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(
          20,
        ), // Curvatura alinhada ao design do Calendário
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.03,
            ), // Sombra difusa e elegante
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // AVATAR "SOFT"
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(
                16,
              ), // Formato "Squircle" (Apple style) ao invés de círculo perfeito
            ),
            child: Icon(
              CupertinoIcons.person_fill,
              color: theme.colorScheme.primary,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // INFORMAÇÕES DO ALUNO (Tipografia Dinâmica)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dadosAluno['nome'] ?? 'Nome não informado',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),

                // Badges de informação (Matrícula e Turma)
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        '•',
                        style: TextStyle(
                          color: theme.hintColor.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Turma: ${dadosAcademicos['turma'] ?? '---'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.8,
                          ),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          
          ActionMenuButton(
            id: matriculaId,
            items: [
              MenuItemConfig(
                value: 'detalhes',
                label: 'Detalhes',
                onSelected: (id, context, extra) {
                  NavigatorService.navigateTo(
                    RouteNames.adminDetalhesAlunos,
                    arguments: id,
                  );
                },
              ),
              MenuItemConfig(
                value: 'excluir',
                label: 'Excluir',
                onSelected: (id, context, extra) async {
                  if (id == null) return;
                  final excluir = await showAppConfirmationDialog(
                    context: context,
                    title: 'Excluir matrícula?',
                    content:
                        'Essa ação apagará permanentemente os dados do aluno. Deseja continuar?',
                  );
                  if (excluir == true) {
                    matriculaService.excluirMatricula(id);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Helper para telas vazias ou de erro não parecerem que o app "quebrou"
  Widget _buildStateFeedback(
    BuildContext context, {
    required IconData icon,
    required String message,
    bool isError = false,
  }) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: isError
                ? theme.colorScheme.error.withValues(alpha: 0.5)
                : theme.hintColor.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.hintColor.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

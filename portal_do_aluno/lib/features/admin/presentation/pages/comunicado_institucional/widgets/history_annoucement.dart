import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/cadastro_comunicado_firestore.dart';
import 'package:portal_do_aluno/shared/helpers/app_confirmation_dialog.dart';
import 'package:portal_do_aluno/shared/widgets/action_menu_button.dart';

class HistoryAnnoucement extends StatefulWidget {
  const HistoryAnnoucement({super.key});

  @override
  State<HistoryAnnoucement> createState() => _HistoryAnnoucementState();
}

class _HistoryAnnoucementState extends State<HistoryAnnoucement> {
  late final ComunicadoService _comunicadoService;

  @override
  void initState() {
    super.initState();
    _comunicadoService = ComunicadoService();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: _buildSectionHeader(theme),
        ),

        const SizedBox(height: 20),

        StreamBuilder<QuerySnapshot>(
          stream: _comunicadoService.getComunicados(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CupertinoActivityIndicator(),
                ),
              );
            }

            if (snapshot.hasError) return _buildErrorState(theme);

            final historicoData = snapshot.data?.docs ?? [];

            if (historicoData.isEmpty) return _buildEmptyState(theme);

            return ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 24),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: historicoData.length,
              
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = historicoData[index];
                return _ComunicadoTile(
                  item: item,
                  onDelete: () => _confirmDelete(context, item.id),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildSectionHeader(ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            CupertinoIcons.time,
            size: 18,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Histórico de Atividade',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(
            CupertinoIcons.tray,
            size: 48,
            color: theme.hintColor.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum comunicado enviado',
            style: TextStyle(color: theme.hintColor),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Text(
        'Erro ao sincronizar dados.',
        style: TextStyle(color: theme.colorScheme.error),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String id) async {
    final excluir = await showAppConfirmationDialog(
      context: context,
      title: 'Remover Comunicado?',
      content: 'Esta mensagem desaparecerá para todos os alunos e professores.',
      confirmText: 'Confirmar Exclusão',
    );
    if (excluir == true) {
      _comunicadoService.excluirComunicado(id);
    }
  }
}

class _ComunicadoTile extends StatelessWidget {
  final QueryDocumentSnapshot item;
  final VoidCallback onDelete;

  const _ComunicadoTile({required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dataPublicacao = (item['dataPublicacao'] as Timestamp).toDate();
    final dataFormatada = DateFormat(
      'dd MMM • HH:mm',
      'pt_BR',
    ).format(dataPublicacao);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              Container(
                width: 6,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(
                    16,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Centraliza conteúdo verticalmente se houver espaço
                          children: [
                            Text(
                              item['titulo'],
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item['mensagem'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.hintColor,
                                height:
                                    1.3, // Altura de linha ajustada para simetria visual
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Meta-dados alinhados com a base
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.clock,
                                  size: 14,
                                  color: theme.hintColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  dataFormatada,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.hintColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // para não quebrar o eixo visual do título.
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ActionMenuButton(
                          id: item['id'],
                          items: [
                            MenuItemConfig(
                              value: 'Excluir',
                              label: 'Excluir',
                              onSelected: (id, context, extra) => onDelete(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

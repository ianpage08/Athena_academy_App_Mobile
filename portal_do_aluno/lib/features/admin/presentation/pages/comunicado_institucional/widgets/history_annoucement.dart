import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  final ComunicadoService _comunicadoService = ComunicadoService();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.history_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Histórico de Comunicados',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),

        const SizedBox(height: 16),

        StreamBuilder<QuerySnapshot>(
          stream: _comunicadoService.getComunicados(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text('Erro ao carregar os comunicados'),
              );
            }

            final historicoData = snapshot.data?.docs ?? [];

            if (historicoData.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'Nenhum comunicado publicado',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: historicoData.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = historicoData[index];

                final dataPublicacao = (item['dataPublicacao'] as Timestamp)
                    .toDate();

                final dataFormatada = DateFormat(
                  'dd/MM/yyyy • HH:mm',
                ).format(dataPublicacao);

                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(25, 0, 0, 0),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar / ícone
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.campaign_rounded,
                            size: 22,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Conteúdo
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['titulo'],
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                item['mensagem'],
                                style: Theme.of(context).textTheme.bodySmall,
                              ),

                              const SizedBox(height: 8),

                              Row(
                                children: [
                                  const Icon(
                                    Icons.schedule,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    dataFormatada,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Menu de ações
                        ActionMenuButton(
                          id: item['id'],
                          items: [
                            MenuItemConfig(
                              value: 'Excluir',
                              label: 'Excluir',
                              onSelected: (id, context, extra) async {
                                final excluir = await showAppConfirmationDialog(
                                  context: context,
                                  title: 'Excluir comunicado?',
                                  content: 'Essa ação não poderá ser desfeita.',
                                  confirmText: 'Excluir',
                                );
                                if (excluir == true) {
                                  _comunicadoService.excluirComunicado(id!);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

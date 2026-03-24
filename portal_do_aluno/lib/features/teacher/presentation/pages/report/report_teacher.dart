import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/pages/lesson_datail_page.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/report_card.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/user_provider.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';
import 'package:portal_do_aluno/shared/widgets/empty_state_widget.dart';
import 'package:provider/provider.dart';

/// Tela premium que exibe o histórico de relatórios do professor logado.
///
/// Arquitetura e Performance:
/// - [MUDANÇA CRÍTICA]: Stream movido para o `initState` para evitar vazamento
///   de leituras no Firestore (Performance e Custos).
/// - [UX Defensiva]: Retorno seguro com `Scaffold` caso o usuário seja nulo,
///   evitando a "Tela Preta da Morte" do Flutter.
/// - [UI/UX]: Agrupamento visual de Empty States e padronização de tipografia.
class ReportTeacher extends StatefulWidget {
  const ReportTeacher({super.key});

  @override
  State<ReportTeacher> createState() => _ReportTeacherState();
}

class _ReportTeacherState extends State<ReportTeacher> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _reportsStream;
  String? _teacherId;

  @override
  void initState() {
    super.initState();

    // O Provider lê o ID uma vez e a query é montada e guardada na memória.
    _teacherId = context.read<UserProvider>().userId;

    if (_teacherId != null) {
      _reportsStream = FirebaseFirestore.instance
          .collection('conteudoPresenca')
          .where('teacherId', isEqualTo: _teacherId)
          .snapshots();
    }
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required String message,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 48,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.hintColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_teacherId == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Meus Relatórios'),
        body: _buildEmptyState(
          context,
          message:
              'Sessão expirada ou usuário não identificado.\nPor favor, faça login novamente.',
          icon: CupertinoIcons.person_crop_circle_badge_xmark,
        ),
      );
    }

    return Scaffold(
      // aparecendo duas vezes na mesma tela.
      appBar: const CustomAppBar(title: 'Histórico de Aulas'),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho premium com hierarquia textual
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Text(
              'Aulas Registradas',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Text(
              'Consulte os conteúdos e anexos enviados anteriormente.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor.withValues(alpha: 0.8),
              ),
            ),
          ),

          // --- LISTA DE DADOS (Conectada ao Stream Seguro) ---
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream:
                  _reportsStream, // Lê da variável protegida, e não de uma nova função!
              builder: (context, snapshot) {
                // Loading elegante (sem travar a tela)
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CupertinoActivityIndicator(radius: 16),
                  );
                }

                // Erro na requisição do Firebase
                if (snapshot.hasError) {
                  return _buildEmptyState(
                    context,
                    message:
                        'Ocorreu um erro ao buscar seus relatórios.\nTente novamente mais tarde.',
                    icon: CupertinoIcons.exclamationmark_triangle,
                  );
                }

                final docs = snapshot.data?.docs ?? [];

                // Lista Vazia
                if (docs.isEmpty) {
                  return const EmptyStateWidget(
                    title: ' Relatorios',
                    description:
                        'Você ainda não possui\nnenhum relatório registrado.',
                    icon: CupertinoIcons.doc_text_search,
                  );
                }

                // Renderização da Lista
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final data = docs[index].data();

                    // Extração de lista 100% segura contra Null/TypeCast errors
                    final anexos =
                        (data['anexo'] as List<dynamic>?)
                            ?.map((e) => e.toString())
                            .toList() ??
                        [];

                    return ReportCard(
                      data: data,
                      anexosCount: anexos.length,
                      onTap: () {
                        // Transição de página suave estilo iOS
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => LessonDetailPage(
                              reportData: data,
                              attachments: anexos,
                              isActionEnabled: false,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

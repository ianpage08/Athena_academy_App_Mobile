import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/pages/lesson_datail_page.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/filter_bar.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/report_card.dart';
import 'package:portal_do_aluno/shared/widgets/chip_filtro.dart';

class ReportStreamBuilder extends StatefulWidget {
  const ReportStreamBuilder({super.key});

  @override
  State<ReportStreamBuilder> createState() => _ReportStreamBuilderState();
}

class _ReportStreamBuilderState extends State<ReportStreamBuilder> {
  String? filtroTurmaId; //  fica no STATE (não no build)

  Stream<QuerySnapshot<Map<String, dynamic>>> _reportsStream() {
    final base = FirebaseFirestore.instance
        .collection('conteudoPresenca')
        .orderBy('data', descending: true);

    //aplica filtro quando existir
    if (filtroTurmaId != null) {
      return base.where('classId', isEqualTo: filtroTurmaId).snapshots();
    }
    return base.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        FilterBar(
          filtroTurmaId: filtroTurmaId,
          onSelectAll: () => setState(() => filtroTurmaId = null),
          onSelectTurma: (value) {
            setState(() => filtroTurmaId = value);
            debugPrint('filtroTurmaId: $filtroTurmaId');
          },
        ),

        const SizedBox(height: 12),

        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _reportsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                debugPrint('erorororororororo ${snapshot.error.toString()}');
                return const Center(child: Text('Erro ao carregar relatórios'));
              }
              final docs = snapshot.data?.docs ?? [];
              if (docs.isEmpty) {
                return const Center(child: Text('Nenhum arquivo encontrado'));
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: docs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final data = docs[index].data();
                  final anexos = List<String>.from(data['anexo'] ?? []);

                  return ReportCard(
                    data: data,
                    anexosCount: anexos.length,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              LessonDetailPage(data: data, anexos: anexos),
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
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/pages/lesson_datail_page.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/report_card.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/user_provider.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

// Tela que exibe os relatórios do professor logado
class ReportTeacher extends StatefulWidget {
  const ReportTeacher({super.key});

  @override
  State<ReportTeacher> createState() => _ReportTeacherState();
}

class _ReportTeacherState extends State<ReportTeacher> {
  // Cria uma stream filtrando os relatórios pelo ID do professor
  Stream<QuerySnapshot<Map<String, dynamic>>> _reportsStream(String teacherId) {
    final ref = FirebaseFirestore.instance.collection('conteudoPresenca');

    // Query que filtra somente os documentos do professor logado
    final searchId = ref.where('teacherId', isEqualTo: teacherId);

    return searchId.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    // Pega o ID do professor via Provider
    final teacherId = context.read<UserProvider>().userId;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Meus Relatorios'),

      body: Padding(
        padding: const EdgeInsets.all(8.0),

        child: Column(
          children: [
            // Título da página
            const Text(
              'Relatorios do professor',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            // Lista ocupa o restante da tela
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _reportsStream(teacherId!), // ⚠️ cuidado com o !

                builder: (context, snapshot) {
                  // Estado de carregamento
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Tratamento de erro
                  if (snapshot.hasError) {
                    debugPrint('error ${snapshot.error.toString()}');
                    return const Center(
                      child: Text('Erro ao carregar relatórios'),
                    );
                  }

                  // Lista de documentos
                  final doc = snapshot.data?.docs ?? [];

                  // Caso não haja dados
                  if (doc.isEmpty) {
                    return const Center(
                      child: Text('Nenhum arquivo encontrado'),
                    );
                  }

                  // Lista de relatórios
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),

                    itemCount: doc.length,

                    // Espaçamento entre os cards
                    separatorBuilder: (_, __) => const SizedBox(height: 12),

                    itemBuilder: (context, index) {
                      final data = doc[index].data();

                      // Converte lista de anexos com segurança
                      final anexos = List<String>.from(data['anexo'] ?? []);

                      return ReportCard(
                        data: data,
                        anexosCount: anexos.length,

                        // Navegação para tela de detalhes
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LessonDetailPage(
                                reportData: data,
                                attachments: anexos,

                                // Define comportamento (admin vs professor)
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
      ),
    );
  }
}

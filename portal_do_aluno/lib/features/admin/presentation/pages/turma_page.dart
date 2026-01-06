import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/cadastro_turma_firestore.dart';
import 'package:portal_do_aluno/shared/helpers/show_confirmation_dialog.dart';
import 'package:portal_do_aluno/shared/widgets/popup_menu_botton.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';

class TurmaPage extends StatefulWidget {
  const TurmaPage({super.key});

  @override
  State<TurmaPage> createState() => _TurmaPageState();
}

class _TurmaPageState extends State<TurmaPage> {
  final CadastroTurmaService _cadastroTurmaService = CadastroTurmaService();

  final Stream<QuerySnapshot> minhaStream = FirebaseFirestore.instance
      .collection('turmas')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turmas'),
        automaticallyImplyLeading: false,
        actions: [
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: IconButton(
              onPressed: () {
                NavigatorService.navigateTo(RouteNames.adminCadastroTurmas);
              },
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: Padding(padding: const EdgeInsets.all(16), child: _buildStream()),
    );
  }

  Widget _buildStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: minhaStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar turmas'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Nenhuma turma cadastrada'));
        }

        final turmas = snapshot.data!.docs;

        return ListView.separated(
          itemCount: turmas.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final data = turmas[index].data() as Map<String, dynamic>;

            return _buildTurmaCard(data);
          },
        );
      },
    );
  }

  Widget _buildTurmaCard(Map<String, dynamic> data) {
    final serie = data['serie'] ?? '---';
    final turno = data['turno'] ?? '---';
    final qtdAlunos = data['qtdAlunos'] ?? 0;
    final professor = data['professorTitular'] ?? '---';

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
                color: Colors.deepPurple.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  serie.isNotEmpty ? serie[0] : '?',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
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
                      _infoChip(Icons.person, professor),
                      _infoChip(Icons.schedule, turno),
                      _infoChip(Icons.group, '$qtdAlunos alunos'),
                    ],
                  ),
                ],
              ),
            ),

            // MENU
            MenuPontinhoGenerico(
              id: data['id'],
              items: [
                MenuItemConfig(
                  value: 'excluir',
                  label: 'Excluir',
                  onSelected: (id, context, extra) async {
                    if (id == null) return;

                    final confirmar = await showConfirmationDialog(
                      context: context,
                      title: 'Excluir turma?',
                      content: 'Essa ação é irreversível.',
                      confirmText: 'Excluir',
                    );

                    if (confirmar == true) {
                      _cadastroTurmaService.excluirTurma(id);
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

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.black54),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

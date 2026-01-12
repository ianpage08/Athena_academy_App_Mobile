import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/cadastrar_diciplina_firestore.dart';
import 'package:portal_do_aluno/shared/helpers/app_confirmation_dialog.dart';
import 'package:portal_do_aluno/shared/widgets/action_menu_button.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';

class DiciplinasPage extends StatefulWidget {
  const DiciplinasPage({super.key});

  @override
  State<DiciplinasPage> createState() => _DiciplinasPageState();
}

class _DiciplinasPageState extends State<DiciplinasPage> {
  final DisciplinaService _disciplinaService = DisciplinaService();

  final Stream<QuerySnapshot> minhaStream = FirebaseFirestore.instance
      .collection('disciplinas')
      .orderBy('nome')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disciplinas'),
        automaticallyImplyLeading: false,
        actions: [
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 16),
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                onPressed: () {
                  NavigatorService.navigateTo(
                    RouteNames.adminCadastrarDisciplina,
                  );
                },
                icon: const Icon(Icons.add),
              ),
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
          return const Center(child: Text('Erro ao carregar disciplinas'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Nenhuma disciplina cadastrada'));
        }

        final disciplinas = snapshot.data!.docs;

        return ListView.separated(
          itemCount: disciplinas.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final data = disciplinas[index].data() as Map<String, dynamic>;

            return _buildDisciplinaCard(data);
          },
        );
      },
    );
  }

  Widget _buildDisciplinaCard(Map<String, dynamic> data) {
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
                color: Colors.deepPurple.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.book, color: Colors.deepPurple),
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
                      _infoChip(
                        Icons.person,
                        data['professor'] ?? 'Sem professor',
                      ),

                      _infoChip(
                        Icons.event_note,
                        '${data['aulaPrevistas'] ?? '--'} aulas',
                      ),
                      _infoChip(
                        Icons.schedule,
                        '${data['cargaHoraria'] ?? '--'}h',
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
                      _disciplinaService.excluirDisciplina(id);
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
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

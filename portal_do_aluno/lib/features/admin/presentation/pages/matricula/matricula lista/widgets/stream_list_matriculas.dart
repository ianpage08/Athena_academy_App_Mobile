import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/matricula_firestore.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/shared/helpers/app_confirmation_dialog.dart';
import 'package:portal_do_aluno/shared/widgets/action_menu_button.dart';

class StreamListMatriculas extends StatelessWidget {
  final MatriculaService  matriculaService;

  const StreamListMatriculas({super.key, required this.matriculaService});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:  FirebaseFirestore.instance
      .collection('matriculas')
      .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar os dados'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Nenhum dado encontrado'));
        }
        final docMatriculas = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docMatriculas.length,
          itemBuilder: (context, index) {
            final data = docMatriculas[index].data();
            final dadosAluno = data['dadosAluno'] ?? {};
            final alunoId = dadosAluno['id'];
            final dadosAcademicos = data['dadosAcademicos'] ?? {};

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Conteúdo
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nome
                          Text(
                            dadosAluno['nome'] ?? '---',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 6),

                          // Matrícula
                          Text(
                            'Matrícula: ${dadosAcademicos['numeroMatricula'] ?? '---'}',
                            style: const TextStyle(fontSize: 13),
                          ),

                          const SizedBox(height: 2),

                          // Turma
                          Text(
                            'Turma: ${dadosAcademicos['turma'] ?? '---'}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),

                    // Menu de ações
                    ActionMenuButton(
                      id: alunoId,
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
                              content: 'Essa ação é irreversível.',
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
              ),
            );
          },
        );
      },
    );
  }
}
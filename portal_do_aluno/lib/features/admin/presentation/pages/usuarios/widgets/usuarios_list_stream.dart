import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/utils/cpf_formatters.dart';
import 'package:portal_do_aluno/features/auth/data/datasouces/cadastro_service.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/shared/helpers/app_confirmation_dialog.dart';
import 'package:portal_do_aluno/shared/widgets/action_menu_button.dart';

class UsuariosListStream extends StatelessWidget {
  final Stream<QuerySnapshot> minhaListaFiltrada;
  final CadastroService cadastroService;

  const UsuariosListStream({
    super.key,
    required this.cadastroService,
    required this.minhaListaFiltrada,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: minhaListaFiltrada,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Nenhum usuário encontrado"));
          }

          final usuarios = snapshot.data!.docs;

          return ListView.separated(
            itemCount: usuarios.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final data = usuarios[index].data() as Map<String, dynamic>;

              final cpf = data['cpf'] != null
                  ? formatarCpf(data['cpf'].toString())
                  : '---';

              final tipo = data['type'] ?? "---";
              final userId = data['id'] ?? "";

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.grey.shade200,
                      child: const Icon(Icons.person, color: Colors.grey),
                    ),
                    title: Text(
                      data['name'] ?? 'Sem nome',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("CPF: $cpf"),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _tipoCor(tipo).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tipo.toUpperCase(),
                            style: TextStyle(
                              color: _tipoCor(tipo),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: ActionMenuButton(
                      id: userId,
                      items: [
                        MenuItemConfig(
                          value: 'Resetar',
                          label: 'Mudar senha',
                          onSelected: (id, context, extra) {
                            NavigatorService.navigateTo(
                              RouteNames.changePassword,
                              arguments: {'usuarioId': id!},
                            );
                          },
                        ),
                        MenuItemConfig(
                          value: 'excluir',
                          label: 'Excluir',
                          onSelected: (id, context, extra) async {
                            if (id == null) {
                              return;
                            }

                            final excluir = await showAppConfirmationDialog(
                              context: context,
                              title: 'Deseja excluir esse usuário?',
                              content: 'Essa ação é irreversível',
                            );

                            if (excluir == true) {
                              cadastroService.deletarUsuario(id);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // cores para o tipo de usuário
  Color _tipoCor(String tipo) {
    switch (tipo) {
      case 'student':
        return Colors.blueAccent;
      case 'teacher':
        return Colors.green;
      case 'admin':
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }
}

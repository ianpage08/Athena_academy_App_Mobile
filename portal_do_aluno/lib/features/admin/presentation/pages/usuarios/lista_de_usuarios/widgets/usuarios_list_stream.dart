import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/utils/cpf_formatters.dart';
import 'package:portal_do_aluno/features/auth/data/datasources/cadastro_service.dart';
import 'package:portal_do_aluno/navigation/navigation_service.dart';
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
          // 👉 LOADING STATE: Estética minimalista adaptada ao sistema
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          // 👉 EMPTY STATE: Feedback visual limpo para ausência de dados
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          final usuarios = snapshot.data!.docs;

          return ListView.builder(
            // Padding extra no fundo para não "colar" no final da tela
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            itemCount: usuarios.length,
            itemBuilder: (context, index) {
              final data = usuarios[index].data() as Map<String, dynamic>;

              // Extração de dados com fallback para segurança
              final String nome = data['name'] ?? 'Sem nome';
              final String tipo = data['type'] ?? '---';
              final String cpf = data['cpf'] != null
                  ? formatarCpf(data['cpf'].toString())
                  : '---';

              return _UserListItemCard(
                nome: nome,
                tipo: tipo,
                cpf: cpf,
                userId: data['id'] ?? "",
                corTipo: _tipoCor(tipo),
                onDelete: () => _handleDelete(context, data['id']),
                onEdit: () => _handleEdit(data['id']),
              );
            },
          );
        },
      ),
    );
  }

  // 👉 COMPONENTE INTERNO: Isolamento de responsabilidade visual
  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.person_search_outlined,
          size: 64,
          color: Colors.grey.withValues(alpha: 0.2),
        ),
        const SizedBox(height: 16),
        const Text(
          "Nenhum usuário encontrado",
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // 👉 LOGICA DE AÇÃO: Centralizada para evitar poluição no build
  void _handleEdit(String? id) {
    if (id == null) return;
    NavigatorService.navigateTo(
      '${RouteNames.changePassword}?usuarioId=$id',
    );
  }

  Future<void> _handleDelete(BuildContext context, String? id) async {
    if (id == null) return;
    final excluir = await showAppConfirmationDialog(
      context: context,
      title: 'Remover Usuário?',
      content:
          'Esta ação é irreversível e removerá todos os acessos vinculados.',
    );
    if (excluir == true) cadastroService.deletarUsuario(id);
  }

  // 👉 CORES: Paleta moderna com tons mais vibrantes e profissionais
  Color _tipoCor(String tipo) {
    switch (tipo) {
      case 'student':
        return const Color(0xFF2196F3); // Blue Tech
      case 'teacher':
        return const Color(0xFF00C853); // Emerald Professional
      case 'admin':
        return const Color(0xFF6200EA); // Deep Tech Purple
      default:
        return Colors.blueGrey;
    }
  }
}

// 👉 WIDGET DE ITEM: Onde a mágica visual acontece
class _UserListItemCard extends StatelessWidget {
  final String nome, tipo, cpf, userId;
  final Color corTipo;
  final VoidCallback onDelete, onEdit;

  const _UserListItemCard({
    required this.nome,
    required this.tipo,
    required this.cpf,
    required this.userId,
    required this.corTipo,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24), // Bordas orgânicas
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            // Leading futurista: Avatar com iniciais e gradiente sutil
            leading: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    corTipo.withValues(alpha: 0.2),
                    corTipo.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  nome.isNotEmpty ? nome[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: corTipo,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            title: Text(
              nome,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: -0.3,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  "CPF: $cpf",
                  style: TextStyle(color: theme.hintColor, fontSize: 13),
                ),
                const SizedBox(height: 10),
                // Badge Estilo Pílula (Pill Shape)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: corTipo.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    tipo.toUpperCase(),
                    style: TextStyle(
                      color: corTipo,
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                      letterSpacing: 1.1,
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
                  onSelected: (_, __, ___) => onEdit(),
                ),
                MenuItemConfig(
                  value: 'excluir',
                  label: 'Excluir',
                  onSelected: (_, __, ___) => onDelete(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

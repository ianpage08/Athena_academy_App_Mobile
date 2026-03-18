import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/chip_filtro.dart';

// Barra de filtros para listar conteúdos/relatórios por turma.
// Permite:
// - selecionar "Todos"
// - selecionar uma turma específica via dropdown
class FilterBar extends StatelessWidget {
  // ID da turma atualmente selecionada no filtro.
  // Quando for null, significa que o filtro está em "Todos".
  final String? filtroTurmaId;

  // Callback acionado ao selecionar o filtro "Todos".
  final VoidCallback onSelectAll;

  // Callback acionado ao selecionar uma turma específica.
  final ValueChanged<String?> onSelectTurma;

  const FilterBar({
    super.key,
    required this.filtroTurmaId,
    required this.onSelectAll,
    required this.onSelectTurma,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      // Espaçamento externo da barra em relação à tela/lista
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),

      // Espaçamento interno dos elementos da barra
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        // Cor do container baseada no tema atual
        color: theme.cardColor,

        // Bordas arredondadas para visual mais moderno
        borderRadius: BorderRadius.circular(16),

        // Borda sutil para destacar a área do filtro
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.6)),

        // Sombra leve para dar profundidade
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Row(
        children: [
          // Chip fixo para limpar o filtro e exibir todos os itens
          ChipFiltro(
            title: 'Todos',
            value: null,
            filtroSelected: filtroTurmaId,
            onSelected: (_) => onSelectAll(),
          ),

          const SizedBox(width: 12),

          // Dropdown ocupa o restante da linha
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              // Escuta em tempo real a coleção de turmas no Firestore
              stream: FirebaseFirestore.instance
                  .collection('turmas')
                  .snapshots(),
              builder: (context, snapshot) {
                // Estado de carregamento inicial
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 48,
                    child: Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }

                // Lista de documentos retornados
                final docs = snapshot.data?.docs ?? [];

                // Caso não existam turmas cadastradas
                if (docs.isEmpty) {
                  return const Text('Nenhuma turma encontrada');
                }

                return DropdownButtonFormField<String>(
                  // Valor inicial atualmente selecionado
                  initialValue: filtroTurmaId,

                  // Faz o dropdown ocupar toda a largura disponível
                  isExpanded: true,

                  decoration: InputDecoration(
                    labelText: 'Turma',
                    border: const OutlineInputBorder(),

                    // Espaçamento interno do campo
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),

                    // Cor de fundo baseada no card atual
                    fillColor: Theme.of(context).cardColor,

                    // Reduz a densidade vertical do campo
                    isDense: true,
                  ),

                  // Monta os itens do dropdown a partir das turmas vindas do Firestore
                  items: docs.map((doc) {
                    final data = doc.data();

                    // Usa o campo "serie" como rótulo da turma
                    final label = (data['serie'] ?? 'Turma').toString();

                    return DropdownMenuItem<String>(
                      // ID do documento é o valor real do item selecionado
                      value: doc.id,
                      child: Text(label, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),

                  // Dispara callback quando o usuário escolhe uma turma
                  onChanged: (value) {
                    onSelectTurma(value);
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/chip_filtro.dart';

class FilterBar extends StatelessWidget {
  final String? filtroTurmaId;
  final VoidCallback onSelectAll;
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
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          ChipFiltro(
            title: 'Todos',
            value: null,
            filtroSelected: filtroTurmaId,
            onSelected: (_) => onSelectAll(),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('turmas')
                  .snapshots(),
              builder: (context, snapshot) {
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
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Text('Nenhuma turma encontrada');
                }

                return DropdownButtonFormField<String>(
                  initialValue: filtroTurmaId, //  não é initialValue
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Turma',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    fillColor: Theme.of(context).cardColor,
                    isDense: true,
                  ),
                  items: docs.map((doc) {
                    final data = doc.data();
                    final label = (data['serie'] ?? 'Turma').toString();

                    return DropdownMenuItem<String>(
                      value: doc.id, //  essencial
                      child: Text(label, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: (value) => {onSelectTurma(value)},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

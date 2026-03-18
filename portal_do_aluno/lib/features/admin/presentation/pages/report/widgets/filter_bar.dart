import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/chip_filtro.dart';

/// Barra de filtros para listar conteúdos/relatórios por turma.
/// Permite:
/// - selecionar "Todos"
/// - selecionar uma turma específica via dropdown
class FilterBar extends StatelessWidget {
  /// ID da turma atualmente selecionada no filtro.
  /// Quando for null, significa que o filtro está em "Todos".
  final String? filtroTurmaId;

  /// Callback acionado ao selecionar o filtro "Todos".
  final VoidCallback onSelectAll;

  /// Callback acionado ao selecionar uma turma específica.
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.55)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Cabeçalho da barra
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.filter_alt_outlined,
                  color: theme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Filtrar relatórios',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// Linha principal dos filtros
          Row(
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
                    if (snapshot.hasError) {
                      return Container(
                        height: 54,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: 0.14),
                          ),
                        ),
                        child: Text(
                          'Erro ao carregar turmas',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.dividerColor.withValues(alpha: 0.45),
                          ),
                        ),
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2.2),
                          ),
                        ),
                      );
                    }

                    final docs = snapshot.data?.docs ?? [];

                    if (docs.isEmpty) {
                      return Container(
                        height: 54,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.dividerColor.withValues(alpha: 0.45),
                          ),
                        ),
                        child: Text(
                          'Nenhuma turma encontrada',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }

                    return DropdownButtonFormField<String>(
                      initialValue: filtroTurmaId,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      decoration: InputDecoration(
                        labelText: 'Turma',
                        prefixIcon: Icon(
                          Icons.school_outlined,
                          color: Colors.grey.shade700,
                        ),
                        filled: true,
                        fillColor: Colors.grey.withValues(alpha: 0.06),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.dividerColor.withValues(alpha: 0.55),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.dividerColor.withValues(alpha: 0.55),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.primaryColor.withValues(alpha: 0.65),
                            width: 1.4,
                          ),
                        ),
                        floatingLabelStyle: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                        isDense: true,
                      ),
                      items: docs.map((doc) {
                        final data = doc.data();
                        final label = (data['serie'] ?? 'Turma').toString();

                        return DropdownMenuItem<String>(
                          value: doc.id,
                          child: Text(
                            label,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                      onChanged: onSelectTurma,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

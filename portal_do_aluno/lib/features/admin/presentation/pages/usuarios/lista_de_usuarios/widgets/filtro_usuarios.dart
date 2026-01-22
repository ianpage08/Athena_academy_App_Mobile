import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/chip_filtro.dart';

class FiltroUsuarios extends StatelessWidget {
  final String? tipoSelecionado;
  final ValueChanged<String?> onSelected;

  const FiltroUsuarios({
    super.key,
    this.tipoSelecionado,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),

      child: Wrap(
        spacing: 4,
        children: [
          ChipFiltro(
            title: 'Todos',
            value: null,
            filtroSelected: tipoSelecionado,
            onSelected: onSelected,
          ),
          ChipFiltro(
            title: 'Alunos',
            value: 'student',
            filtroSelected: tipoSelecionado,
            onSelected: onSelected,
          ),
          ChipFiltro(
            title: 'Professores',
            value: 'teacher',
            filtroSelected: tipoSelecionado,
            onSelected: onSelected,
          ),
          ChipFiltro(
            title: 'Admin',
            value: 'admin',
            filtroSelected: tipoSelecionado,
            onSelected: onSelected,
          ),
        ],
      ),
    );
  }
}

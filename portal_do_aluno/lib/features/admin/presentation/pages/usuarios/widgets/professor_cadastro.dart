import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/usuarios/widgets/build_input.dart';

class ProfessorCadastro extends StatelessWidget {
  final TextEditingController mapController1;

  final TextEditingController mapController2;
  final bool enabled;
  const ProfessorCadastro({
    super.key,
    this.enabled = true,
    required this.mapController1,
    required this.mapController2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BuildInput(
          controller: mapController1,
          label: 'Nome',
          hint: 'Leila Miranda Maciel',
          icon: Icons.person_outline,
          enabled: enabled,
          validator: (v) => v == null || v.isEmpty ? 'Digite o nome' : null,
        ),

        const SizedBox(height: 12),
        BuildInput(
          controller: mapController2,
          label: 'CPF',
          hint: '853.654.895-59',
          icon: Icons.badge_outlined,
          enabled: enabled,
        ),

        const SizedBox(height: 12),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/core/utils/formatters.dart';

import 'package:portal_do_aluno/features/admin/presentation/pages/usuarios/widgets/build_input.dart';

class AdminCadastro extends StatelessWidget {
  final TextEditingController mapController1;
  final TextEditingController mapController2;
  final bool enabled;

  const AdminCadastro({
    super.key,
    required this.mapController1,
    required this.mapController2,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildInput(
          controller: mapController1,
          label: 'Nome',
          hint: 'Leila Miranda Maciel',
          icon: Icons.person_outline,
          enabled: enabled,
          validator: (v) => v == null || v.isEmpty ? 'Digite o nome' : null,
        ),

        const SizedBox(height: 16),

        BuildInput(
          controller: mapController2,
          label: 'CPF',
          hint: '853.654.895-59',
          icon: Icons.badge_outlined,
          enabled: enabled,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CpfInputFormatter(),
          ],
          validator: (v) => v == null || v.isEmpty ? 'Digite o CPF' : null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

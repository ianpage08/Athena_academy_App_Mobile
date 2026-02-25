import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/core/utils/formatters.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/usuarios/adicao_de_usuarios/widgets/form_validators.dart';

import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';

class ProfessorCadastro extends StatelessWidget {
  final TextEditingController mapController1; // nome
  final TextEditingController mapController2; // cpf
  final bool enabled;

  const ProfessorCadastro({
    super.key,
    required this.mapController1,
    required this.mapController2,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return const SizedBox.shrink();

    return Column(
      children: [
        CustomTextFormField(
          label: 'Nome do Professor',
          hintText: 'João da Silva',
          controller: mapController1,
          prefixIcon: Icons.person,
          validator: FormValidators.nome,
        ),
        const SizedBox(height: 12),
        CustomTextFormField(
          label: 'CPF do Professor',
          hintText: '888.888.888-88',
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
            CpfInputFormatter(),
          ],
          controller: mapController2,
          prefixIcon: Icons.badge,
          validator: FormValidators.cpfObrigatorio,
        ),
      ],
    );
  }
}

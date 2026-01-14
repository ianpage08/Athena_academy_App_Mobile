import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/core/utils/formatters.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/usuarios/adi%C3%A7%C3%A3o%20de%20usuarios/widgets/form_validators.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';

class AdminCadastro extends StatelessWidget {
  final TextEditingController mapController1; // nome
  final TextEditingController mapController2; // cpf
  final bool enabled;

  const AdminCadastro({
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
          label: 'Nome do Administrador',
          controller: mapController1,
          prefixIcon: Icons.admin_panel_settings,
          validator: FormValidators.nome,
        ),
        const SizedBox(height: 12),
        CustomTextFormField(
          label: 'CPF do Administrador',
          controller: mapController2,
          hintText: '888.888.888-88',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
            CpfInputFormatter(),
          ],
          prefixIcon: Icons.badge_outlined,
          validator: FormValidators.cpfObrigatorio,
        ),
      ],
    );
  }
}

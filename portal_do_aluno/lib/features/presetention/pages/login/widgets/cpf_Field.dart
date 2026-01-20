import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/core/utils/formatters.dart';
import 'package:portal_do_aluno/features/presetention/pages/login/controller/login_controller.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';

class _CpfField extends StatelessWidget {
  final LoginController controller;
  const _CpfField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.isLoading,
      builder: (_, loading, __) {
        return CustomTextFormField(
          controller: controller.cpfController,
          label: 'CPF',
          hintText: '000.000.000-00',
          prefixIcon: Icons.person,
          keyboardType: TextInputType.number,
          enable: !loading,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CpfInputFormatter(),
          ],
          validator: (value) => (value == null || value.isEmpty)
              ? 'Digite o CPF'
              : null,
        );
      },
    );
  }
}

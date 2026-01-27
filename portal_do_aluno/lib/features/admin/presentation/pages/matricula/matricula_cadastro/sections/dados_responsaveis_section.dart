import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/core/utils/formatters.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula_cadastro/widgets/card_section.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';

class DadosResponsaveisSection extends StatelessWidget {
  final Map<String, TextEditingController> mapController;

  const DadosResponsaveisSection({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return CardSection(
      title: 'Responsável Financeiro',
      icon: CupertinoIcons.group_solid,
      children: [
        CustomTextFormField(
          label: 'Nome Do Responsável',
          controller: mapController['nomeResponsavel']!,
          prefixIcon: CupertinoIcons.person_crop_circle_fill_badge_checkmark,
        ),
        CustomTextFormField(
          label: 'CPF',
          controller: mapController['cpfDoResponsavel']!,
          prefixIcon: CupertinoIcons.number_circle,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
            CpfInputFormatter(),
          ],
        ),
        CustomTextFormField(
          label: 'Telefone',
          controller: mapController['telefoneResponsavel']!,
          prefixIcon: CupertinoIcons.phone_fill,
          maxLength: 11,
        ),
      ],
    );
  }
}

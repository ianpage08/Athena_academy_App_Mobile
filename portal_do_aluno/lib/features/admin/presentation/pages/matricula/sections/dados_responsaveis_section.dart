import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/core/utils/formatters.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/widgets/card_section.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';

class DadosResponsaveisSection extends StatelessWidget {
  final Map<String, TextEditingController> mapController;

  const DadosResponsaveisSection({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return CardSection(title: 'Responsáveis', icon: CupertinoIcons.group_solid, children: [
      CustomTextFormField(
        label: 'Nome da Mãe',
        controller: mapController['nomeMae']!,
        prefixIcon: CupertinoIcons.person_crop_circle_fill_badge_checkmark,
      ),
      CustomTextFormField(
        label: 'CPF da Mãe',
        controller: mapController['cpfMae']!,
        prefixIcon: CupertinoIcons.number_circle,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11),
          CpfInputFormatter(),
        ],
      ),
      CustomTextFormField(
        label: 'Telefone da Mãe',
        controller: mapController['telefoneMae']!,
        prefixIcon: CupertinoIcons.phone_fill,
        maxLength: 11,
      ),
      CustomTextFormField(
        label: 'Nome do Pai',
        controller: mapController['nomePai']!,
        prefixIcon: CupertinoIcons.person_crop_circle_fill,
      ),
      CustomTextFormField(
        label: 'CPF do Pai',
        controller: mapController['cpfPai']!,
        prefixIcon: CupertinoIcons.number_circle_fill,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11),
          CpfInputFormatter(),
        ],
      ),
      CustomTextFormField(
        label: 'Telefone do Pai',
        controller: mapController['telefonePai']!,
        prefixIcon: CupertinoIcons.phone,
        maxLength: 11,
      ),
    ]);
  }
}
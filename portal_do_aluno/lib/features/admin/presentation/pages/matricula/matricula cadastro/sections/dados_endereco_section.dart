import 'package:flutter/cupertino.dart';

import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula%20cadastro/widgets/card_section.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';

class DadosEnderecoSection extends StatelessWidget {
  final Map<String, TextEditingController> mapController;

  const DadosEnderecoSection({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return CardSection(
      title: 'Endereço',
      icon: CupertinoIcons.map,
      children: [
        CustomTextFormField(
          label: 'CEP',
          controller: mapController['cep']!,
          prefixIcon: CupertinoIcons.map_pin_ellipse,
        ),
        CustomTextFormField(
          label: 'Rua',
          controller: mapController['rua']!,
          prefixIcon: CupertinoIcons.location,
        ),
        CustomTextFormField(
          label: 'Número',
          controller: mapController['numero']!,
          prefixIcon: CupertinoIcons.number_square,
        ),
        CustomTextFormField(
          label: 'Bairro',
          controller: mapController['bairro']!,
          prefixIcon: CupertinoIcons.map_pin,
        ),
        CustomTextFormField(
          label: 'Cidade',
          controller: mapController['cidade']!,
          prefixIcon: CupertinoIcons.building_2_fill,
        ),
        CustomTextFormField(
          label: 'Estado',
          controller: mapController['estado']!,
          prefixIcon: CupertinoIcons.flag,
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/core/utils/formatter/cep_formatter.dart';

import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula_cadastro/widgets/card_section.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';

class DadosEnderecoSection extends StatelessWidget {
  final Map<String, TextEditingController> mapController;

  const DadosEnderecoSection({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return CardSection(
      title: 'Localização e Endereço',
      icon: CupertinoIcons.map_fill,
      children: [
        // CEP
        CustomTextFormField(
          label: 'CEP',
          controller: mapController['cep']!,
          prefixIcon: CupertinoIcons.location_solid,
          keyboardType: TextInputType.number,
          hintText: '00000-000',
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(8),
            CepInputFormatter(),
          ],
        ),

        // Rua e Número (Grid 70/30)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: CustomTextFormField(
                label: 'Logradouro (Rua/Av.)',
                controller: mapController['rua']!,
                prefixIcon: CupertinoIcons.building_2_fill,
                
                textCapitalization: TextCapitalization.words,
                hintText: 'Ex: Avenida Paulista...',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: CustomTextFormField(
                label: 'Número',
                controller: mapController['numero']!,
                prefixIcon: CupertinoIcons.number_square_fill,
                keyboardType: TextInputType.number,
                
                hintText: 'Ex: 123, S/N',
              ),
            ),
          ],
        ),

        // Bairro
        CustomTextFormField(
          label: 'Bairro',
          controller: mapController['bairro']!,
          prefixIcon: CupertinoIcons.map_pin_ellipse,
          
          textCapitalization: TextCapitalization.words,
          hintText: 'Ex: Centro, Bela Vista...',
        ),

        // Cidade e UF (Grid 70/30)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: CustomTextFormField(
                label: 'Cidade',
                controller: mapController['cidade']!,
                prefixIcon: CupertinoIcons.building_2_fill,
                
                textCapitalization: TextCapitalization.words,
                hintText: 'Ex: São Paulo...',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: CustomTextFormField(
                label: 'UF',
                controller: mapController['estado']!,
                prefixIcon: CupertinoIcons.flag_fill,
                hintText: 'Ex: SP',
                
                textCapitalization: TextCapitalization.characters,
                maxLength: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

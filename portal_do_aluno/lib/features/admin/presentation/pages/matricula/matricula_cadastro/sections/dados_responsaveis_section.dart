import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/core/utils/formatters.dart';

import 'package:portal_do_aluno/core/utils/formatter/phone_formatter.dart'; 
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula_cadastro/widgets/card_section.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';

class DadosResponsaveisSection extends StatelessWidget {
  final Map<String, TextEditingController> mapController;

  const DadosResponsaveisSection({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return CardSection(
      title: 'Responsável Financeiro',
      icon: CupertinoIcons.person_2_square_stack_fill, 
      children: [
        
        
        CustomTextFormField(
          label: 'Nome do Responsável',
          controller: mapController['nomeResponsavel']!,
          prefixIcon: CupertinoIcons.person_crop_circle_fill_badge_checkmark,
          textCapitalization: TextCapitalization.words, // UX: Primeira letra maiúscula
          hintText: 'Ex: Carlos Eduardo Silva',
        ),
        
        
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: CustomTextFormField(
                label: 'CPF',
                controller: mapController['cpfDoResponsavel']!,
                prefixIcon: CupertinoIcons.creditcard_fill, // Melhor semântica visual para documento financeiro
                keyboardType: TextInputType.number, // UX: Sobe o teclado numérico
                hintText: '000.000.000-00',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                  CpfInputFormatter(),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 5,
              child: CustomTextFormField(
                label: 'Telefone',
                controller: mapController['telefoneResponsavel']!,
                prefixIcon: CupertinoIcons.phone_circle_fill,
                keyboardType: TextInputType.phone, // UX: Teclado otimizado para telefone
                hintText: '(00) 00000-0000',
                
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                  PhoneInputFormatter(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
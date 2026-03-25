import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // 👉 Adicionado para Theme e Colors
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/core/utils/formatter/phone_formatter.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula_cadastro/widgets/card_section.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';

class DadosMedicosSection extends StatelessWidget {
  final Map<String, TextEditingController> mapController;

  const DadosMedicosSection({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CardSection(
      title: 'Informações Médicas',
      icon: CupertinoIcons
          .heart_circle_fill, 
      children: [
        
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                label: 'Alergias',
                controller: mapController['alergias']!,
                prefixIcon: CupertinoIcons
                    .ant_fill, // Ícone mais específico para alergia
                obrigatorio: false,
                hintText: 'Ex: Pólen, Amendoim...',
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextFormField(
                label: 'Medicações',
                controller: mapController['medicamentos']!,
                prefixIcon: CupertinoIcons.capsule_fill,
                obrigatorio: false,
                hintText: 'Uso contínuo?',
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ],
        ),

        
        CustomTextFormField(
          label: 'Observações Médicas Adicionais',
          controller: mapController['observacoes']!,
          prefixIcon: CupertinoIcons.doc_text_fill,
          obrigatorio: false,
          minLines: 3, 
          maxLines: 5,
          hintText: 'Histórico médico relevante, restrições físicas, etc.',
          textCapitalization: TextCapitalization.sentences,
        ),

        const SizedBox(height: 8),

        
        _buildEmergencyContactField(theme),
      ],
    );
  }

  // Widget auxiliar para isolar a estilização do campo de emergência
  Widget _buildEmergencyContactField(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        // Leve brilho de alerta discreto no fundo para indicar importância
        color: theme.colorScheme.error.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
      ),
      child: CustomTextFormField(
        controller: mapController['telefoneEmergencia']!,
        label: 'Telefone de Emergência',
        prefixIcon: CupertinoIcons.phone_circle_fill,
        obrigatorio: false,
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11),
          PhoneInputFormatter(),
        ],
        hintText: '(00) 00000-0000',
        // Estilização levemente diferenciada para o ícone de emergência
        fillColor: theme.colorScheme.error.withValues(alpha: 0.05),
      ),
    );
  }
}

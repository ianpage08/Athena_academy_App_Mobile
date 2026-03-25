import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/core/utils/formatters.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula_cadastro/widgets/card_section.dart';
import 'package:portal_do_aluno/shared/widgets/custom_date_picker_field.dart';
import 'package:portal_do_aluno/shared/widgets/custom_dropdown_field.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';

class DadosAlunoSection extends StatelessWidget {
  final Map<String, TextEditingController> mapController;
  final ValueNotifier<String?> sexoSelecionado;
  final ValueNotifier<DateTime?> dataSelecionada;

  const DadosAlunoSection({
    super.key,
    required this.mapController,
    required this.dataSelecionada,
    required this.sexoSelecionado,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CardSection(
      title: 'Dados do Aluno',
      icon: CupertinoIcons.person_crop_circle_fill_badge_plus,
      children: [
        
        _buildSectionSubtitle(theme, 'Informações Identificadoras'),

        CustomTextFormField(
          label: 'Nome Completo do Aluno',
          controller: mapController['nomeAluno']!,
          prefixIcon: CupertinoIcons.person_alt,
          
          textCapitalization: TextCapitalization.words, 
          hintText: 'Ex: João Carlos da Silva',
        ),

        CustomTextFormField(
          label: 'CPF',
          controller: mapController['cpfAluno']!,
          prefixIcon: CupertinoIcons.number,
          keyboardType: TextInputType.number,
          hintText: '000.000.000-00', 
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
            CpfInputFormatter(),
          ],
        ),

        const SizedBox(height: 12),
        _buildSectionSubtitle(theme, 'Origem e Filiação'),

        CustomTextFormField(
          label: 'Naturalidade',
          controller: mapController['naturalidade']!,
          prefixIcon: CupertinoIcons.map_pin_ellipse,
          textCapitalization: TextCapitalization.words, 
          hintText: 'Ex: São Paulo - SP',
        ),

        _buildFiliationFields(theme),

        const SizedBox(height: 12),
        _buildSectionSubtitle(theme, 'Perfil Biométrico'),

        Row(
          children: [
            Expanded(
              child: ValueListenableBuilder<String?>(
                valueListenable: sexoSelecionado,
                builder: (context, sexo, child) => CustomDropdownField(
                  itens: const ['Masculino', 'Feminino'],
                  selecionado: sexo,
                  titulo: 'Sexo',
                  icon: CupertinoIcons.person_2_fill,
                  onSelected: (valor) => sexoSelecionado.value = valor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ValueListenableBuilder<DateTime?>(
                valueListenable: dataSelecionada,
                builder: (context, data, child) => CustomDatePickerField(
                  onDate: (novaData) => dataSelecionada.value = novaData,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- WIDGETS DE SUPORTE ---

  Widget _buildSectionSubtitle(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4, top: 8), // Pequeno ajuste no top
      child: Text(
        text.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary.withValues(alpha: 0.7),
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildFiliationFields(ThemeData theme) {
    return Column(
      children: [
        CustomTextFormField(
          controller: mapController['nomeMae']!,
          label: 'Nome da Mãe',
          prefixIcon: CupertinoIcons.person_2,
          textCapitalization: TextCapitalization.words, 
          hintText: 'Ex: Maria de Fátima Silva',
        ),
        CustomTextFormField(
          controller: mapController['nomePai']!,
          label: 'Nome do Pai',
          prefixIcon: CupertinoIcons.person_2,
          textCapitalization: TextCapitalization.words, 
          hintText: 'Ex: Roberto Carlos da Silva',
        ),
      ],
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula_cadastro/widgets/card_section.dart';
import 'package:portal_do_aluno/shared/widgets/custom_dropdown_field.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';
import 'package:portal_do_aluno/shared/widgets/select_class_button.dart';

class DadosAcademicosSection extends StatelessWidget {
  final Map<String, TextEditingController> mapController;
  final ValueNotifier<String?> turnoSelecionado;
  final ValueNotifier<String?> turmaName;
  final ValueNotifier<String?> turmaId;





  const DadosAcademicosSection({super.key, required this.mapController, required this.turnoSelecionado, required this.turmaName, required this.turmaId});

  @override
  Widget build(BuildContext context) {
    return CardSection(title: 'Dados Acadêmicos', icon: CupertinoIcons.book, children: [
      CustomTextFormField(
        label: 'Número da Matrícula',
        controller: mapController['numeroMatricula']!,
        prefixIcon: CupertinoIcons.doc_text,
      ),
      CustomTextFormField(
        label: 'Ano Letivo',
        controller: mapController['anoLetivo']!,
        prefixIcon: CupertinoIcons.calendar_today,
      ),
      ValueListenableBuilder<String?>(
        valueListenable: turnoSelecionado,
        builder: (context, value, child) {
          return CustomDropdownField(
            itens: const ['Matutino', 'Vespertino'],
            selecionado: value,
            titulo: 'Selecione o turno',
            icon: CupertinoIcons.time_solid,
            onSelected: (valor) =>
                turnoSelecionado.value = valor,
          );
        },
      ),
      SelectClassButton(
        turmaSelecionada: turmaName,
        onTurmaSelecionada: (id, turmaNome) {
          turmaName.value = turmaNome;
          turmaId.value = id;
          debugPrint('Turma selecionada: $turmaNome (ID: $id)');
        },
      ),
    ]);
  }
}


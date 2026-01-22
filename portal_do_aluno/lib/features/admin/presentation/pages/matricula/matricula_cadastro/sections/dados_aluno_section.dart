import 'package:flutter/cupertino.dart';
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
  

  const DadosAlunoSection({super.key, required this.mapController, required this.dataSelecionada, required this.sexoSelecionado});

  @override
  Widget build(BuildContext context) {
    return CardSection(title: 'Dados do Aluno', icon: CupertinoIcons.person_2_fill, children: [
      CustomTextFormField(
        label: 'Nome Completo do Aluno',
        controller: mapController['nomeAluno']!,
        prefixIcon: CupertinoIcons.person_fill,
      ),
      CustomTextFormField(
        label: 'CPF',
        controller: mapController['cpfAluno']!,
        prefixIcon: CupertinoIcons.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11),
          CpfInputFormatter(),
        ],
      ),
      CustomTextFormField(
        label: 'Naturalidade',
        controller: mapController['naturalidade']!,
        prefixIcon: CupertinoIcons.location_solid,
      ),
      ValueListenableBuilder<String?>(
        valueListenable: sexoSelecionado,
        builder: (context, sexo, child) => CustomDropdownField(
          itens: const ['Masculino', 'Feminino'],
          selecionado: sexo,
          titulo: 'Selecione o sexo do aluno(a)',
          icon: CupertinoIcons.person_2_fill,
          onSelected: (valor) =>
              sexoSelecionado.value = valor,
        ),
      ),
      ValueListenableBuilder<DateTime?>(
        valueListenable: dataSelecionada,
        builder: (context, dataEscolhida, child) {
          return CustomDatePickerField(
            onDate: (data) => dataSelecionada.value = data,
          );
        },
      ),
    ],);
  }
}
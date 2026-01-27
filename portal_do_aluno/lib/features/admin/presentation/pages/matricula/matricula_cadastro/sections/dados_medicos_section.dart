import 'package:flutter/cupertino.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula_cadastro/widgets/card_section.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';

class DadosMedicosSection extends StatelessWidget {
  final Map<String, TextEditingController> mapController;

  const DadosMedicosSection({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return CardSection(title: 'Informações Médicas', icon: CupertinoIcons.heart_fill, children: [
      CustomTextFormField(
        label: 'Alergias',
        controller: mapController['alergias']!,
        prefixIcon: CupertinoIcons.bandage_fill,
        obrigatorio: false,
      ),
      CustomTextFormField(
        label: 'Medicações',
        controller: mapController['medicamentos']!,
        prefixIcon: CupertinoIcons.capsule_fill,
        obrigatorio: false,
      ),
      CustomTextFormField(
        label: 'Observações',
        controller: mapController['observacoes']!,
        prefixIcon: CupertinoIcons.text_bubble_fill,
        obrigatorio: false,
      ),
      CustomTextFormField(controller: mapController['telefoneEmergencia']!,
      label: 'Telefone de emergência ',
      
      prefixIcon: CupertinoIcons.phone_fill,
      obrigatorio: false,
      )
    ]);
  }
}
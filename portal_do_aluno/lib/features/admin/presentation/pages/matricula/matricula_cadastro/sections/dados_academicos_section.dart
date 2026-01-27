import 'package:flutter/cupertino.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula_cadastro/widgets/card_section.dart';
import 'package:portal_do_aluno/shared/widgets/select_class_button.dart';

class DadosAcademicosSection extends StatelessWidget {
  final Map<String, TextEditingController> mapController;
  
  final ValueNotifier<String?> turmaName;
  final ValueNotifier<String?> turmaId;





  const DadosAcademicosSection({super.key, required this.mapController, required this.turmaName, required this.turmaId});

  @override
  Widget build(BuildContext context) {
    return CardSection(title: 'Dados Acadêmicos', icon: CupertinoIcons.book, children: [
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


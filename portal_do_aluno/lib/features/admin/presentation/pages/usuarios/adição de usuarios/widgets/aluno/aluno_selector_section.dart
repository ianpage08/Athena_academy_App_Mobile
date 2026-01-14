import 'package:flutter/widgets.dart';
import 'package:portal_do_aluno/shared/widgets/select_class_button.dart';
import 'package:portal_do_aluno/shared/widgets/select_student_button.dart';

class AlunoSelectorSection extends StatelessWidget {
  final ValueNotifier<String?> turmaSelecionada;
  final ValueNotifier<String?> alunoSelecionado;
  final Function(String turmaId) onTurma;
  final Function(String id, String nome, String cpf) onAluno;

  const AlunoSelectorSection({
    super.key,
    required this.turmaSelecionada,
    required this.alunoSelecionado,
    required this.onTurma,
    required this.onAluno,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectClassButton(
          turmaSelecionada: turmaSelecionada,
          onTurmaSelecionada: (id, nome) => onTurma(id),
        ),
        const SizedBox(height: 12),
        if (turmaSelecionada.value != null)
          SelectStudentButton(
            alunoSelecionado: alunoSelecionado,
            turmaId: turmaSelecionada.value!,
            onAlunoSelecionado: onAluno,
          ),
      ],
    );
  }
}

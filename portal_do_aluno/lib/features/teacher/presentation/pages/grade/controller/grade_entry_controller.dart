import 'package:flutter/widgets.dart';
import 'package:portal_do_aluno/core/submit%20state/submit_states.dart';
import 'package:portal_do_aluno/features/admin/helper/boletim_helper.dart';

class GradeEntryController {
  final BoletimHelper boletimHelper = BoletimHelper();
  final TextEditingController notaController = TextEditingController();
  final state = ValueNotifier<SubmitState>(Initial());

  final ValueNotifier<String?> turmaSelecionada = ValueNotifier(null);
  final ValueNotifier<String?> alunoSelecionado = ValueNotifier(null);

  final Map<String, String?> selected = {
    'turmaId': null,
    'alunoId': null,
    'disciplinaId': null,
    'disciplinaNome': null,
    'unidade': null,
    'tipoAvaliacao': null,
  };

  final unidades = ['Unidade 1', 'Unidade 2', 'Unidade 3', 'Unidade 4'];
  final avaliacoes = ['Teste', 'Prova', 'Trabalho', 'Nota Extra'];

  void limpar() {
    selected.updateAll((key, value) => null);
    alunoSelecionado.value = null;
    notaController.clear();
  }

  Future<SubmitState> salvar() async {
    if (notaController.text.isEmpty) {
      return state.value = Error('Preencha a nota');
    }
    state.value = Loading();
    

    try {
      await boletimHelper.salvarNota(
        alunoId: selected['alunoId']!,
        turmaId: selected['turmaId']!,
        disciplinaId: selected['disciplinaId']!,
        disciplinaNome: selected['disciplinaNome']!,
        unidade: selected['unidade']!,
        tipoDeNota: selected['tipoAvaliacao']!,
        nota: double.parse(notaController.text.replaceAll(',', '.')),
      );
      state.value = Success();
      return state.value;
    } catch (e) {
      return state.value = Error('Erro ao salvar nota');
    }
    
  }

  void dispose() {
    notaController.dispose();
  }
}

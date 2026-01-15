import 'package:flutter/widgets.dart';
import 'package:portal_do_aluno/features/admin/helper/boletim_helper.dart';

class GradeEntryController {
  final BoletimHelper boletimHelper = BoletimHelper();
  final TextEditingController notaController = TextEditingController();

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

  Future<bool> salvar() async {
    if(
      notaController.text.isEmpty 
    ){
      return false;
    }

    try{
      await boletimHelper.salvarNota(
      alunoId: selected['alunoId']!,
      turmaId: selected['turmaId']!,
      disciplinaId: selected['disciplinaId']!,
      disciplinaNome: selected['disciplinaNome']!,
      unidade: selected['unidade']!,
      tipoDeNota: selected['tipoAvaliacao']!,
      nota: double.parse(notaController.text.replaceAll(',', '.')),
    );
    }catch(e){
      return false;
    }
    return true;
    
  }

  void dispose() {
    notaController.dispose();
  }
}

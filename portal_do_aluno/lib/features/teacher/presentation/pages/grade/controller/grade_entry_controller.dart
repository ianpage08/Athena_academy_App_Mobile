import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/base/base_controller.dart';
import 'package:portal_do_aluno/features/admin/helper/boletim_helper.dart';

class GradeEntryController extends BaseController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final BoletimHelper boletimHelper = BoletimHelper();

  final formKey = GlobalKey<FormState>();
  final notaController = TextEditingController();

  final turmaSelecionada = ValueNotifier<String?>(null);
  final alunoSelecionado = ValueNotifier<String?>(null);

  final selected = ValueNotifier<Map<String, String?>>({
    'turmaId': null,
    'alunoId': null,
    'disciplinaId': null,
    'disciplinaNome': null,
    'unidade': null,
    'tipoAvaliacao': null,
  });

  final unidades = const [
    'Unidade 1',
    'Unidade 2',
    'Unidade 3',
    'Unidade 4',
  ];

  final avaliacoes = const [
    'Teste',
    'Prova',
    'Trabalho',
    'Nota Extra',
  ];

  Stream<QuerySnapshot<Map<String, dynamic>>> getDisciplinas() {
    return firestore.collection('disciplinas').snapshots();
  }

  bool get isFormValid {
    final s = selected.value;
    return s['turmaId'] != null &&
        s['alunoId'] != null &&
        s['disciplinaId'] != null &&
        s['unidade'] != null &&
        s['tipoAvaliacao'] != null &&
        notaController.text.isNotEmpty;
  }

  void updateField(String key, String? value) {
    selected.value = {...selected.value, key: value};
  }

  void clear() {
    turmaSelecionada.value = null;
    alunoSelecionado.value = null;
    notaController.clear();
    selected.value = {
      'turmaId': null,
      'alunoId': null,
      'disciplinaId': null,
      'disciplinaNome': null,
      'unidade': null,
      'tipoAvaliacao': null,
    };
  }

  Future<void> salvarNota() async {
    if (!formKey.currentState!.validate()) return;

    final s = selected.value;

    await boletimHelper.salvarNota(
      alunoId: s['alunoId']!,
      turmaId: s['turmaId']!,
      disciplinaId: s['disciplinaId']!,
      disciplinaNome: s['disciplinaNome']!,
      unidade: s['unidade']!,
      tipoDeNota: s['tipoAvaliacao']!,
      nota: double.parse(notaController.text.replaceAll(',', '.')),
    );

    clear();
  }
  @override
  void dispose() {
    notaController.dispose();
    super.dispose();
  }
}

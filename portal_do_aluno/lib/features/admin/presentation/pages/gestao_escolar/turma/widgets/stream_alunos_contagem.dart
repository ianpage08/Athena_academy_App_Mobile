import 'package:cloud_firestore/cloud_firestore.dart';

Stream<Map<String, int>> alunosPorTurma() {
  return FirebaseFirestore.instance.collection('matriculas').snapshots().map((
    snapshot,
  ) {
    final Map<String, int> contagem = {};

    for (var doc in snapshot.docs) {
      final dadosAcademicos = doc['dadosAcademicos'] as Map<String, dynamic>;
      final turmaId = dadosAcademicos['classId'];
      contagem[turmaId] = (contagem[turmaId] ?? 0) + 1;
    }

    return contagem;
  });
}

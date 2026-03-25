import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

Stream<Map<String, int>> alunosPorTurma() {
  return FirebaseFirestore.instance.collection('matriculas').snapshots().map((
    snapshot,
  ) {
    final Map<String, int> contagem = {};

   
    try {
      for (var doc in snapshot.docs) {
        
        final data = doc.data();

        
        if (data.containsKey('dadosAcademicos') &&
            data['dadosAcademicos'] != null) {
          final dadosAcademicos =
              data['dadosAcademicos'] as Map<String, dynamic>;

          // Tratamento seguro do ID
          final turmaId = dadosAcademicos['classId']?.toString();

          if (turmaId != null && turmaId.trim().isNotEmpty) {
            
            contagem[turmaId] = (contagem[turmaId] ?? 0) + 1;
          }
        }
      }
    } catch (e) {
     
      debugPrint('🚨 Erro crítico ao processar contagem de alunos: $e');
    }

    return contagem;
  });
}

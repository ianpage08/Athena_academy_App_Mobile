import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/models/calendario.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _collectionCalendario = _firestore.collection(
  'calendario',
);

class CalendarioService {
  Stream<QuerySnapshot> getCalendario() {
    return _collectionCalendario.snapshots();
  }

  Future<void> cadastrarCalendario(Calendario calendario) async {
    final docRef = _collectionCalendario.doc();
    final novoCalendario = calendario.copyWith(id: docRef.id);

    await docRef.set(novoCalendario.toJson());
  }

  Future<void> excluirCalendario(String calendarioId) {
    return _collectionCalendario.doc(calendarioId).delete();
  }

  Future<void> excluirPorDataexpiracao() async {
    final agora = Timestamp.now();

    final evento = await _firestore
        .collection('calendario')
        .where('dataDeExpiracao', isLessThanOrEqualTo: agora)
        .limit(499)
        .get();
    try {
      if (evento.docs.isEmpty) {
        debugPrint('Nenhum evento expirado encontrado');
        return;
      }
      WriteBatch batch = _firestore.batch();

      for (var evento in evento.docs) {
        batch.delete(evento.reference);
      }
      await batch.commit();
      debugPrint('Eventos expirados removidos: ${evento.docs.length}');
    } catch (e) {
      debugPrint('Erro ao excluir comunicados: $e');
    }
  }
}

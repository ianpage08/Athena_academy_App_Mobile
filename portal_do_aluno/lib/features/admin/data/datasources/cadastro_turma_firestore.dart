import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/core/school/school_firestore_path.dart';
import 'package:portal_do_aluno/features/admin/data/models/turma.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class CadastroTurmaService {
  final SchoolFirestorePath _schoolPath = SchoolFirestorePath(firestore: _firestore);

  Stream<QuerySnapshot<Map<String, dynamic>>> getTurmas() {
    return _schoolPath.collection('turmas').snapshots();
  }

  Future<void> cadatrarNovaTurma(ClasseDeAula turma) {
    final docRef = _schoolPath.collection('turmas').doc();
    final novaTurma = turma.copyWith(id: docRef.id);

    return docRef.set(novaTurma.toJson());
  }

  Future<void> excluirTurma(String turmaId) {
    return _schoolPath.collection('turmas').doc(turmaId).delete();
  }
}

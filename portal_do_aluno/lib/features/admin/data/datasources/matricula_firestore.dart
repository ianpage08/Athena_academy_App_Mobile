import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/features/admin/data/models/aluno_model/aluno.dart';
import 'package:portal_do_aluno/features/admin/data/models/aluno_model/dados_academicos.dart';
import 'package:portal_do_aluno/features/admin/data/models/aluno_model/endereco_aluno.dart';
import 'package:portal_do_aluno/features/admin/data/models/aluno_model/informacoes_medicas.dart';
import 'package:portal_do_aluno/features/admin/data/models/aluno_model/reponsavel_finaceiro.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class MatriculaService {
  Stream<QuerySnapshot> getMatriculas() {
    return _firestore.collection('matriculas').snapshots();
  }

  final CollectionReference matriculasColletion = _firestore.collection(
    'matriculas',
  );

  Future<void> cadastrarAlunoCompleto({
    required DadosAluno dadosAluno,
    required EnderecoAluno enderecoAluno,
    required ResponsavelFinanceiro responsavelFinanceiro,
    required DadosAcademicos dadosAcademicos,
    required InformacoesMedicasAluno informacoesMedicasAluno,
    required String turmaId,
  }) async {
    // Usamos o ID da turma passada
    final dadoAcademico = dadosAcademicos.copyWith(classId: turmaId);

    // Gerar ID do aluno
    final alunoId = matriculasColletion.doc().id;
    final novoAluno = dadosAluno.copyWith(id: alunoId);

    final alunoJson = {
      'dadosAluno': novoAluno.toJson(),
      'enderecoAluno': enderecoAluno.toJson(),
      'responsavelFinaceiro': responsavelFinanceiro.toJson(),
      'dadosAcademicos': dadoAcademico.toJson(),
      'informacoesMedicasAluno': informacoesMedicasAluno.toJson(),
    };

    await matriculasColletion.doc(alunoId).set(alunoJson);
  }

  Future<void> excluirMatricula(String matriculaId) async {
    await matriculasColletion.doc(matriculaId).delete();
  }

  Stream<int> getMatriculasCount() {
    return matriculasColletion.snapshots().map((doc) => doc.docs.length);
  }
}

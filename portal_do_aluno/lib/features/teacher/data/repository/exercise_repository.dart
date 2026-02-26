import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/features/teacher/data/datasources/exercicio_firestore.dart';
import 'package:portal_do_aluno/features/teacher/data/models/student_task.dart';

class ExerciseRepository {
  ExerciseRepository({
    ExercicioSevice? exercicioSevice,

    FirebaseFirestore? firestore,
  }) : _exercicioSevice = exercicioSevice ?? ExercicioSevice(),
       _firestore = firestore ?? FirebaseFirestore.instance;

  final ExercicioSevice _exercicioSevice;
  final FirebaseFirestore _firestore;

  Future<void> cadastrarNovoExercicio({
    required String professorId,
    required String turmaId,
    required String titulo,
    required String conteudo,
    required DateTime dataDeEntrega,
  }) async {
    final profDocId = await _firestore
        .collection('usuarios')
        .doc(professorId)
        .get();
    final nomeProfessor = profDocId['name'];
    final task = StudentTask(
      id: '',
      titulo: titulo,
      conteudoDoExercicio: conteudo,
      professorId: professorId,
      nomeDoProfessor: nomeProfessor,
      turmaId: turmaId,
      dataDeEnvio: Timestamp.now(),
      dataDeEntrega: Timestamp.fromDate(dataDeEntrega),
      dataDeExpiracao: Timestamp.fromDate(
        dataDeEntrega.add(const Duration(days: 7)),
      ),
    );
    try {
      await _exercicioSevice.cadastrarNovoExercicio(task, turmaId);
    } catch (e) {
      throw Exception('Erro ao cadastrar exercício: $e');
    }
  }

  Stream<QuerySnapshot> observarExercicios() {
    return _exercicioSevice.getExercicios();
  }

  Future<void> excluirExercicio(String id) {
    return _exercicioSevice.excluirExercicio(id);
  }

  /*Future<void> notificarTurma() async {
    final tokens = await _comunicadoService.getTokensDestinatario('alunos');

    final resumo = limitarCampo(conteudoController.text, 40);

    for (final token in tokens) {
      enviarNotification(token, 'Novo exercício disponível', resumo);
    }
  }*/
}

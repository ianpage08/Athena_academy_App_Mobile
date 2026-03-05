import 'package:portal_do_aluno/features/admin/data/datasources/cadastro_turma_firestore.dart';
import 'package:portal_do_aluno/features/admin/data/models/turma.dart';

class ResgistrationClassRepository {
  ResgistrationClassRepository({CadastroTurmaService? cadastroTurmaService})
    : _cadastroTurmaService = cadastroTurmaService ?? CadastroTurmaService();

  final CadastroTurmaService _cadastroTurmaService;

  Future<void> cadastrarClasse({
    required String nameTeacher,
    required String shift,
    required String amountStudents,
    required String serie,
  }) async {
    final newClass = ClasseDeAula(
      id: '',
      serie: serie,
      turno: shift,
      qtdAlunos: int.tryParse(amountStudents) ?? 0,
      professorTitular: nameTeacher,
    );
    await _cadastroTurmaService.cadatrarNovaTurma(newClass);
    
  }
}

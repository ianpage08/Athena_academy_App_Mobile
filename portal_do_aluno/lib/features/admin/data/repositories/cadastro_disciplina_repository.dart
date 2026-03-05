import 'package:portal_do_aluno/features/admin/data/datasources/cadastrar_diciplina_firestore.dart';
import 'package:portal_do_aluno/features/admin/data/models/diciplinas.dart';

class CadastroDisciplinaRepository {
  CadastroDisciplinaRepository({DisciplinaService? service})
    : _service = service ?? DisciplinaService();

  final DisciplinaService _service;

  Future<void> cadastrarNovaDisciplina({
    required String nameTeacher,
    required String discipline,
    required String numberClasses,
    required String hours,
  }) async {
    final newDiscipline = Disciplina(
      id: '',
      professor: nameTeacher,
      nome: discipline,
      aulaPrevistas: int.tryParse(numberClasses) ?? 0,
      cargaHoraria: int.tryParse(hours) ?? 0,
    );

    await _service.cadastrarNovaDisciplina(newDiscipline);
  }

  
}

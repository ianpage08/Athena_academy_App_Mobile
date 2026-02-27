import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/selected_provider.dart';
import 'package:portal_do_aluno/features/teacher/data/datasources/frequencia_firestore.dart';
import 'package:portal_do_aluno/features/teacher/data/models/class_attendance.dart';
import 'package:portal_do_aluno/features/teacher/presentation/providers/attendance_provider.dart';
import 'package:provider/provider.dart';

class AttendanceRepository {
  AttendanceRepository({
    FrequenciaService? frequenciaService,
    FirebaseFirestore? firestore,
  }) : _frequenciaService = frequenciaService ?? FrequenciaService(),
       _firestore = firestore ?? FirebaseFirestore.instance;

  final FrequenciaService _frequenciaService;
  final FirebaseFirestore _firestore;
  
  Stream<QuerySnapshot<Map<String, dynamic>>> alunosPorTurma(String turmaId) {
    return _firestore
        .collection('matriculas')
        .where('dadosAcademicos.classId', isEqualTo: turmaId)
        .snapshots();
  }

  Future<void> salvarFrequenciaPorTurma({
    required String classId,
    required DateTime dataSelecionada,
    required BuildContext context,
  }) async {
    final provider = context.read<AttendanceProvider>();
    final presencas = provider.presencas;

    final data = DateTime.utc(
      dataSelecionada.year,
      dataSelecionada.month,
      dataSelecionada.day,
    );
    
    for (final entry in presencas.entries) {
      final frequencia = ClassAttendance(
        id: '',
        alunoId: entry.key,
        classId: classId,
        data: data,
        presenca: entry.value,
      );

      await _frequenciaService.salvarFrequenciaPorTurma(
        alunoId: entry.key,
        turmaId: classId,
        frequencia: frequencia,
      );
    }
    if(context.mounted){
      provider.limpar();
      context.read<SelectedProvider>().limparDrop('turma');
    }
    
  }
}

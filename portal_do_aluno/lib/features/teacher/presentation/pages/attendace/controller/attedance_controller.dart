import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/selected_provider.dart';
import 'package:portal_do_aluno/features/teacher/data/datasources/frequencia_firestore.dart';
import 'package:portal_do_aluno/features/teacher/data/models/class_attendance.dart';
import 'package:portal_do_aluno/features/teacher/presentation/providers/attendance_provider.dart';
import 'package:portal_do_aluno/shared/helpers/app_snackbar.dart';
import 'package:provider/provider.dart';


class AttendanceRegistrationController {
  final FrequenciaService _service = FrequenciaService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? turmaId;
  DateTime? dataSelecionada;

  Stream<QuerySnapshot<Map<String, dynamic>>> alunosPorTurma(String turmaId) {
    return _firestore
        .collection('matriculas')
        .where('dadosAcademicos.classId', isEqualTo: turmaId)
        .snapshots();
  }

  Future<void> salvar(BuildContext context) async {
    if (turmaId == null || dataSelecionada == null) {
      showAppSnackBar(
        context: context,
        mensagem: 'Selecione turma e data.',
        cor: Colors.orange,
      );
      return;
    }

    final provider = context.read<AttendanceProvider>();
    final presencas = provider.presencas;

    final data = DateTime.utc(
      dataSelecionada!.year,
      dataSelecionada!.month,
      dataSelecionada!.day,
    );

    try {
      for (final entry in presencas.entries) {
        final frequencia = ClassAttendance(
          id: '',
          alunoId: entry.key,
          classId: turmaId!,
          data: data,
          presenca: entry.value,
        );

        await _service.salvarFrequenciaPorTurma(
          alunoId: entry.key,
          turmaId: turmaId!,
          frequencia: frequencia,
        );
      }
      if(context.mounted){
        showAppSnackBar(
        context: context,
        mensagem: 'Presenças salvas com sucesso!',
        cor: Colors.green,
      );
      
      

      provider.limpar();
      context.read<SelectedProvider>().limparDrop('turma');
      }
    } catch (_) {
      if(context.mounted){
        showAppSnackBar(
        context: context,
        mensagem: 'Erro ao salvar frequência.',
        cor: Colors.red,
      );
      }
      
    }
  }
}

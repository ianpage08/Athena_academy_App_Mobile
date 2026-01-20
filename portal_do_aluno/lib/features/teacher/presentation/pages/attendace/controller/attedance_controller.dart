import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/base/base_controller.dart';
import 'package:portal_do_aluno/core/errors/app_error.dart';
import 'package:portal_do_aluno/core/errors/app_error_type.dart';
import 'package:portal_do_aluno/core/submit%20state/submit_states.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/selected_provider.dart';
import 'package:portal_do_aluno/features/teacher/data/datasources/frequencia_firestore.dart';
import 'package:portal_do_aluno/features/teacher/data/models/class_attendance.dart';
import 'package:portal_do_aluno/features/teacher/presentation/providers/attendance_provider.dart';

import 'package:provider/provider.dart';


class AttendanceRegistrationController extends BaseController{
  final FrequenciaService _service = FrequenciaService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final state = ValueNotifier<SubmitState>(Initial());


  String? turmaId;
  DateTime? dataSelecionada;

  Stream<QuerySnapshot<Map<String, dynamic>>> alunosPorTurma(String turmaId) {
    return _firestore
        .collection('matriculas')
        .where('dadosAcademicos.classId', isEqualTo: turmaId)
        .snapshots();
  }

  Future<SubmitState> salvar(BuildContext context) async {

    if (turmaId == null || dataSelecionada == null) {
      
      return state.value = SubmitError(AppError(type: AppErrorType.validation , message: 'Preencha todos os campos'));
    }
    state.value = SubmitLoading();
    

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
      
      
      state.value = SubmitSuccess('Presença salva com sucesso');
      provider.limpar();
      context.read<SelectedProvider>().limparDrop('turma');
      }
      return state.value;
    } catch (_) {
      state.value = SubmitError(AppError(type: AppErrorType.unknown , message: 'Erro ao salvar presença'));
      return state.value;
      
    }
  }
  @override
  void dispose() {
    turmaId = null;
    dataSelecionada = null;
    super.dispose();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/errors/app_error.dart';
import 'package:portal_do_aluno/core/errors/app_error_type.dart';
import 'package:portal_do_aluno/core/submit_state/submit_states.dart';
import 'package:portal_do_aluno/features/admin/data/repositories/calendar_repository.dart';
import 'package:portal_do_aluno/features/admin/helper/form_helper.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/calendar_event_type.dart';

class CalendarEventController {
  final submitState = ValueNotifier<SubmitState>(Initial());
  final CalendarRepository _repository = CalendarRepository();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();

  DateTime? dataSelecionada;

  Future<void> salvar(CalendarEventType tipo) async {
    if (!FormHelper.isFormValid(
      formKey: formKey,
      listControllers: [tituloController],
    )) {
      submitState.value = SubmitError(
        AppError(
          type: AppErrorType.validation,
          message: 'Preencha todos os campos',
        ),
      );
      return;
    }

    if (dataSelecionada == null) {
      submitState.value = SubmitError(
        AppError(type: AppErrorType.validation, message: 'Selecione uma data'),
      );
      return;
    }
    submitState.value = SubmitLoading();
    debugPrint('Salvando evento...');

    try {
      await _repository.createEvent(
        titulo: tituloController.text.trim(),
        descricao: descricaoController.text.trim(),
        tipo: tipo,
        dataSelecionada: dataSelecionada!,
      );

      submitState.value = SubmitSuccess('Evento criado com sucesso!');
      debugPrint('Evento criado com sucesso!');
      clear();
    } on FirebaseException {
      submitState.value = SubmitError(
        AppError(
          type: AppErrorType.network,
          message: 'Sem internet, tente novamente mais tarde.',
        ),
      );
    } catch (e) {
      debugPrint('Erro ao criar evento: $e');
      submitState.value = SubmitError(
        AppError(type: AppErrorType.unknown, message: 'Erro ao criar evento '),
      );
    }
  }

  void clear() {
    tituloController.clear();
    descricaoController.clear();
  }

  void dispose() {
    submitState.dispose();
    tituloController.dispose();
    descricaoController.dispose();
  }
}

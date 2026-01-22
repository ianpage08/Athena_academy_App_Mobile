import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/errors/app_error.dart';
import 'package:portal_do_aluno/core/errors/app_error_type.dart';
import 'package:portal_do_aluno/core/notifications/enviar_notification.dart';
import 'package:portal_do_aluno/core/submit_state/submit_states.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/cadastro_comunicado_firestore.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/calendario_firestore.dart';
import 'package:portal_do_aluno/features/admin/data/models/calendario.dart';
import 'package:portal_do_aluno/features/admin/helper/form_helper.dart';
import 'package:portal_do_aluno/features/admin/helper/limitar_tamanho_texto.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/calendar_event_type.dart';

class CalendarEventController {
  final CalendarioService _service = CalendarioService();
  final submitState = ValueNotifier<SubmitState>(Initial());

  final formKey = GlobalKey<FormState>();
  final tituloController = TextEditingController();
  final descricaoController = TextEditingController();
  final ComunicadoService _comunicadoService = ComunicadoService();

  DateTime? dataSelecionada;

  int tipoParaInt(CalendarEventType tipo) {
    switch (tipo) {
      case CalendarEventType.avaliacao:
        return 1;
      case CalendarEventType.reuniao:
        return 2;
      case CalendarEventType.eventoEscolar:
        return 3;
      case CalendarEventType.outro:
        return 4;
    }
  }

  Calendario _buildEvent(CalendarEventType tipo) {
    return Calendario(
      id: '',
      titulo: tituloController.text.trim(),
      data: dataSelecionada!,
      tipo: tipoParaInt(tipo),
      descricao: descricaoController.text.trim(),
      dataDeExpiracao: Timestamp.fromDate(
        dataSelecionada!.add(const Duration(days: 30)),
      ),
    );
  }

  Future<void> salvar(CalendarEventType tipo) async {
    if (!FormHelper.isFormValid(
      formKey: formKey,
      listControllers: [tituloController, descricaoController],
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
      await _service.cadastrarCalendario(_buildEvent(tipo));
      clear();

      submitState.value = SubmitSuccess('Evento criado com sucesso!');
      debugPrint('Evento criado com sucesso!');
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

  Future<void> notificarUsuarios() async {
    debugPrint('Notificando usuários...');
    final tokens = await _comunicadoService.getTokensDestinatario('todos');
    debugPrint('Tokens: ${tokens.length}');

    final descricao = limitarCampo(descricaoController.text.trim(), 40);

    for (final token in tokens) {
      await enviarNotification(
        token,
        'Novo Evento: ${tituloController.text}',
        descricao,
      );
      debugPrint('Notificação enviada para $token');
    }
  }

  void clear() {
    tituloController.clear();
    descricaoController.clear();
    dataSelecionada = null;
  }

  void dispose() {
    submitState.dispose();
    tituloController.dispose();
    descricaoController.dispose();
  }
}

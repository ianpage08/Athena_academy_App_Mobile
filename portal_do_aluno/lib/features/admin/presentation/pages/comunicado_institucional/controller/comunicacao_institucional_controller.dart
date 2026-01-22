import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/errors/app_error.dart';
import 'package:portal_do_aluno/core/errors/app_error_type.dart';
import 'package:portal_do_aluno/core/notifications/enviar_notification.dart';
import 'package:portal_do_aluno/core/submit_state/submit_states.dart';

import 'package:portal_do_aluno/features/admin/data/datasources/cadastro_comunicado_firestore.dart';
import 'package:portal_do_aluno/features/admin/data/models/comunicado.dart';
import 'package:portal_do_aluno/features/admin/helper/form_helper.dart';
import 'package:portal_do_aluno/features/admin/helper/limitar_tamanho_texto.dart';

class ComunicacaoInstitucionalController {
  // Persistência
  final ComunicadoService service = ComunicadoService();

  // Estado de envio
  final submitState = ValueNotifier<SubmitState>(Initial());

  // Formulário
  final formKey = GlobalKey<FormState>();
  final tituloController = TextEditingController();
  final mensagemController = TextEditingController();

  // Campos extras
  PrioridadeComunicado? prioridade;
  String? destinatario;

  // Validação extra
  bool get isFormularioValido => prioridade != null && destinatario != null;

  // Monta o comunicado
  Comunicado buildComunicado() {
    return Comunicado(
      id: '',
      titulo: tituloController.text.trim(),
      mensagem: mensagemController.text.trim(),
      prioridade: prioridade!.name,
      destinatario: Destinatario.values.byName(destinatario!.toLowerCase()),
      dataPublicacao: DateTime.now(),
      dataDeExpiracao: Timestamp.fromDate(
        DateTime.now().add(const Duration(days: 7)),
      ),
    );
  }

  // Envio principal
  Future<void> enviar() async {
    if (!FormHelper.isFormValid(
      formKey: formKey,
      listControllers: [tituloController, mensagemController],
    )) {
      submitState.value = SubmitError(
        AppError(
          type: AppErrorType.validation,
          message: 'Preencha todos os campos',
        ),
      );
      return;
    }

    if (!isFormularioValido) {
      submitState.value = SubmitError(
        AppError(
          type: AppErrorType.validation,
          message: 'Selecione prioridade e destinatário',
        ),
      );
      return;
    }
    submitState.value = SubmitLoading();

    try {
      await service.enviarComunidado(buildComunicado());
      await notificarDestinatarios();
      clear();
      submitState.value = SubmitSuccess('Comunicado enviado com sucesso!');
    } on FirebaseException {
      submitState.value = SubmitError(
        AppError(
          type: AppErrorType.network,
          message: 'Sem internet, tente novamente mais tarde.',
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      
      submitState.value = SubmitError(
        AppError(
          type: AppErrorType.unknown,
          message: 'Erro ao enviar comunicado',
        ),
      );
    }
  }

  // Notificação push
  Future<void> notificarDestinatarios() async {
    if (destinatario == null) return;

    final tokens = await service.getTokensDestinatario(
      Destinatario.values.byName(destinatario!.toLowerCase()).name,
    );

    final resumo = limitarCampo(mensagemController.text.trim(), 40);

    for (final token in tokens) {
      enviarNotification(token, 'Novo comunicado disponível', resumo);
    }
  }

  // Limpa formulário
  void clear() {
    tituloController.clear();
    mensagemController.clear();
    prioridade = null;
    destinatario = null;
  }

  // Liberação de recursos
  void dispose() {
    submitState.dispose();
    tituloController.dispose();
    mensagemController.dispose();
  }
}

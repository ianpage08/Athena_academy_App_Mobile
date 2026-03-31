import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/errors/app_error.dart';
import 'package:portal_do_aluno/core/errors/app_error_type.dart';
import 'package:portal_do_aluno/core/submit_state/submit_states.dart';
import 'package:portal_do_aluno/features/admin/data/models/comunicado.dart';
import 'package:portal_do_aluno/features/admin/data/repositories/statement_repository.dart';
import 'package:portal_do_aluno/features/admin/helper/form_helper.dart';

class ComunicacaoInstitucionalController extends ChangeNotifier {
  ComunicacaoInstitucionalController({StatementRepository? repository})
    : _repository =
          repository ??
          StatementRepository(); //aqui top falando que ele pode receber um repository externo, mas se não receber, ele cria um novo StatementRepository por conta própria. Isso é útil para testes, onde você pode passar um mock ou fake repository.

  // Persistência

  // Estado de envio
  final StatementRepository _repository;

  // Formulário
  final formKey = GlobalKey<FormState>();
  final tituloController = TextEditingController();
  final mensagemController = TextEditingController();

  // Campos observavel
  SubmitState _submitState = Initial();
  PrioridadeComunicado? _prioridade;
  String? _destinatario;

  // Validação extra
  PrioridadeComunicado? get prioridade => _prioridade;
  String? get destinatario => _destinatario;
  SubmitState get submitState => _submitState;
  bool get isLoading => _submitState is SubmitLoading;
  bool get isFormularioValido => prioridade != null && destinatario != null;

  void setPrioridade(PrioridadeComunicado? value) {
    _prioridade = value;
    notifyListeners();
  }

  void setDestinatario(String? value) {
    _destinatario = value;
    notifyListeners();
  }

  // Envio principal
  Future<void> enviar() async {
    if (!FormHelper.isFormValid(
      formKey: formKey,
      listControllers: [tituloController, mensagemController],
    )) {
      _setError(AppErrorType.validation, 'Preencha todos os campos');
      return;
    }

    if (!isFormularioValido) {
      _setError(AppErrorType.validation, 'Selecione destinatário e prioridade');
      return;
    }
    _submitState = SubmitLoading();
    notifyListeners();

    try {
      await _repository.newStatement(
        titulo: tituloController.text.trim(),
        mensagem: mensagemController.text.trim(),
        destinatario: destinatario!,
        prioridade: prioridade!.name,
      );

      await _repository.statementNotification(
        destinatario: destinatario!,
        message: mensagemController.text.trim(),
      );
      clear();
      _submitState = SubmitSuccess('Comunicado enviado com sucesso!');
      notifyListeners();
    } on FirebaseException {
      _setError(AppErrorType.network, 'Erro ao conectar com o servidor');
    } catch (e) {
      debugPrint(e.toString());

      _setError(AppErrorType.unknown, 'Ocorreu um erro inesperado');
    }
  }

  // Limpa formulário
  void clear() {
    tituloController.clear();
    mensagemController.clear();
    _prioridade = null;
    _destinatario = null;
  }

  // Liberação de recursos
  @override
  void dispose() {
    _submitState = Initial();
    tituloController.dispose();
    mensagemController.dispose();
    super.dispose();
  }

  void _setError(AppErrorType type, String message) {
    _submitState = SubmitError(AppError(type: type, message: message));
    notifyListeners();
  }
}

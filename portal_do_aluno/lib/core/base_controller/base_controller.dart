import 'package:flutter/foundation.dart';
import 'package:portal_do_aluno/core/errors/app_error.dart';
import 'package:portal_do_aluno/core/errors/app_error_type.dart';
import 'package:portal_do_aluno/core/submit_state/submit_states.dart';

/// BaseController: classe base para controllers do app.
/// Objetivo: padronizar o fluxo "submit" de ações assíncronas:
/// - inicia em Initial
/// - quando executa uma ação: vai para Loading
/// - se der certo: vai para Success (com mensagem)
/// - se der erro: vai para Error (com AppError)
///
/// A UI pode ouvir `state` via ValueListenableBuilder e reagir automaticamente.
abstract class BaseController {
  /// Estado observável do fluxo de submit.
  /// A UI escuta isso para exibir loading, sucesso ou erro.
  final ValueNotifier<SubmitState> state = ValueNotifier(Initial());

  /// Coloca a UI em estado de carregamento (ex: desabilita botão e mostra spinner).
  void setLoading() => state.value = SubmitLoading();

  /// Coloca a UI em estado de sucesso (mensagem para snackbar/dialog/toast).
  /// OBS: o nome está com typo: "setSucess" -> ideal "setSuccess".
  void setSucess(String message) => state.value = SubmitSuccess(message);

  /// Coloca a UI em estado de erro usando sua estrutura padrão AppError.
  /// `type` ajuda a UI a decidir como mostrar (sem internet, validação, etc).
  void setError(String message, {AppErrorType type = AppErrorType.unknown}) =>
      state.value = SubmitError(AppError(type: type, message: message));

  /// Reseta o fluxo para o estado inicial.
  /// Útil após fechar um dialog/snackbar, ou ao entrar novamente na tela.
  void reset() => state.value = Initial();

  /// Executa uma ação assíncrona com "guard" (proteção) e padroniza o fluxo de estado.
  ///
  /// Contrato:
  /// - Sempre chama setLoading() antes de rodar.
  /// - Se a action terminar sem erro: marca Success.
  /// - Se lançar AppError: vira SubmitError(AppError).
  /// - Outros erros: atualmente tenta tratar como AppError (mas do jeito que está,
  ///   ele acaba engolindo muitos erros silenciosamente; ver observação abaixo).
  ///
  /// Uso típico:
  /// await controller.runAction(() async {
  ///   await repository.save(data);
  /// });
  Future runAction(Future<void> Function() action) async {
    try {
      // 1) UI entra em modo "carregando"
      setLoading();

      // 2) Executa a ação real (ex: salvar, login, enviar relatório)
      await action();

      // 3) Se chegou aqui, deu tudo certo: manda sucesso pra UI
      setSucess('Sucesso');
    } on AppError catch (e) {
      // Se o erro já vier no padrão AppError, reaproveita direto.
      // Isso permite que a UI use e.type / e.message.
      state.value = SubmitError(e);
    } catch (e) {
      // Aqui captura QUALQUER outra coisa (Exception/Error).
        setError('Erro desconhecido', type: AppErrorType.unknown);
      
    }
  }

  /// @mustCallSuper obriga controllers filhos chamarem super.dispose().
  @mustCallSuper
  void dispose() {
    state.dispose();
  }
}
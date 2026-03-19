// Importações necessárias para UI, estados e regras de negócio
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/base_controller/base_controller.dart';
import 'package:portal_do_aluno/core/errors/app_error.dart';
import 'package:portal_do_aluno/core/errors/app_error_type.dart';
import 'package:portal_do_aluno/core/submit_state/submit_states.dart';
import 'package:portal_do_aluno/features/admin/helper/form_helper.dart';
import 'package:portal_do_aluno/features/teacher/data/repository/exercise_repository.dart';

/// Controller responsável por orquestrar a criação de um exercício.
/// 
/// Ele:
/// - Controla o estado da submissão (loading, success, error)
/// - Valida o formulário
/// - Chama o Repository para salvar no banco
/// - Limpa os campos após sucesso
/// 
/// Regra de ouro:
/// Controller NÃO acessa banco diretamente.
/// Sempre delega ao Repository.
class CreateExerciseController extends BaseController {

  /// Estado específico desta tela (poderia usar o state do BaseController,
  /// mas aqui está sendo usado um separado).
  final submitState = ValueNotifier<SubmitState>(Initial());

  /// Camada responsável por comunicação com Firestore/Serviços.
  /// Controller nunca fala direto com banco.
  final ExerciseRepository _repository = ExerciseRepository();

  /// Chave global do formulário para validações.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Controllers responsáveis por capturar texto digitado.
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController conteudoController = TextEditingController();

  /// Turma selecionada (usado para atualizar UI reativamente).
  final ValueNotifier<String?> turmaSelecionada = ValueNotifier<String?>(null);
  
  /// ID da turma escolhida.
  /// Separado do ValueNotifier porque é regra de negócio.
  String? turmaId;

  /// Data de entrega escolhida.
  DateTime? dataSelecionada;

  /// Método principal responsável por enviar os dados do exercício.
  /// Recebe o professorId como parâmetro.
  Future<SubmitState> submit(String professorId) async {

    // Validação do formulário:
    // - Verifica campos obrigatórios
    // - Verifica se turma foi selecionada
    // - Verifica se data foi escolhida
    if (!FormHelper.isFormValid(
          formKey: formKey,
          listControllers: [tituloController, conteudoController],
        ) ||
        turmaId == null ||
        dataSelecionada == null) {

      // Caso inválido → retorna erro de validação
      submitState.value = SubmitError(
        AppError(
          type: AppErrorType.validation,
          message: 'Preencha todos os campos',
        ),
      );

      return submitState.value;
    }

    // Atualiza estado para loading
    submitState.value = SubmitLoading();

    try {

      // Chama o repository para salvar no banco.
      // Regra importante:
      // Controller só orquestra, não executa persistência.
      _repository.cadastrarNovoExercicio(
        professorId: professorId,
        turmaId: turmaId!,
        titulo: tituloController.text.trim(),
        conteudo: conteudoController.text.trim(),
        dataDeEntrega: dataSelecionada!,
      );

      // Limpa os campos após sucesso
      clear();

      // Atualiza estado para sucesso
      submitState.value = SubmitSuccess('Exercício cadastrado com sucesso');
      return submitState.value;

    } catch (e) {

      // Caso qualquer erro inesperado aconteça
      submitState.value = SubmitError(
        AppError(
          type: AppErrorType.unknown,
          message: 'Erro ao cadastrar exercício',
        ),
      );

      // Log para debug (não mostrar detalhes sensíveis para usuário)
      debugPrint('Erro ao cadastrar exercício: $e');

      return submitState.value;
    }
  }

  /// Limpa todos os campos da tela.
  /// Deve ser chamado apenas após sucesso.
  void clear() {
    turmaId = null;
    dataSelecionada = null;
    turmaSelecionada.value = null;

    tituloController.clear();
    conteudoController.clear();
  }

  /// Libera memória quando o controller não for mais usado.
  /// Sempre descartar TextEditingController.
  @override
  void dispose() {
    super.dispose();

    tituloController.dispose();
    conteudoController.dispose();
  }
}
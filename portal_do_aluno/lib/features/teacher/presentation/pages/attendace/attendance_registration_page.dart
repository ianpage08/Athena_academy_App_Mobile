import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/teacher/data/repository/attendance_repository.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/attendace/controller/attendance_controller.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/attendace/widgets/attendance_aluno_list.dart';
import 'package:portal_do_aluno/shared/services/snackbar/controller_snack.dart';
import 'package:portal_do_aluno/shared/widgets/select_class_button.dart';
import 'package:portal_do_aluno/shared/widgets/custom_date_picker_field.dart';
import 'package:portal_do_aluno/shared/widgets/save_button.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';

/// Tela principal de Registro de Presença.
///
/// Arquitetura:
/// Utiliza o padrão Controller para regras de negócio e [ValueNotifier]
/// para reatividade pontual da UI, evitando reconstruções (rebuilds)
/// desnecessárias na árvore inteira do [Scaffold].
class AttendanceRegistrationPage extends StatefulWidget {
  const AttendanceRegistrationPage({super.key});

  @override
  State<AttendanceRegistrationPage> createState() =>
      _AttendanceRegistrationPageState();
}

class _AttendanceRegistrationPageState
    extends State<AttendanceRegistrationPage> {
  // Instância única do Controller que gerencia o estado da chamada
  final controller = AttendanceRegistrationController();

  // Repositório para busca de dados dos alunos em tempo real
  final AttendanceRepository _repository = AttendanceRepository();

  /// Estado local reativo: Controla o texto de exibição da turma selecionada
  final ValueNotifier<String?> turmaSelecionada = ValueNotifier(null);

  /// Estado local reativo: Gatilho principal para carregar a lista de alunos
  final ValueNotifier<String?> turmaIdSelecionada = ValueNotifier(null);

  /// Listener para eventos de sucesso/erro (Ex: SnackBar, Dialogs).
  /// Definido como nullable para evitar LateInitializationError caso o widget
  /// seja descartado antes do primeiro frame renderizar.
  VoidCallback? _submitListener;

  @override
  void initState() {
    super.initState();

    /// Aguardamos o primeiro frame ser desenhado antes de atrelar o listener.
    /// Isso garante que o 'context' esteja totalmente disponível e seguro
    /// para navegação ou exibição de SnackBars.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _submitListener = SubmitStateListener.attach(
        context: context,
        state: controller.state,
      );
    });
  }

  @override
  void dispose() {
    // 1. Removemos a escuta de side-effects para evitar memory leaks
    _submitListener?.call();

    // 2. Limpamos os notifiers da memória
    turmaSelecionada.dispose();
    turmaIdSelecionada.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Registro de Presença'),

      /// Usamos SafeArea no BottomNavigationBar para garantir que o botão
      /// não fique escondido pela barra de navegação nativa do iOS/Android.
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SaveButton(
            salvarconteudo: () async {
              // A delegação da ação fica 100% no controller
              controller.salvar(context);
            },
          ),
        ),
      ),

      body: SingleChildScrollView(
        // Padding otimizado para não colar nas bordas do aparelho
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Sessão de Filtros (Contexto da Chamada) ---
            // Agrupar inputs melhora a carga cognitiva do professor.
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.dividerColor.withValues(
                    alpha: isDark ? 0.1 : 0.5,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(context, 'Selecione a Turma'),
                  const SizedBox(height: 8),
                  SelectClassButton(
                    turmaSelecionada: turmaSelecionada,
                    onTurmaSelecionada: (id, nome) {
                      // 1. Atualiza a regra de negócio
                      controller.turmaId = id;

                      // 2. Dispara a reatividade da UI local
                      turmaSelecionada.value = nome;
                      turmaIdSelecionada.value = id;
                    },
                  ),

                  const SizedBox(height: 16),

                  _buildLabel(context, 'Data da Aula'),
                  const SizedBox(height: 8),
                  CustomDatePickerField(
                    onDate: (data) => controller.dataSelecionada = data,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- Lista de Alunos Reativa ---
            // O ValueListenableBuilder garante que apenas esta área da tela
            // seja reconstruída quando o professor troca de turma.
            ValueListenableBuilder<String?>(
              valueListenable: turmaIdSelecionada,
              builder: (context, turmaId, child) {
                // Estado Vazio: Nenhuma turma selecionada ainda
                if (turmaId == null) {
                  return _buildEmptyState(context);
                }

                // Estado Preenchido: Delega o stream para o componente de lista
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(context, 'Lista de Alunos'),
                    const SizedBox(height: 12),
                    AttendanceStudentList(
                      stream: _repository.alunosPorTurma(turmaId),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- Helpers Visuais Privados ---

  /// Padroniza os labels da tela, mantendo a hierarquia visual.
  Widget _buildLabel(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  /// Constrói um estado vazio amigável e alinhado com o design system do Athena.
  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.02)
            : Colors.black.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16),
        // Borda tracejada (simulada) ou sólida suave indicando área de conteúdo
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline_rounded,
            size: 48,
            color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Pronto para a chamada?',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Selecione uma turma acima para carregar a lista de alunos.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}

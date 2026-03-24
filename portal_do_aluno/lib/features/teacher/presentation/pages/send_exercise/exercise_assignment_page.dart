import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/user_provider.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/send_exercise/controller/create_exercise_controller.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/send_exercise/widgets/exercise_form.dart';
import 'package:portal_do_aluno/shared/services/snackbar/controller_snack.dart';
import 'package:portal_do_aluno/shared/widgets/save_button.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

/// Tela de orquestração para envio de novos exercícios.
class ExerciseAssignmentPage extends StatefulWidget {
  const ExerciseAssignmentPage({super.key});

  @override
  State<ExerciseAssignmentPage> createState() => _ExerciseAssignmentPageState();
}

class _ExerciseAssignmentPageState extends State<ExerciseAssignmentPage> {
  final CreateExerciseController controller = CreateExerciseController();
  VoidCallback? _detachSubmitListener;

  @override
  void initState() {
    super.initState();

    // Garante que a árvore de widgets foi construída antes de atrelar o listener.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _detachSubmitListener = SubmitStateListener.attach(
        context: context,
        state: controller.submitState,
      );
    });
  }

  @override
  void dispose() {
    _detachSubmitListener
        ?.call(); // Limpa o listener com segurança (Null-aware)
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final professorId = context.watch<UserProvider>().userId;
    final theme = Theme.of(context);

    if (professorId == null) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'Nova Atividade'),
        body: Center(child: CupertinoActivityIndicator(radius: 16)),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Nova Atividade'),

      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SaveButton(
          label: 'Publicar Exercício', // Microcopy contextual
          icon: CupertinoIcons.paperplane_fill, // Ícone semântico de envio
          onSave: () async {
            FocusScope.of(context).unfocus(); // Baixa o teclado ao clicar

            await controller.submit(professorId);
          },
        ),
      ),

      body: GestureDetector(
        onTap: () =>
            FocusScope.of(context).unfocus(), // Fecha teclado ao clicar fora
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- CABEÇALHO DA TELA (UX) ---
                    Text(
                      'Criar Nova Atividade',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Preencha as informações para enviar um exercício à turma.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // O Formulário Modularizado
                    ExerciseForm(controller: controller),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

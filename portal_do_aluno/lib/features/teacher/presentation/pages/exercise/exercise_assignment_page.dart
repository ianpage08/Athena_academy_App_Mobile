import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/user_provider.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/exercise/controller/create_exercise_controller.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/exercise/widgets/exercise_form.dart';
import 'package:portal_do_aluno/shared/services/snackbar/controller_snack.dart';
import 'package:portal_do_aluno/shared/widgets/save_button.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class ExerciseAssignmentPage extends StatefulWidget {
  const ExerciseAssignmentPage({super.key});

  @override
  State<ExerciseAssignmentPage> createState() => _ExerciseAssignmentPageState();
}

class _ExerciseAssignmentPageState extends State<ExerciseAssignmentPage> {
  final CreateExerciseController controller = CreateExerciseController();
  late final VoidCallback _submitListener;

  @override
  void dispose() {
    controller.dispose();
    _submitListener();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _submitListener = SubmitStateListener.attach(
      context: context,
      state: controller.submitState,
    );
  }

  @override
  Widget build(BuildContext context) {
    final professorId = context.watch<UserProvider>().userId;

    if (professorId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Cadastro de Exercício'),
      body: Stack(
        children: [
          // Conteúdo principal
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        ExerciseForm(controller: controller),
                        const SizedBox(height: 24),
                        SaveButton(
                          salvarconteudo: () async {
                            controller.submit(professorId);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

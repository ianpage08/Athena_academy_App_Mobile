import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/user_provider.dart';
import 'package:portal_do_aluno/features/student/presentation/widgets/animated_overlay.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/exercise/controller/create_exercise_controller.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/exercise/widgets/exercise_form.dart';
import 'package:portal_do_aluno/shared/helpers/app_snackbar.dart';
import 'package:portal_do_aluno/shared/widgets/save_button.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class ExerciseAssignmentPage extends StatefulWidget {
  const ExerciseAssignmentPage({super.key});

  @override
  State<ExerciseAssignmentPage> createState() => _ExerciseAssignmentPageState();
}

class _ExerciseAssignmentPageState extends State<ExerciseAssignmentPage> {
  bool _isLoading = false;
  final CreateExerciseController controller = CreateExerciseController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
          SingleChildScrollView(
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
                          setState(() => _isLoading = true);

                          final sucesso = await controller.submit(professorId);

                          setState(() => _isLoading = false);
                          showAppSnackBar(
                            context: context,
                            mensagem: sucesso
                                ? 'Exercício cadastrado com sucesso!'
                                : 'Preencha todos os campos corretamente.',
                            cor: sucesso ? Colors.green : Colors.orange,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading == true) const AnimatedOverlay(),
        ],
      ),
    );
  }
}

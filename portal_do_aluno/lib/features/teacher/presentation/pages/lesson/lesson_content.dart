import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/submit%20state/submit_states.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/lesson/controller/lesson_controller.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/lesson/widget/lesson_context_section.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/lesson/widget/lesson_info_section.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/lesson/widget/section_title.dart';
import 'package:portal_do_aluno/shared/services/snackbar/controller_snack.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';
import 'package:portal_do_aluno/shared/widgets/save_button.dart';

class LessonContent extends StatefulWidget {
  const LessonContent({super.key});

  @override
  State<LessonContent> createState() => _LessonContentState();
}

class _LessonContentState extends State<LessonContent> {
  final LessonController controller = LessonController();
  late final VoidCallback _submitListener;

  @override
  void dispose() {
    _submitListener();
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _submitListener = SubmitStateListener.attach(
        context: context,
        state: controller.submitState,
        
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Conteúdo ministrado'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle('Informações da aula'),
                    const SizedBox(height: 20),

                    ///  INFO
                    LessonInfoSection(controller: controller),

                    const SizedBox(height: 32),
                    const Divider(),
                    const SizedBox(height: 32),

                    const SectionTitle('Conteúdo ministrado'),
                    const SizedBox(height: 16),

                    ///  CONTENT
                    LessonContentSection(controller: controller),

                    const SizedBox(height: 28),

                    ///  ACTION
                    SizedBox(
                      width: double.infinity,
                      child: SaveButton(
                        salvarconteudo: () async {
                          if (controller.submitState.value is SubmitLoading) {
                            return;
                          }
                          controller.submit();
                        },
                      ),
                    ),
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

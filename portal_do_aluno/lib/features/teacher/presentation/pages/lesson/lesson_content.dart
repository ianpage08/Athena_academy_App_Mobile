import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/submit_state/submit_states.dart';
import 'package:portal_do_aluno/features/admin/helper/anexo_helper.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/user_provider.dart';
import 'package:portal_do_aluno/features/student/presentation/widgets/animated_overlay.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/lesson/controller/lesson_controller.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/lesson/widget/attach_section.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/lesson/widget/lesson_context_section.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/lesson/widget/lesson_info_section.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/lesson/widget/section_title.dart';
import 'package:portal_do_aluno/shared/helpers/app_snackbar.dart';
import 'package:portal_do_aluno/shared/services/snackbar/controller_snack.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';
import 'package:portal_do_aluno/shared/widgets/save_button.dart';
import 'package:provider/provider.dart';

class LessonContent extends StatefulWidget {
  const LessonContent({super.key});

  @override
  State<LessonContent> createState() => _LessonContentState();
}

class _LessonContentState extends State<LessonContent> {
  final LessonController controller = LessonController();
  bool _isLoading = false;

  VoidCallback? _detachSubmitListener;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _detachSubmitListener = SubmitStateListener.attach(
        context: context,
        state: controller.submitState,
      );
    });
  }

  @override
  void dispose() {
    _detachSubmitListener?.call();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserProvider>().userId;

    return Stack(
      children: [
        Scaffold(
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
                        const SectionTitle('Informações'),
                        const SizedBox(height: 20),
                        LessonInfoSection(controller: controller),

                        const SizedBox(height: 32),
                        const Divider(),
                        const SizedBox(height: 32),

                        const SectionTitle('Conteúdo ministrado'),
                        const SizedBox(height: 16),
                        LessonContentSection(controller: controller),

                        const SizedBox(height: 16),
                        AttachSection(
                          attachedCount: controller.imgSelected.length,
                          onAttach: () => _onAttachPressed(context),
                        ),

                        const SizedBox(height: 28),
                        ValueListenableBuilder<SubmitState>(
                          valueListenable: controller.submitState,
                          builder: (context, state, _) {
                            return SizedBox(
                              width: double.infinity,
                              child: SaveButton(
                                salvarconteudo: () async {
                                  if (userId == null) {
                                    showAppSnackBar(
                                      context: context,
                                      mensagem: 'Usuário não identificado.',
                                      cor: Colors.red,
                                    );
                                    return;
                                  }
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await controller.submit(userId);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_isLoading == true) const AnimatedOverlay(),
      ],
    );
  }

  Future<void> _onAttachPressed(BuildContext context) async {
    final images = await getImage();
    if (!mounted) return;

    if (images.isEmpty) {
      showAppSnackBar(
        context: context,
        mensagem: 'Nenhum arquivo selecionado.',
        cor: Colors.orange,
      );
      return;
    }

    controller.imgSelected
      ..clear()
      ..addAll(images);

    setState(() {});

    showAppSnackBar(
      context: context,
      mensagem: '${images.length} arquivo(s) anexado(s) com sucesso!',
      cor: Colors.green,
    );
  }
}

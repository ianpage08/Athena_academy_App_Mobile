import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/lesson/widget/build_section_card.dart';
import 'package:provider/provider.dart';
import 'package:portal_do_aluno/features/admin/helper/anexo_helper.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/user_provider.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/lesson/controller/lesson_controller.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/lesson/widget/attach_section.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/lesson/widget/lesson_content_section.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/lesson/widget/lesson_info_section.dart';
import 'package:portal_do_aluno/shared/helpers/app_snackbar.dart';
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

  // O SaveButton agora gerencia o próprio loading!

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

  

  Future<void> _onAttachPressed(BuildContext context) async {
    // 1. Esconde o teclado para evitar bugs visuais ao abrir a galeria
    FocusScope.of(context).unfocus();

    final images = await getImage();
    if (!mounted) return;

    if (images.isEmpty && mounted) {
      showAppSnackBar(
        
        context: context,
        mensagem: 'Nenhum arquivo selecionado.',
        
        cor: Theme.of(context).colorScheme.secondary,
      );
      return;
    }

    controller.imgSelected
      ..clear()
      ..addAll(images);

    setState(() {}); // Atualiza a contagem de anexos na UI
    
    showAppSnackBar(
      context: context,
      mensagem: '${images.length} arquivo(s) anexado(s) com sucesso!',
      
      cor: const Color(0xFF34D399),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserProvider>().userId;
    final theme = Theme.of(context);

    
    return Scaffold(
      appBar: const CustomAppBar(title: 'Conteúdo Ministrado'),

      
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
          onSave: () async {
            FocusScope.of(context).unfocus(); // Abaixa o teclado ao salvar

            if (userId == null) {
              showAppSnackBar(
                context: context,
                mensagem: 'Usuário não identificado. Faça login novamente.',
                cor: theme.colorScheme.error,
              );
              return;
            }

            
            // ativando o loader do próprio SaveButton. Não precisamos de setState externo!
            await controller.submit(userId);
          },
        ),
      ),

      body: GestureDetector(
        onTap: () =>
            FocusScope.of(context).unfocus(), // UX: Toque fora fecha o teclado
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
          child: Center(
            child: ConstrainedBox(
              // Mantém o limite de largura para Web/Tablet, excelente prática!
              constraints: const BoxConstraints(maxWidth: 720),

              
              // Agora a tela respira através de Chunking Modular (Cards independentes).
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildSectionCard(
                    title: '1. Informações Básicas',
                    child: LessonInfoSection(controller: controller),
                  ),
                  BuildSectionCard(
                    
                    title: '2. Detalhes da Aula',
                    child: LessonContentSection(controller: controller),
                  ),
                  BuildSectionCard(
                    title: '3. Material de Apoio',
                    child: AttachSection(
                      attachedCount: controller.imgSelected.length,
                      onAttach: () => _onAttachPressed(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

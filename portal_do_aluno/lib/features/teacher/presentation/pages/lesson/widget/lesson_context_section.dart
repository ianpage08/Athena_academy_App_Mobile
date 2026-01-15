import 'package:flutter/cupertino.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/lesson/controller/lesson_controller.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';


class LessonContentSection extends StatelessWidget {
  final LessonController controller;

  const LessonContentSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          prefixIcon: CupertinoIcons.book,
          maxLines: 5,
          controller: controller.conteudoController,
          label: 'Conteúdo',
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          prefixIcon: CupertinoIcons.doc_text,
          maxLines: 3,
          controller: controller.observacoesController,
          label: 'Observações',
        ),
      ],
    );
  }
}

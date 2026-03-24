import 'package:flutter/cupertino.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/lesson/controller/lesson_controller.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';

/// Seção responsável pela entrada de dados do conteúdo ministrado.
///
/// Arquitetura e UX:
/// - Desacoplamento visual: Mantém a tela principal limpa.
/// - UX Microcopy: Inclusão de `hintTexts` para guiar a ação do usuário.
/// - Regra de Negócio: Definição correta de campos obrigatórios vs opcionais.
class LessonContentSection extends StatelessWidget {
  final LessonController controller;

  const LessonContentSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          controller: controller.conteudoController,
          label: 'Conteúdo Ministrado',

          hintText: 'Ex: Introdução à termodinâmica e leis da física...',
          prefixIcon: CupertinoIcons.book,

          minLines: 3,
          maxLines: 5,
          obrigatorio: true, // É o core da aula, não pode ser vazio
        ),

        const SizedBox(height: 24),

        CustomTextFormField(
          controller: controller.observacoesController,

          label: 'Observações (Opcional)',
          hintText: 'Algum comportamento atípico ou recado sobre a turma?',
          prefixIcon: CupertinoIcons.doc_text,
          minLines: 2,
          maxLines: 3,

          obrigatorio: false,
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/lesson/controller/lesson_controller.dart';
import 'package:portal_do_aluno/shared/widgets/select_class_button.dart';
import 'package:portal_do_aluno/shared/widgets/custom_date_picker_field.dart';
import 'package:portal_do_aluno/shared/widgets/firestore/firestore_dropdown_field.dart';

/// Seção de informações básicas da aula (Turma, Disciplina e Data).
///
/// Arquitetura e UX:
/// - Implementação de Rótulos (Labels) externos para manter o contexto visual.
/// - Padronização do Design System usando o novo `FirestoreDropdownField`.
/// - Alinhamento à esquerda (CrossAxisAlignment.start) para leitura em "F" (Padrão web/mobile).
class LessonInfoSection extends StatelessWidget {
  final LessonController controller;

  const LessonInfoSection({super.key, required this.controller});

  
  Widget _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Theme.of(
            context,
          ).textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
          letterSpacing: 0.3, // Dá um ar mais moderno e legível
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- TURMA ---
        _buildLabel(context, 'Turma'),
        SelectClassButton(
          turmaSelecionada: controller.turmaSelecionada,
          onTurmaSelecionada: (id, _) => controller.turmaId = id,
        ),

        
        const SizedBox(height: 20),

        // --- DISCIPLINA ---
        _buildLabel(context, 'Disciplina'),

        
        // OBS: Envolvi num ValueListenableBuilder assumindo que seu controller
        // tem uma variável reativa para a disciplina selecionada, para a UI refletir a escolha.
        ValueListenableBuilder<String?>(
          valueListenable: controller
              .disciplinaSelecionada, // Certifique-se de ter essa variável no controller
          builder: (context, disciplinaNome, _) {
            return FirestoreDropdownField(
              tipo: 'disciplina',
              titulo: 'Selecione a Disciplina',
              stream: controller.getDisciplinas(),
              selecionado: disciplinaNome,
              // Usando um ícone do Cupertino para manter o visual "Apple-like" clean
              icon: CupertinoIcons.book_fill,
              onSelected: (id, nome) {
                controller.disciplinaId = id;
                // Atualiza o visual para o usuário ver o que selecionou
                controller.disciplinaSelecionada.value = nome;
              },
            );
          },
        ),

        const SizedBox(height: 20),

        // --- DATA DA AULA ---
        _buildLabel(context, 'Data da Aula'),
        CustomDatePickerField(
          // Supondo que o CustomDatePickerField já siga a nossa identidade visual!
          onDate: (data) => controller.dataSelecionada = data,
        ),
      ],
    );
  }
}

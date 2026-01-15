import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/lesson/controller/lesson_controller.dart';
import 'package:portal_do_aluno/shared/widgets/select_class_button.dart';
import 'package:portal_do_aluno/shared/widgets/custom_date_picker_field.dart';
import 'package:portal_do_aluno/shared/widgets/firestore/firestore_select_button.dart';

class LessonInfoSection extends StatelessWidget {
  final LessonController controller;

  const LessonInfoSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectClassButton(
          turmaSelecionada: controller.turmaSelecionada,
          onTurmaSelecionada: (id, _) => controller.turmaId = id,
        ),
        const SizedBox(height: 16),
        FirestoreSelectButton(
          dropId: 'disciplina',
          minhaStream: controller.getDisciplinas(),
          mensagemError: 'Nenhuma disciplina encontrada',
          textLabel: 'Disciplina',
          nomeCampo: 'nome',
          icon: const Icon(Icons.menu_book),
          onSelected: (id, _) => controller.disciplinaId = id,
        ),
        const SizedBox(height: 16),
        CustomDatePickerField(
          onDate: (data) => controller.dataSelecionada = data,
        ),
      ],
    );
  }
}

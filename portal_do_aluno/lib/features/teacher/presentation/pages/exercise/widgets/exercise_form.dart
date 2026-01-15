import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/exercise/controller/create_exercise_controller.dart';
import 'package:portal_do_aluno/shared/widgets/custom_date_picker_field.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';
import 'package:portal_do_aluno/shared/widgets/select_class_button.dart';

class ExerciseForm extends StatelessWidget {
  final CreateExerciseController controller;

  const ExerciseForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section('Turma'),
            SelectClassButton(
              turmaSelecionada: controller.turmaSelecionada,
              onTurmaSelecionada: (id, nome) {
                controller.turmaId = id;
                controller.turmaSelecionada.value = nome;
              },
            ),

            const SizedBox(height: 24),
            const Divider(),

            _section('Conteúdo do Exercício'),
            CustomTextFormField(
              prefixIcon: Icons.title,
              controller: controller.tituloController,
              hintText: 'Ex: Atividade para casa',
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              prefixIcon: Icons.notes,
              controller: controller.conteudoController,
              maxLines: 4,
              hintText: 'Resolver exercícios da página 10 a 20',
            ),

            const SizedBox(height: 24),
            const Divider(),

            _section('Data de Entrega'),
            CustomDatePickerField(
              isSelecionada: controller.dataSelecionada,
              onDate: (data) => controller.dataSelecionada = data,
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/lesson/widget/build_section_card.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/send_exercise/controller/create_exercise_controller.dart';
import 'package:portal_do_aluno/shared/widgets/custom_date_picker_field.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';
import 'package:portal_do_aluno/shared/widgets/select_class_button.dart';

// Se o nome ou caminho for diferente, basta ajustar!
// import 'package:portal_do_aluno/shared/widgets/athena_section_card.dart';

class ExerciseForm extends StatelessWidget {
  final CreateExerciseController controller;

  const ExerciseForm({super.key, required this.controller});


  Widget _buildInputLabel(BuildContext context, String text) {
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
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- BLOCO 1: PÚBLICO ALVO ---
        BuildSectionCard(
          
          title: '1. Público Alvo',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputLabel(context, 'Turma Destino'),
              SelectClassButton(
                turmaSelecionada: controller.turmaSelecionada,
                onTurmaSelecionada: (id, nome) {
                  controller.turmaId = id;
                  controller.turmaSelecionada.value = nome;
                },
              ),
            ],
          ),
        ),

        // --- BLOCO 2: CONTEÚDO ---
        BuildSectionCard(
          
          title: '2. Detalhes da Atividade',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              CustomTextFormField(
                prefixIcon: CupertinoIcons.text_cursor, // Ícones Apple-like
                controller: controller.tituloController,
                label: 'Título do Exercício',
                hintText: 'Ex: Lista de Equações do 2º Grau',
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                prefixIcon: CupertinoIcons.paragraph,
                controller: controller.conteudoController,
                label: 'Instruções',
                hintText:
                    'Ex: Resolver os exercícios da página 10 a 20 e anexar a foto do caderno.',
                minLines: 3, 
                maxLines: 5,
              ),
            ],
          ),
        ),

        // --- BLOCO 3: PRAZOS ---
        BuildSectionCard(
          
          title: '3. Prazo de Entrega',
          child: CustomDatePickerField(
            isSelecionada: controller.dataSelecionada,
            onDate: (data) => controller.dataSelecionada = data,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/calendar_event_type.dart';
import 'package:portal_do_aluno/shared/widgets/custom_date_picker_field.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';
import 'package:portal_do_aluno/shared/widgets/save_button.dart';

class CreateCalendarEventModal extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController tituloController;
  final TextEditingController descricaoController;
  final CalendarEventType tipo;
  final bool isLoading;
  final DateTime onDateSelected;
  final VoidCallback onSubmit;

  const CreateCalendarEventModal({
    super.key,
    required this.formKey,
    required this.tituloController,
    required this.descricaoController,
    required this.tipo,
    required this.onDateSelected,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Text(
                    'Novo ${tipo.name}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Preencha os dados do evento',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Título
            CustomTextFormField(
              prefixIcon: Icons.title,
              controller: tituloController,
              label: 'Título',
            ),

            const SizedBox(height: 16),

            // Descrição
            CustomTextFormField(
              prefixIcon: Icons.description,
              controller: descricaoController,
              label: 'Descrição',
            ),
            const SizedBox(height: 16),

            // Data
            CustomDatePickerField(
              isSelecionada: onDateSelected,
              onDate: (data) => onDateSelected,
            ),

            const SizedBox(height: 24),

            // Ação
            SaveButton(salvarconteudo: () async => onSubmit),
          ],
        ),
      ),
    );
  }
}
